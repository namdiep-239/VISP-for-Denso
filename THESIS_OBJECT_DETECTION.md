# Thesis Context: AI Object Detection Integration into ViSP Visual Servoing for Denso VS-6577E

> This document is a complete technical reference for writing a Master's thesis report
> on the integration of an AI-based object detection module into a ViSP visual servoing
> application for the Denso VS-6577E robot arm.

---

## 1. Project Overview

### Objective
Automate the initialization of visual servoing for a pick-and-place robot arm by replacing
the manual operator click with an AI-based object detection system. Additionally, provide
automatic recovery if the visual tracker loses the target during the servo loop.

### Before (Original System)
- Robot moves to a fixed home pose
- **Operator must click on the cylinder** in the camera window to start the blob tracker
- Visual servo runs, robot approaches and grips the cylinder
- If the blob tracker loses the target → robot resets entirely (PREINIT)

### After (Modified System)
- Robot moves to home pose
- **AI automatically detects the cylinder** and initializes the blob tracker
- If detection fails → fall back to manual click (original behaviour preserved)
- Visual servo runs with blob tracking
- If blob tracker loses target during servo → **AI re-detects and re-initializes** automatically
- No operator intervention needed in the normal case

---

## 2. Hardware

| Component | Details |
|---|---|
| Robot arm | Denso VS-6577E, 6-DOF articulated arm |
| Camera | USB camera, device `/dev/video2`, eye-in-hand configuration |
| Gripper | Custom gripper, UART serial at `/dev/ttyACM0`, 115200 baud, JSON protocol |
| AI accelerator | Google Coral EdgeTPU USB/PCIe (optional; CPU fallback always available) |
| Host PC | Ubuntu Linux, x86_64 |

### Camera Configuration
- Intrinsic parameters loaded from `camera.xml` (perspective projection with distortion)
- Extrinsic parameters (end-effector to camera transform `eMc`) loaded from `rc5_ePc.yaml`
- Eye-in-hand configuration: camera mounted on robot end-effector

---

## 3. Software Architecture

### Programming Languages and Frameworks
| Component | Language | Framework/Library |
|---|---|---|
| Robot control | C++17 | ViSP 3.x (Visual Servoing Platform) |
| Object detection | Python 3.9 / 3.10 | TFLite / pycoral / ai-edge-litert |
| Camera capture | C++ | OpenCV (VideoCapture via V4L2) |
| Communication | C++ | nlohmann/json, serialib (UART) |

### Key Libraries
- **ViSP (visp3)**: Visual Servoing Platform — provides blob tracking (`vpDot2`), visual
  features (`vpFeaturePoint`), servo task (`vpServo`), robot interface (`vpRobotDenso6577`)
- **OpenCV**: Camera frame capture, image format conversion, saving frames to disk
- **nlohmann/json**: JSON parsing for gripper UART protocol and AI config file
- **pycoral**: Google Coral EdgeTPU Python interface (Python 3.9 only)
- **tflite-runtime / ai-edge-litert**: CPU TFLite inference (Python 3.9 / 3.10+)

---

## 4. State Machine

The system runs a continuous main loop with 7 states:

```
PREINIT → INIT → JOINT → APPROACH → GRIPPER → CLASSIFIED → (back to PREINIT)
                  ↑________↓  (on tracking loss: AI re-init, stay in JOINT)
```

### State Descriptions

| State | Description |
|---|---|
| `PREINIT` | Send robot to home joint pose `[0°, 0°, 90°, 0°, 90°, 0°]`, configure servo task |
| `INIT` | Open gripper; when pose reached, **AI detects cylinder → blob tracker initialized** |
| `JOINT` | Visual servoing loop: blob tracks cylinder, control law drives robot toward target |
| `APPROACH` | Wait for external RC5 signal that robot has approached target |
| `GRIPPER` | Close gripper to grasp cylinder |
| `CLASSIFIED` | Move robot to drop-off pose `[53.35°, 25.15°, 91.58°, 0°, 63.27°, ...]`, cycle restarts |
| `NEXT_STEP` | Reserved for future extension |

### INIT State — AI Initialization (Key Contribution)

