# CMake generated Testfile for 
# Source directory: /home/nguyen/visp-ws/visp/modules/tracker/mbt
# Build directory: /home/nguyen/visp-ws/visp/3rdparty/modules/mbt
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(testGenericTracker-edge-scanline "testGenericTracker" "-c" "-d" "-t" "1" "-l")
set_tests_properties(testGenericTracker-edge-scanline PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;159;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-KLT "testGenericTracker" "-c" "-d" "-t" "2")
set_tests_properties(testGenericTracker-KLT PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;160;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-KLT-scanline "testGenericTracker" "-c" "-d" "-t" "2" "-l")
set_tests_properties(testGenericTracker-KLT-scanline PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;161;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-edge-KLT "testGenericTracker" "-c" "-d" "-t" "3")
set_tests_properties(testGenericTracker-edge-KLT PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;162;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-edge-KLT-scanline "testGenericTracker" "-c" "-d" "-t" "3" "-l")
set_tests_properties(testGenericTracker-edge-KLT-scanline PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;163;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-edge-depth-dense "testGenericTracker" "-c" "-d" "-t" "1" "-D" "-e" "20")
set_tests_properties(testGenericTracker-edge-depth-dense PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;164;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-edge-depth-dense-scanline "testGenericTracker" "-c" "-d" "-t" "1" "-D" "-l" "-e" "20")
set_tests_properties(testGenericTracker-edge-depth-dense-scanline PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;165;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-KLT-depth-dense "testGenericTracker" "-c" "-d" "-t" "2" "-D" "-e" "20")
set_tests_properties(testGenericTracker-KLT-depth-dense PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;166;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-KLT-depth-dense-scanline "testGenericTracker" "-c" "-d" "-t" "2" "-D" "-l" "-e" "20")
set_tests_properties(testGenericTracker-KLT-depth-dense-scanline PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;167;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-edge-KLT-depth-dense "testGenericTracker" "-c" "-d" "-t" "3" "-D" "-e" "20")
set_tests_properties(testGenericTracker-edge-KLT-depth-dense PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;168;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-edge-KLT-depth-dense-scanline "testGenericTracker" "-c" "-d" "-t" "3" "-D" "-l" "-e" "20")
set_tests_properties(testGenericTracker-edge-KLT-depth-dense-scanline PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;169;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTracker-edge-KLT-depth-dense-scanline-color "testGenericTracker" "-c" "-d" "-t" "3" "-D" "-l" "-e" "20" "-C")
set_tests_properties(testGenericTracker-edge-KLT-depth-dense-scanline-color PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;170;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTrackerDepth-scanline "testGenericTrackerDepth" "-c" "-d" "-l" "-e" "20")
set_tests_properties(testGenericTrackerDepth-scanline PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;173;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
add_test(testGenericTrackerDepth-scanline-color "testGenericTrackerDepth" "-c" "-d" "-l" "-e" "20" "-C")
set_tests_properties(testGenericTrackerDepth-scanline-color PROPERTIES  _BACKTRACE_TRIPLES "/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;174;add_test;/home/nguyen/visp-ws/visp/modules/tracker/mbt/CMakeLists.txt;0;")
