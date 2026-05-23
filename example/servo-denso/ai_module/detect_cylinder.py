#!/usr/bin/env python3
"""
Single-image cylinder detection for ViSP-for-Denso integration.
Called as a subprocess by the C++ application.

Usage:
    python3 detect_cylinder.py <image_path>

Stdout (exactly one line, no extras):
    SUCCESS <u_center> <v_center> <confidence> <x_min> <y_min> <width> <height>
    FAILURE no_detection
    FAILURE <error_message>

All debug/warning output goes to stderr only.
"""

import sys
import os
import json
from pathlib import Path

import cv2
import numpy as np

SCRIPT_DIR = Path(__file__).parent.resolve()
CONFIG_PATH = SCRIPT_DIR / "config.json"


def load_config():
    if not CONFIG_PATH.exists():
        print(f"FAILURE config_not_found:{CONFIG_PATH}", flush=True)
        sys.exit(1)
    with open(CONFIG_PATH) as f:
        # Strip // comment lines so config.json can hold human notes
        content = "\n".join(
            line for line in f if not line.lstrip().startswith("//")
        )
    return json.loads(content)


def resolve_model_path(model_path_str):
    """Try path as-is (absolute or relative to CWD), then relative to models/ dir."""
    p = Path(model_path_str)
    if p.is_absolute() and p.exists():
        return p
    cwd_rel = Path.cwd() / p
    if cwd_rel.exists():
        return cwd_rel
    # fall back: look in models/ next to this script
    script_rel = SCRIPT_DIR / "models" / p.name
    if script_rel.exists():
        return script_rel
    return None


def _suffix(detail):
    """Return integer suffix of a TFLite tensor name (e.g. 'output:1' -> 1).
    Used to distinguish scores (:1) from class IDs (:2) when both have shape [1,N].
    """
    try:
        return int(detail.get("name", "").rsplit(":", 1)[-1])
    except ValueError:
        return 999


def run_inference(interpreter, input_details, output_details, img_bgr):
    """Run one forward pass and return (boxes_pixel, scores, class_ids).

    boxes_pixel: list of [x1, y1, x2, y2] in pixel coordinates
    scores:      list of float confidence values (same length)
    class_ids:   list of int class indices (0=cylinder, 1=cube)

    Tensor identification is done by shape, not by fixed index, because
    tflite_model_maker 0.4.x uses :0=num_det, :1=scores, :2=classes, :3=boxes
    which does NOT match pycoral's assumed positional order.
    """
    INPUT_SIZE = input_details[0]['shape'][1]  # e.g. 320

    img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)
    inp = cv2.resize(img_rgb, (INPUT_SIZE, INPUT_SIZE)).astype(np.uint8)

    if input_details[0]['dtype'] == np.float32:
        inp = inp.astype(np.float32) / 255.0

    interpreter.set_tensor(input_details[0]['index'], inp[np.newaxis])
    interpreter.invoke()

    # Identify tensors by shape:
    #   boxes:   shape [1, N, 4]
    #   scores:  shape [1, N], lowest name suffix (:1)
    #   classes: shape [1, N], second-lowest suffix (:2)
    boxes_detail = None
    shape2_tensors = []
    for d in output_details:
        s = d['shape']
        if len(s) == 3 and s[2] == 4:
            boxes_detail = d
        elif len(s) == 2:
            shape2_tensors.append(d)

    sorted_s2 = sorted(shape2_tensors, key=_suffix)
    scores_detail = sorted_s2[0] if sorted_s2 else None
    classes_detail = sorted_s2[1] if len(sorted_s2) > 1 else None

    if boxes_detail is None or scores_detail is None:
        print("[WARN] Cannot identify output tensors by shape", file=sys.stderr)
        return [], [], []

    raw_boxes = interpreter.get_tensor(boxes_detail['index'])[0]   # [N, 4]
    raw_scores = interpreter.get_tensor(scores_detail['index'])[0]  # [N]

    # Dequantize uint8 outputs: float = scale * (q - zero_point)
    if scores_detail['dtype'] == np.uint8:
        sc, zp = scores_detail['quantization']
        scores = sc * (raw_scores.astype(np.float32) - zp)
    else:
        scores = raw_scores.astype(np.float32)

    if boxes_detail['dtype'] == np.uint8:
        sc, zp = boxes_detail['quantization']
        raw_boxes = sc * (raw_boxes.astype(np.float32) - zp)
    else:
        raw_boxes = raw_boxes.astype(np.float32)

    # Dequantize class IDs
    if classes_detail is not None:
        raw_cls = interpreter.get_tensor(classes_detail['index'])[0]  # [N]
        if classes_detail['dtype'] == np.uint8:
            sc, zp = classes_detail['quantization']
            class_ids = (sc * (raw_cls.astype(np.float32) - zp)).round().astype(int)
        else:
            class_ids = raw_cls.astype(int)
    else:
        class_ids = np.zeros(len(scores), dtype=int)  # single-class fallback

    # Normalized [ymin, xmin, ymax, xmax] -> pixel [x1, y1, x2, y2]
    h, w = img_bgr.shape[:2]
    boxes_pixel = []
    for ymin, xmin, ymax, xmax in raw_boxes:
        boxes_pixel.append([
            float(xmin * w), float(ymin * h),
            float(xmax * w), float(ymax * h),
        ])

    return boxes_pixel, scores.tolist(), class_ids.tolist()