```cpp
// When robot reaches home pose:
vpImagePoint ai_hint;
if (detectCylinderWithAI(I, ai_hint)) {
    // SUCCESS: blob tracker starts at AI-detected pixel
    dot.initTracking(I, ai_hint);
} else {
    // FAILURE: fall back to original manual click
    dot.initTracking(I);
}
cog = dot.getCog();
vpFeatureBuilder::create(p, cam, dot);
```

### JOINT State — Blob Tracking with AI Recovery

```cpp
try {
    dot.track(I);            // normal: vpDot2 blob tracker (fast, per-frame)
    cog = dot.getCog();
}
catch (const vpTrackingException &e) {
    // Blob lost — AI re-detects and re-initializes
    vpImagePoint ai_hint;
    if (detectCylinderWithAI(I, ai_hint)) {
        dot.initTracking(I, ai_hint);   // auto recovery
    } else {
        dot.initTracking(I);            // manual click recovery
        continue;
    }
    cog = dot.getCog();
    vpFeatureBuilder::create(p, cam, dot);
}
vpFeatureBuilder::create(p, cam, dot);
// ... compute control law, send joint velocities
```

### Convergence Criterion
```cpp
if (abs(task.getError()[0]) < 5e-3 && abs(task.getError()[1]) < 5e-3) {
    // Converged: send "OKE\r" via UART to RC5 controller
    state = APPROACH;
}
```

### Visual Servo Parameters
| Parameter | Value |
|---|---|
| Control law | Eye-in-hand, velocity in articular (joint) frame |
| Interaction matrix | Desired (`Ls*`), pseudo-inverse |
| Servo gain λ | 0.4 |
| Time step `delta_t` | 0.5 s |
| Convergence threshold | `|e[0]| < 5×10⁻³` AND `|e[1]| < 5×10⁻³` |
| Visual feature | 2D image point `(x, y)` at normalized coordinates, Z=1 |
| Desired position | `(x*, y*) = (0, 0)` — center of image |

---

## 5. AI Object Detection Module

### Location
```
example/servo-denso/ai_module/
├── models/
│   ├── cylinder_detector_int8_edgetpu.tflite  — EdgeTPU model (Coral)
│   └── cylinder_detector_int8.tflite          — CPU model (fallback)
├── detect_cylinder.py   — inference script
├── config.json          — runtime configuration
└── README.md
```

### Model: EfficientDet-Lite0

| Property | Value |
|---|---|
| Architecture | EfficientDet-Lite0 |
| Training framework | TensorFlow / tflite_model_maker 0.4.x |
| Input size | 320 × 320 px |
| Input dtype | uint8 |
| Quantization | INT8 (post-training quantization) |
| Object class | `cylinder` (single class) |
| EdgeTPU model | `cylinder_detector_int8_edgetpu.tflite` (compiled with `edgetpu_compiler`) |
| CPU model | `cylinder_detector_int8.tflite` (standard TFLite, no custom ops) |

### Model Performance (on test set)
| Metric | Value |
|---|---|
| mAP | ~0.71 |
| AP50 | ~0.99 |
| Precision | ~0.98 |
| Recall | 1.00 |
| F1 | ~0.99 |

### Confidence Score Analysis
Tested on 218 cylinder images and 10 non-cylinder (cube) images:

| Category | Score range | Notes |
|---|---|---|
| True positives (cylinders) | 0.29 – 0.98, **median 0.94** | 99.1% score above 0.70 |
| False positives (non-cylinders) | 0.08 – 0.36 | **None exceed 0.50** |

Gap between false positives (max 0.36) and true positives (99.1% above 0.70) is 0.34 —
strong class separation confirming the model has learned discriminative cylinder features.

Current threshold: **0.50** (safely above all observed false positives).

---

## 6. Integration Architecture: C++ ↔ Python Subprocess

### Design Decision: Subprocess Model
The Python inference script is called as an **OS subprocess** from C++, not linked at
compile time. This means:
- Zero CMake changes for Python/TFLite dependencies
- AI module can be updated, replaced, or disabled without recompiling C++
- Clean separation between robot control code (C++) and inference code (Python)
- Language mismatch (C++ robot control, Python ML ecosystem) is cleanly bridged

