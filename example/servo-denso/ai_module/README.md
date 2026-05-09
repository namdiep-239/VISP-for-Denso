# AI Module — Automatic Cube Detection for ViSP-for-Denso

## What this module does

Replaces the manual click-to-init blob tracking with automatic AI-based detection.
When the robot reaches its init pose, `detectCubeWithAI()` in the C++ application
calls `detect_cube.py` as a subprocess, which runs an EfficientDet-Lite0 model on
a Google Coral EdgeTPU to locate the cube in the current camera frame.
If detection succeeds, the blob tracker is initialised automatically at the detected
centre. If detection fails for any reason, the application falls back to the original
manual click behaviour — existing functionality is never broken.

## Dependencies

Install inside the `gesture_env` pyenv environment:

```bash
# Activate environment
source /home/nam/.pyenv/versions/3.9.17/envs/gesture_env/bin/activate

# Google Coral runtime (requires Coral USB/PCIe device)
pip install pycoral tflite-runtime

# OpenCV and NumPy (usually already present)
pip install opencv-python numpy
```

The EdgeTPU runtime library must also be installed at the system level:
<https://coral.ai/docs/accelerator/get-started/#runtime-on-linux>

## Standalone test

From the `example/servo-denso/` directory (where the binary runs):

```bash
/home/nam/.pyenv/versions/3.9.17/envs/gesture_env/bin/python3 \
    ai_module/detect_cube.py /path/to/test_image.jpg
```

Expected output on stdout (one line):
```
SUCCESS 312.40 240.15 0.8732 248.20 192.30 128.40 95.70
```
or:
```
FAILURE no_detection
```

Debug/info messages (EdgeTPU load, fallback warnings) go to **stderr** only.

## Integration with the C++ application

1. At the INIT state, after the robot reaches its init joint pose, the C++ code calls
   `detectCubeWithAI(I, ai_hint)`.
2. The function saves the current frame to `/tmp/visp_ai_frame.jpg`, then spawns
   `detect_cube.py` as a subprocess with a 3-second timeout.
3. If the script outputs `SUCCESS u v ...`, the blob tracker is initialised at
   `vpImagePoint(v, u)` automatically.
4. If the script outputs `FAILURE ...` or the timeout fires, a warning is printed and
   `dot.initTracking(I)` is called without a hint (original manual-click behaviour).

## Fallback behaviour

The AI detection path is wrapped in a try/fallback at every level:
- EdgeTPU unavailable → CPU TFLite (tflite_runtime or tensorflow)
- No TFLite backend → `FAILURE no_tflite_backend_available`
- Python subprocess timeout (> 3 s) → fallback to manual click
- Any `FAILURE` result → fallback to manual click

The robot will always reach the tracking phase, regardless of AI detection status.

## Updating the model

1. Copy or symlink the new `.tflite` file into `ai_module/models/`.
2. Update `"model_path"` in `ai_module/config.json`.
3. Optionally adjust `"confidence_threshold"` if the new model has different score
   calibration (typical range: 0.3 – 0.7).
4. No recompilation of the C++ code is required.

## File layout

```
example/servo-denso/
├── ai_module/
│   ├── models/
│   │   └── cube_detector_int8_edgetpu.tflite  (symlink to reference project)
│   ├── detect_cube.py   — inference script called by C++ subprocess
│   ├── config.json      — model path, threshold, python binary path
│   └── README.md        — this file
└── servoDenso6577FourPoints2DArtVelocityLs_des.cpp  — main app (modified)
```