def main():
    if len(sys.argv) < 2:
        print("FAILURE missing_image_path", flush=True)
        sys.exit(1)

    image_path = sys.argv[1]

    cfg = load_config()
    threshold = cfg.get("confidence_threshold", 0.5)

    # EdgeTPU model path (pycoral only — contains custom op, cannot run on plain CPU)
    edgetpu_path_str = cfg.get("model_path", "ai_module/models/cylinder_detector_int8_edgetpu.tflite")
    # CPU model path (standard int8 TFLite, no EdgeTPU custom op)
    cpu_path_str = cfg.get("cpu_model_path", "ai_module/models/cylinder_detector_int8.tflite")

    img_bgr = cv2.imread(image_path)
    if img_bgr is None:
        print(f"FAILURE cannot_read_image:{image_path}", flush=True)
        sys.exit(1)

    # Load interpreter: try Coral EdgeTPU first, then CPU TFLite.
    # IMPORTANT: _edgetpu.tflite contains an EdgeTPU custom op that tflite_runtime
    # cannot execute on CPU — always use the plain int8 model for CPU fallback.
    interpreter = None
    USE_CORAL = False

    edgetpu_path = resolve_model_path(edgetpu_path_str)
    if edgetpu_path is not None:
        try:
            from pycoral.utils.edgetpu import make_interpreter
            interpreter = make_interpreter(str(edgetpu_path))
            interpreter.allocate_tensors()
            USE_CORAL = True
            print(f"[Coral] Loaded EdgeTPU model: {edgetpu_path.name}", file=sys.stderr)
        except Exception as e:
            print(f"[Coral] EdgeTPU unavailable ({e}), falling back to CPU", file=sys.stderr)
    else:
        print(f"[Coral] EdgeTPU model not found: {edgetpu_path_str}", file=sys.stderr)

    if not USE_CORAL:
        cpu_path = resolve_model_path(cpu_path_str)
        if cpu_path is None:
            print(f"FAILURE cpu_model_not_found:{cpu_path_str}", flush=True)
            sys.exit(1)

        # Try each CPU backend in order; stop at the first that works.
        # ai_edge_litert: Google's current package (replaces tflite_runtime, supports Py 3.10+)
        # tflite_runtime: legacy package (Python 3.9 / gesture_env)
        # tensorflow:     heavy fallback, same Interpreter API
        for _load in [
            lambda: __import__("ai_edge_litert.interpreter", fromlist=["Interpreter"]).Interpreter,
            lambda: __import__("tflite_runtime.interpreter", fromlist=["Interpreter"]).Interpreter,
            lambda: __import__("tensorflow", fromlist=[""]).lite.Interpreter,
        ]:
            try:
                InterpreterCls = _load()
                interpreter = InterpreterCls(model_path=str(cpu_path))
                interpreter.allocate_tensors()
                print(f"[CPU] Loaded {cpu_path.name}", file=sys.stderr)
                break
            except (ImportError, AttributeError):
                continue

    if interpreter is None:
        print("FAILURE no_tflite_backend_available", flush=True)
        sys.exit(1)

    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    boxes, scores, class_ids = run_inference(interpreter, input_details, output_details, img_bgr)

    # class 0 = cylinder, class 1 = cube — keep only cylinders above threshold
    candidates = [
        (b, s) for b, s, c in zip(boxes, scores, class_ids)
        if s >= threshold and c == 0
    ]

    if not candidates:
        print("FAILURE no_detection", flush=True)
        return

    best_box, best_score = max(candidates, key=lambda x: x[1])
    x1, y1, x2, y2 = best_box
    width = x2 - x1
    height = y2 - y1
    u_center = x1 + width / 2.0
    v_center = y1 + height / 2.0

    print(
        f"SUCCESS {u_center:.2f} {v_center:.2f} {best_score:.4f} "
        f"{x1:.2f} {y1:.2f} {width:.2f} {height:.2f}",
        flush=True
    )


if __name__ == "__main__":
    main()