### `detectCylinderWithAI()` — C++ Helper Function

```cpp
bool detectCylinderWithAI(const vpImage<unsigned char> &I,
                          vpImagePoint &detected_center,
                          const std::string &config_path = "ai_module/config.json",
                          const vpImagePoint *hint = nullptr);
```

**Step-by-step execution:**

1. **Save frame**: Convert grayscale `vpImage<unsigned char>` → BGR `cv::Mat` →
   JPEG at `/tmp/visp_ai_frame.jpg`
   ```cpp
   vpImageConvert::convert(I, gray_mat);
   cv::cvtColor(gray_mat, bgr_mat, cv::COLOR_GRAY2BGR);
   cv::imwrite("/tmp/visp_ai_frame.jpg", bgr_mat);
   ```

2. **Read config**: Open `ai_module/config.json`, parse with `nlohmann::json`
   (using `ignore_comments=true` to support `//` comment lines in config)

3. **Build command**:
   ```
   python3  ai_module/detect_cylinder.py  /tmp/visp_ai_frame.jpg
   ```
   If `hint != nullptr` (JOINT recovery mode), appends `--hint u v`

4. **Spawn subprocess**: `popen(cmd, "r")` — captures stdout

5. **Timeout**: POSIX `select()` with 3-second timeout on the pipe file descriptor.
   If timeout fires → `pclose()`, return `false`

6. **Parse result**: Read one line from stdout
   - `SUCCESS u v conf x y w h` → `detected_center = vpImagePoint(v, u)`, return `true`
   - `FAILURE ...` → print reason to stderr, return `false`

**All failure modes return `false`** — the caller always has a manual-click fallback.

### `detect_cylinder.py` — Python Inference Script

**Usage:**
```bash
python3 detect_cylinder.py <image_path> [--hint U V]
```

**Execution pipeline:**
```
Read image (cv2.imread)
    ↓
Load model (pycoral → tflite_runtime → ai_edge_litert → tensorflow)
    ↓
Preprocess: resize to 320×320, BGR→RGB, keep uint8
    ↓
interpreter.invoke()
    ↓
Identify output tensors by shape:
  boxes:  shape [1, N, 4]  (normalized [ymin, xmin, ymax, xmax])
  scores: shape [1, N]     (lowest name suffix :1, to avoid class IDs :2)
    ↓
Dequantize uint8: float = scale × (quantized − zero_point)
    ↓
Convert boxes: normalized → pixel coordinates
    ↓
Filter by confidence_threshold
    ↓
Select best detection (highest confidence)
    ↓
Compute center: u = x1 + w/2,  v = y1 + h/2
    ↓
Print: "SUCCESS u v conf x1 y1 width height"
```

**Output format (stdout, exactly one line):**
```
SUCCESS 272.86 190.74 0.8362 238.42 166.89 68.88 47.68
        u      v      conf   x_min  y_min  width height
```
or `FAILURE no_detection` / `FAILURE <reason>`

**All debug output goes to stderr** — C++ only reads stdout.

### Critical Implementation Detail: Tensor Identification by Shape

`tflite_model_maker` 0.4.x assigns output tensors in this order:
`:0` = num_detections, `:1` = scores, `:2` = class IDs, `:3` = boxes

This does **not** match pycoral's high-level `detect.get_objects()` API (which assumes
positional order `boxes/classes/scores/count = 0/1/2/3`). Using pycoral's API would
cause it to read num_detections as raw uint8 (value 255) instead of dequantizing to ~25,
crashing with IndexError.

**Solution**: identify tensors dynamically by shape:
- Boxes: shape `[1, N, 4]`
- Scores: shape `[1, N]` with the **lowest integer name suffix** (`:1` not `:2`)

### Critical Implementation Detail: Two Separate Models

The `_edgetpu.tflite` model contains an `edgetpu-custom-op` that **cannot be executed
by standard TFLite runtimes on CPU**. Attempting to load it with `tflite_runtime` on
CPU raises:
```
RuntimeError: Encountered unresolved custom op: edgetpu-custom-op
```

**Solution**: maintain two separate model files and use `cpu_model_path` in config
for the CPU path, pointing to `cylinder_detector_int8.tflite` (no custom ops).

