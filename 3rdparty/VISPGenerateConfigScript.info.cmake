
set(BUILD_SHARED_LIBS "ON")

set(CMAKE_BINARY_DIR "/home/nguyen/visp-ws/visp/3rdparty")

set(CMAKE_INSTALL_PREFIX "/usr")

set(BINARY_OUTPUT_PATH "/home/nguyen/visp-ws/visp/3rdparty/bin")

set(VISP_SOURCE_DIR "/home/nguyen/visp-ws/visp")

set(VISP_VERSION "3.7.1")

set(VISP_BINARY_DIR "/home/nguyen/visp-ws/visp/3rdparty")

set(VISP_LIB_INSTALL_PATH "lib")

set(VISP_BIN_INSTALL_PATH "bin")

set(VISP_INC_INSTALL_PATH "include")

set(VISP_3P_LIB_INSTALL_PATH "lib/visp/3rdparty")

set(VISP_DEBUG_POSTFIX "")

set(VISP_ARCH "")

set(VISP_RUNTIME "")

set(VISP_HAVE_OPENMP "TRUE")

set(WITH_CATCH2 "ON")

set(WITH_PUGIXML "ON")

set(WITH_SIMDLIB "ON")

set(WITH_STBIMAGE "ON")

set(WITH_TINYEXR "ON")

set(FILE_VISP_SCRIPT_CONFIG "/home/nguyen/visp-ws/visp/3rdparty/bin/visp-config")

set(FILE_VISP_SCRIPT_CONFIG_INSTALL "/home/nguyen/visp-ws/visp/3rdparty/unix-install/visp-config")

set(FILE_VISP_SCRIPT_PC_INSTALL "/home/nguyen/visp-ws/visp/3rdparty/unix-install/visp.pc")

set(_cxx_flags "-fopenmp;-std=c++17")

set(_includes_modules "/home/nguyen/visp-ws/visp/modules/tracker/tt_mi/include;/home/nguyen/visp-ws/visp/modules/tracker/tt/include;/home/nguyen/visp-ws/visp/modules/tracker/mbt/include;/home/nguyen/visp-ws/visp/modules/detection/include;/home/nguyen/visp-ws/visp/modules/vision/include;/home/nguyen/visp-ws/visp/modules/vs/include;/home/nguyen/visp-ws/visp/modules/visual_features/include;/home/nguyen/visp-ws/visp/modules/robot/include;/home/nguyen/visp-ws/visp/modules/tracker/blob/include;/home/nguyen/visp-ws/visp/modules/ar/include;/home/nguyen/visp-ws/visp/modules/sensor/include;/home/nguyen/visp-ws/visp/modules/tracker/me/include;/home/nguyen/visp-ws/visp/modules/tracker/klt/include;/home/nguyen/visp-ws/visp/modules/io/include;/home/nguyen/visp-ws/visp/modules/imgproc/include;/home/nguyen/visp-ws/visp/modules/gui/include;/home/nguyen/visp-ws/visp/modules/tracker/dnn/include;/home/nguyen/visp-ws/visp/modules/core/include")

set(_includes_extra "/usr/include/opencv4;/usr/include/eigen3;/usr/include/x86_64-linux-gnu;/usr/include")

set(_system_include_dirs "/usr/include/c++/11;/usr/include/x86_64-linux-gnu/c++/11;/usr/include/c++/11/backward;/usr/lib/gcc/x86_64-linux-gnu/11/include;/usr/local/include;/usr/include/x86_64-linux-gnu;/usr/include")

set(_modules "visp_detection;visp_imgproc;visp_robot;visp_sensor;visp_dnn_tracker;visp_mbt;visp_ar;visp_klt;visp_gui;visp_tt_mi;visp_tt;visp_vision;visp_vs;visp_visual_features;visp_blob;visp_me;visp_io;visp_core")

set(_extra_opt "/usr/lib/x86_64-linux-gnu/libopencv_core.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_highgui.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_features2d.so.4.5.4d;/usr/lib/x86_64-linux-gnu/liblapack.so;/usr/lib/x86_64-linux-gnu/libcblas.so;/usr/lib/x86_64-linux-gnu/libatlas.so;/usr/lib/x86_64-linux-gnu/libz.so;/usr/lib/gcc/x86_64-linux-gnu/11/libgomp.so;/usr/lib/x86_64-linux-gnu/libzbar.so;/usr/lib/x86_64-linux-gnu/libopencv_objdetect.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_dnn.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_videoio.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_imgcodecs.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_imgproc.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libv4l2.so;/usr/lib/x86_64-linux-gnu/libv4lconvert.so;/usr/lib/x86_64-linux-gnu/libdc1394.so;/usr/lib/x86_64-linux-gnu/libopencv_video.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_calib3d.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_flann.so.4.5.4d")

set(_extra_dbg "/usr/lib/x86_64-linux-gnu/libopencv_core.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_highgui.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_features2d.so.4.5.4d;/usr/lib/x86_64-linux-gnu/liblapack.so;/usr/lib/x86_64-linux-gnu/libcblas.so;/usr/lib/x86_64-linux-gnu/libatlas.so;/usr/lib/x86_64-linux-gnu/libz.so;/usr/lib/gcc/x86_64-linux-gnu/11/libgomp.so;/usr/lib/x86_64-linux-gnu/libzbar.so;/usr/lib/x86_64-linux-gnu/libopencv_objdetect.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_dnn.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_videoio.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_imgcodecs.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_imgproc.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libv4l2.so;/usr/lib/x86_64-linux-gnu/libv4lconvert.so;/usr/lib/x86_64-linux-gnu/libdc1394.so;/usr/lib/x86_64-linux-gnu/libopencv_video.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_calib3d.so.4.5.4d;/usr/lib/x86_64-linux-gnu/libopencv_flann.so.4.5.4d")

set(_3rdparty "")

set(TARGET_LOCATION_visp_detection "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_detection.so.3.7.1")

set(TARGET_LOCATION_visp_imgproc "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_imgproc.so.3.7.1")

set(TARGET_LOCATION_visp_robot "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_robot.so.3.7.1")

set(TARGET_LOCATION_visp_sensor "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_sensor.so.3.7.1")

set(TARGET_LOCATION_visp_dnn_tracker "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_dnn_tracker.so.3.7.1")

set(TARGET_LOCATION_visp_mbt "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_mbt.so.3.7.1")

set(TARGET_LOCATION_visp_ar "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_ar.so.3.7.1")

set(TARGET_LOCATION_visp_klt "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_klt.so.3.7.1")

set(TARGET_LOCATION_visp_gui "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_gui.so.3.7.1")

set(TARGET_LOCATION_visp_tt_mi "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_tt_mi.so.3.7.1")

set(TARGET_LOCATION_visp_tt "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_tt.so.3.7.1")

set(TARGET_LOCATION_visp_vision "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_vision.so.3.7.1")

set(TARGET_LOCATION_visp_vs "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_vs.so.3.7.1")

set(TARGET_LOCATION_visp_visual_features "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_visual_features.so.3.7.1")

set(TARGET_LOCATION_visp_blob "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_blob.so.3.7.1")

set(TARGET_LOCATION_visp_me "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_me.so.3.7.1")

set(TARGET_LOCATION_visp_io "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_io.so.3.7.1")

set(TARGET_LOCATION_visp_core "/home/nguyen/visp-ws/visp/3rdparty/lib/libvisp_core.so.3.7.1")
