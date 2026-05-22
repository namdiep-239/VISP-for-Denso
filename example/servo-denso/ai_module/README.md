# AI Module — Automatic Cylinder Detection for ViSP-for-Denso

## What this module does

Replaces manual click-based blob tracking with AI-based cylinder detection.
An EfficientDet-Lite0 model (Google Coral EdgeTPU or CPU fallback) is called
as a Python subprocess by the C++ application at two points in the state machine:

| State | Call | Purpose |
|---|---|---|
| `INIT` | Once, when robot reaches init pose | Detect cylinder, initialize visual feature `ai_hint` |
| `JOINT` | Every servo step (when `reached`) | Re-detect cylinder, update `ai_hint` for the control law |

The C++ function `detectCylinderWithAI()` drives both calls. If detection fails
at any step, `ai_hint` retains its last valid value and the servo continues —
the robot never stops due to an AI failure.

## Dependencies

### Option A — Python 3.9 with gesture_env (supports Coral EdgeTPU)

```bash
source /home/nam/.pyenv/versions/3.9.17/envs/gesture_env/bin/activate
pip install pycoral tflite-runtime opencv-python numpy
```

EdgeTPU system runtime (required for Coral hardware):
<https://coral.ai/docs/accelerator/get-started/#runtime-on-linux>

### Option B — System Python 3.10+ (CPU only)

```bash
pip install ai-edge-litert opencv-python numpy
```

`tflite-runtime` has no Python 3.10 wheels; `ai-edge-litert` is the official
Google replacement with identical API.

## Backend fallback order

At runtime the script tries each backend in order and stops at the first that works:

```
1. pycoral (EdgeTPU)     — fastest, requires Coral device + gesture_env
2. ai_edge_litert (CPU)  — Python 3.10+
3. tflite_runtime (CPU)  — Python 3.9 / gesture_env
4. tensorflow (CPU)      — heavy last resort
```

## Model files

| File | Purpose |
|---|---|
| `models/cylinder_detector_int8_edgetpu.tflite` | EdgeTPU-compiled (Coral only) |
| `models/cylinder_detector_int8.tflite` | Standard INT8 TFLite (CPU) |

The `_edgetpu.tflite` model contains a custom op that **cannot** run on CPU.
The script automatically selects the correct model based on hardware availability.

## Configuration — config.json

```json
{
  "model_path":           "ai_module/models/cylinder_detector_int8_edgetpu.tflite",
  "cpu_model_path":       "ai_module/models/cylinder_detector_int8.tflite",
  "confidence_threshold": 0.5,
  "image_size":           320,
  "class_names":          ["cylinder"],
  "python_bin":           "python3"
}
```

| Field | Description |
|---|---|
| `model_path` | EdgeTPU model path (relative to binary working directory) |
| `cpu_model_path` | CPU model path used when EdgeTPU is unavailable |
| `confidence_threshold` | Detections below this score are ignored (0.0–1.0) |
| `python_bin` | Python interpreter to use — `"python3"` works on any machine |

`//` comment lines are supported and stripped before parsing, so you can annotate
the file freely:
```json
  // "python_bin": "/home/nam/.pyenv/versions/3.9.17/envs/gesture_env/bin/python3"
  "python_bin": "python3"
```

## Standalone test

Run from `example/servo-denso/` (the directory where the binary executes):

```bash
cd ~/Coding/VISP-for-Denso-main/example/servo-denso

python3 ai_module/detect_cylinder.py /path/to/image.jpg
```

Expected stdout (one line):
```
SUCCESS 272.86 190.74 0.8362 238.42 166.89 68.88 47.68
         u      v     conf   x_min  y_min  width height
```
or:
```
FAILURE no_detection
```

All debug messages (`[Coral] ...`, `[CPU] ...`) go to **stderr only** and are
invisible to the C++ parser.

## Integration with the C++ application

The C++ function signature:
```cpp
bool detectCylinderWithAI(const vpImage<unsigned char> &I,
                          vpImagePoint &detected_center,
                          const std::string &config_path = "ai_module/config.json",
                          const vpImagePoint *hint = nullptr);
```

**Steps inside the function:**
1. Convert grayscale `vpImage` → BGR `cv::Mat`, save to `/tmp/visp_ai_frame.jpg`
2. Read `python_bin` from `config.json` (supports `//` comments via nlohmann `ignore_comments`)
3. Spawn: `python3 ai_module/detect_cylinder.py /tmp/visp_ai_frame.jpg`
4. Wait up to **3 seconds** via `select()` for one line on stdout
5. Parse `SUCCESS u v conf ...` → set `detected_center = vpImagePoint(v, u)`, return `true`
6. Any `FAILURE` or timeout → return `false`, `detected_center` unchanged

**INIT state** — called once, no hint:
```
detectCylinderWithAI(I, ai_hint)
  └─ SUCCESS → ai_hint set, visual feature initialized, proceed to JOINT
  └─ FAILURE → ai_hint stays at (0,0), servo may behave unexpectedly
```

**JOINT state** — called every servo step, passes last known position as hint:
```
detectCylinderWithAI(I, ai_hint, "ai_module/config.json", &ai_hint)
  └─ SUCCESS → ai_hint updated, control law recomputed
  └─ FAILURE → ai_hint unchanged (holds last valid position), servo continues
```

## Fallback and failure modes

| Failure | Behaviour |
|---|---|
| Config file missing | `return false` — `ai_hint` unchanged |
| `//` comment in JSON | Stripped before parsing — no error |
| EdgeTPU not connected | Warning to stderr, falls back to CPU automatically |
| No TFLite backend installed | `FAILURE no_tflite_backend_available` → `return false` |
| Subprocess timeout (> 3 s) | `return false` — `ai_hint` unchanged |
| Confidence below threshold | `FAILURE no_detection` → `return false` |
| JOINT step lost detection | Servo holds last `ai_hint` — no oscillation or crash |

## Updating the model

1. Copy the new `.tflite` files into `ai_module/models/`
2. Update `model_path` and `cpu_model_path` in `config.json`
3. Adjust `confidence_threshold` if needed (run score analysis on test images first)
4. No C++ recompilation required

## File layout

```
example/servo-denso/
├── ai_module/
│   ├── models/
│   │   ├── cylinder_detector_int8_edgetpu.tflite  — EdgeTPU model (Coral)
│   │   └── cylinder_detector_int8.tflite          — CPU model (fallback)
│   ├── detect_cylinder.py  — inference script, called by C++ subprocess
│   ├── config.json         — model paths, threshold, python binary
│   └── README.md           — this file
└── servoDenso6577FourPoints2DArtVelocityLs_des.cpp  — main application
```