---

## 7. Python Backend Fallback Chain

```
1. pycoral.utils.edgetpu.make_interpreter  ← Coral EdgeTPU (Python 3.9, gesture_env)
        ↓ ImportError or EdgeTPU not connected
2. ai_edge_litert.interpreter.Interpreter  ← Google's new package (Python 3.10+)
        ↓ ImportError
3. tflite_runtime.interpreter.Interpreter  ← Legacy package (Python 3.9)
        ↓ ImportError
4. tensorflow.lite.Interpreter             ← Heavy last resort
        ↓ ImportError
   FAILURE no_tflite_backend_available
```

`tflite-runtime` has no official Python 3.10 wheels. `ai-edge-litert` is Google's
official replacement with identical API, published to PyPI and supporting Python 3.8–3.12.

---

## 8. Configuration: config.json

```json
{
  "model_path":           "ai_module/models/cylinder_detector_int8_edgetpu.tflite",
  "cpu_model_path":       "ai_module/models/cylinder_detector_int8.tflite",
  "confidence_threshold": 0.5,
  "image_size":           320,
  "class_names":          ["cylinder"],
  // "python_bin": "/home/nam/.pyenv/versions/3.9.17/envs/gesture_env/bin/python3"
  "python_bin":           "python3"
}
```

The C++ parser uses `nlohmann::json::parse(file, nullptr, true, true)` where the
4th argument `ignore_comments=true` (available since nlohmann/json 3.9.0) strips
`//` comment lines before parsing, allowing annotated config files.

---

## 9. Gripper Control

The gripper communicates via UART (serialib library) using a JSON-based protocol.

| Command | JSON |
|---|---|
| Open | `{"T":121, "acc":20.0, "angle":1.7487, "spd":200.0}` |
| Close | `{"T":121, "acc":20.0, "angle":3.1447, "spd":200.0}` |
| Status | `{"T":105}` |

Response format: `{"T":1051,"load":<value>}\r`
- Open confirmed: `T=1051` and `load >= -150`
- Close confirmed: `T=1051` and `load <= -150`

---

## 10. Key Problems Solved During Development

### P1: EdgeTPU model cannot run on CPU
**Problem**: `_edgetpu.tflite` contains EdgeTPU custom ops — `tflite_runtime` raises
`RuntimeError: Encountered unresolved custom op: edgetpu-custom-op` when loaded on CPU.  
**Solution**: Separate model files for EdgeTPU and CPU paths, controlled via `config.json`.

### P2: Output tensor identification
**Problem**: `tflite_model_maker` 0.4.x tensor naming does not match pycoral's expected
positional order, causing `IndexError` when using `coral_detect.get_objects()`.  
**Solution**: Identify tensors dynamically by shape — boxes by `shape[2]==4`, scores
by shape `[1,N]` with lowest name suffix.

### P3: Python 3.10 compatibility
**Problem**: `tflite-runtime` has no official Python 3.10+ wheels.  
**Solution**: Add `ai-edge-litert` (Google's official replacement) to the fallback chain.

### P4: JSON comments in config
**Problem**: Standard `json.load()` (Python) and `nlohmann::json::parse()` (C++) both
reject `//` comment lines.  
**Solution**: Python strips comment lines before `json.loads()`; C++ uses
`nlohmann::json::parse(file, nullptr, true, true)` with `ignore_comments=true`.

### P5: Symlinked models not portable
**Problem**: Model files were symlinks to the training project — broken on other machines.  
**Solution**: Replaced symlinks with real file copies in `ai_module/models/`.

### P6: python_bin hardcoded path not portable
**Problem**: Absolute path `/home/nam/.pyenv/.../python3` fails on any other machine.  
**Solution**: Use `"python_bin": "python3"` — the OS resolves it via PATH.

### P7: Multi-cylinder confusion (in progress)
**Problem**: When multiple cylinders appear in the frame, the AI may detect the wrong
one, causing the servo to target an unintended cylinder.  
**Partial solution implemented**: `detectCylinderWithAI()` accepts an optional `hint`
parameter; when provided, Python selects the cylinder closest to the hint position
rather than highest confidence (not yet fully deployed — blob tracker handles JOINT
stability instead).

---

## 11. File Structure

```
VISP-for-Denso-main/
├── example/servo-denso/
│   ├── servoDenso6577FourPoints2DArtVelocityLs_des.cpp  ← main application
│   ├── CMakeLists.txt
│   ├── camera.xml          ← camera intrinsic parameters
│   ├── rc5_ePc.yaml        ← eye-to-hand extrinsic parameters
│   └── ai_module/
│       ├── models/
│       │   ├── cylinder_detector_int8_edgetpu.tflite
│       │   └── cylinder_detector_int8.tflite
│       ├── detect_cylinder.py
│       ├── config.json
│       └── README.md
└── THESIS_CONTEXT.md       ← this file
```

---

## 12. Build and Run

```bash
# Build (from ViSP build directory)
cd ~/visp-ws/visp-build
make -j$(nproc)

# Run (from the servo-denso binary directory)
cd ~/visp-ws/visp-build/example/servo-denso
./servoDenso6577FourPoints2DArtVelocityLs_des
```

**Required files at runtime** (relative to binary working directory):
- `camera.xml`
- `rc5_ePc.yaml`
- `ai_module/config.json`
- `ai_module/detect_cylinder.py`
- `ai_module/models/cylinder_detector_int8.tflite` (and/or edgetpu variant)

---

## 13. Test Results (Standalone Python Script)

Tested on the cylinder training dataset (218 images, CPU inference via ai-edge-litert):

```
Total images processed:  218
Detections above 0.50:   217/218  (99.5%)
Detections above 0.70:   216/218  (99.1%)
Detections above 0.80:   209/218  (95.9%)
Median confidence score: 0.94
```

3 low-scoring outlier images (scores 0.29, 0.61, 0.74) — likely unusual viewing angles
or partial occlusion. These would fall back to manual click at runtime.

False-positive test on 10 non-cylinder (cube) images: **max score 0.36**, all below
the 0.50 threshold — no false positives observed.

---

## 14. Current Limitations and Future Work

| Limitation | Description | Possible improvement |
|---|---|---|
| AI per-frame tracking unstable | Direct AI-based tracking every servo step oscillates due to inference latency (~100–200 ms/call) and confidence fluctuations | Use EdgeTPU for faster inference; add Kalman filter on detections |
| Multi-cylinder scene | AI picks highest-confidence, which can switch between cylinders | Deploy `--hint` closest-to-last-position strategy (implemented but not activated) |
| Grayscale frame to AI | Camera frame is captured as grayscale `vpImage`; converted to 3-channel BGR before saving — model trained on color images | Capture color frame separately for AI, keep grayscale for servo |
| Subprocess overhead | Each `popen()` call starts a new Python process (~200–500 ms on CPU, ~50 ms on EdgeTPU) | Persistent Python process with stdin/stdout protocol |
| Single-class model | Model only detects `cylinder` — no other objects | Extend training data for multi-class pick-and-place |

---

## 15. Terminology for Thesis Report

| Term | Definition |
|---|---|
| Visual servoing | Control law that uses visual information (image features) as feedback to drive a robot |
| Eye-in-hand | Camera mounted on the robot end-effector, moves with it |
| vpDot2 | ViSP blob tracker: tracks a bright/dark blob across frames using image moments |
| vpFeaturePoint | ViSP 2D image point feature `(x, y)` in normalized camera coordinates |
| vpServo | ViSP visual servo task: computes velocity from feature error `e = s - s*` |
| EfficientDet-Lite0 | Lightweight object detection architecture from Google, optimized for edge devices |
| EdgeTPU | Google Coral hardware accelerator for TFLite INT8 models, ~4 ms inference |
| INT8 quantization | Representing model weights as 8-bit integers; reduces size and enables EdgeTPU |
| pycoral | Python library for Google Coral EdgeTPU inference |
| ai-edge-litert | Google's new Python package replacing `tflite-runtime` for Python 3.10+ |
| subprocess model | Architecture where C++ spawns Python as a child process, communicates via stdout |
| tflite_model_maker | Google toolkit for training and exporting TFLite models with transfer learning |
