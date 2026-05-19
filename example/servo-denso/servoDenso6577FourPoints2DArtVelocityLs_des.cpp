/*
 * ViSP, open source Visual Servoing Platform software.
 * Copyright (C) 2005 - 2025 by Inria. All rights reserved.
 *
 * This software is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * See the file LICENSE.txt at the root directory of this source
 * distribution for additional information about the GNU GPL.
 *
 * For using ViSP with software that can not be combined with the GNU
 * GPL, please contact Inria about acquiring a ViSP Professional
 * Edition License.
 *
 * See https://visp.inria.fr for more information.
 *
 * This software was developed at:
 * Inria Rennes - Bretagne Atlantique
 * Campus Universitaire de Beaulieu
 * 35042 Rennes Cedex
 * France
 *
 * If you have questions regarding the use of this file, please contact
 * Inria at visp@inria.fr
 *
 * This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
 * WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 * Description:
 *   tests the control law
 *   eye-in-hand control
 *   velocity computed in the articular frame
 */
/*!
  \example servoViper850FourPoints2DArtVelocityLs_des.cpp

  \brief Example of eye-in-hand control law. We control here a real robot, the
  Viper S850 robot (arm with 6 degrees of freedom). The velocities resulting
  from visual servo are here joint velocities. Visual features are the image
  coordinates of 4 points. The target is made of 4 dots arranged as a 10cm by
  10cm square.

*/

#include <visp3/core/vpConfig.h>
#include <visp3/core/vpDebug.h> // Debug trace

#include <fstream>
#include <iostream>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <visp3/core/vpJSON.h>
#include <visp3/blob/vpDot2.h>
#include <visp3/core/vpDisplay.h>
#include <visp3/core/vpHomogeneousMatrix.h>
#include <visp3/core/vpImage.h>
#include <visp3/core/vpIoTools.h>
#include <visp3/core/vpMath.h>
#include <visp3/core/vpPoint.h>
#include <visp3/gui/vpDisplayFactory.h>
#include <visp3/robot/vpRobotDenso.h>
#include <visp3/sensor/vp1394TwoGrabber.h>
#include <visp3/vision/vpPose.h>
#include <visp3/visual_features/vpFeatureBuilder.h>
#include <visp3/visual_features/vpFeaturePoint.h>
#include <visp3/vs/vpServo.h>
#include <visp3/vs/vpServoDisplay.h>
#include <visp3/core/vpXmlParserCamera.h>
#include <opencv2/videoio.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <visp3/core/vpImageConvert.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <termios.h>
#include <visp3/core/vpTrackingException.h>
#include <fcntl.h>
// =============================================================
// ViSP example: Eye-in-hand visual servoing với robot Denso
// + Camera track 1 điểm (dot)
// + Điều khiển robot bằng visual servo (joint velocity)
// + Điều khiển gripper qua UART (JSON)
// =============================================================
using json = nlohmann::json;
// =============================================================
// STATE MACHINE của hệ thống
// =============================================================
enum ROBOT_STATE
{
  PREINIT,     // Đưa robot về pose ban đầu
  INIT,        // Khởi tạo gripper + vision
  JOINT,       // Visual servoing
  APPROACH,    // Chờ tín hiệu tiếp cận
  GRIPPER,     // Đóng gripper
  CLASSIFIED,   // Hoàn thành chu trình
  NEXT_STEP
};
enum GripperState
{
  CLOSED,
  OPENED,
  INIT_GRIPPER
};
// =============================================================
// Gửi lệnh xuống gripper qua UART
// =============================================================
void gripperFlush(serialib *gripper)
{
  char c;
  // Đọc hết những gì còn trong buffer
  while (gripper->readChar(&c, 1) == 1) {
    // bỏ qua dữ liệu
  }
}
bool gripperSendCommand(serialib *gripper, std::string command)
{
  return gripper->writeBytes(
            reinterpret_cast<const uint8_t *>(command.data()),
            command.size()
  );

}
// =============================================================
// Nhận dữ liệu từ gripper
// Format: JSON kết thúc bằng '\r'
// Ví dụ: {"T":1051,"load":-120}\r
// =============================================================
bool gripperReceiveBuffer(serialib *gripper, char *buffer)
{
  int idx = 0;

  bool received_left = false;
  bool received_right = false;

  char c;
  int ret;

  timeOut timer;
  timer.initTimer();

  // Đọc từng byte cho tới khi nhận đủ JSON + '\r'
  while (true) {
    ret = gripper->readChar(&c, 10);

    if (ret == 1) {
        // Debug (có thể bật nếu cần)
        // std::cout << c;

      if ((c == '{')) {
        received_left = !received_left;
      }

      if (c == '}') {
        received_right = !received_right;
      }
      if ((c == '\r') && received_left && received_right) {
        buffer[idx] = '\0';
        break;
      }

      if ((idx <  255) && received_left) {
        buffer[idx++] = c;
      }
    }
    if (timer.elapsedTime_ms() > 1500) {
      return false;
    }
  }
  if (received_left && received_right) {
    return true;
  }
  return false;
}
// =============================================================
// Gửi request hỏi trạng thái gripper
// =============================================================
bool gripperStatusRequest(serialib *gripper)
{
  json object = { {"T", 105} };
  std::string command = object.dump() + "\r\n";

  return gripperSendCommand(gripper, command);
}
// =============================================================
// MỞ gripper
// =============================================================
bool gripperOpen(serialib *gripper)
{
  char buffer[256];
  json object = {
                  {"T", 121},
                  {"acc", 20.0},
                  {"angle", 1.7486619853687655}, // Góc mở
                  {"spd", 500.0}
  };

  // Tạo chuỗi command
  std::string command = object.dump() + "\r\n";

  gripperSendCommand(gripper, command);

  gripperStatusRequest(gripper);

  if (gripperReceiveBuffer(gripper, buffer)) {
    try {
      nlohmann::json object = nlohmann::json::parse(buffer);

      int T = object.value("T", -1);
      int load = object.value("load", -1);

      if (T == 1051 && load >= 50) {
        return true;
      }
    }
    catch (const nlohmann::json::parse_error &e) {
      return false;
    }
  }
  return false;
}
// =============================================================
// ĐÓNG gripper
// =============================================================
bool gripperClose(serialib *gripper)
{
  char buffer[256];
  json object = {
                  {"T", 121},
                  {"acc", 20.0},
                  {"angle", 3.1447332076700687}, // Góc mở
                  {"spd", 500.0}
  };

  // Tạo chuỗi command trực tiếp
  std::string command = object.dump() + "\r\n";
  gripperSendCommand(gripper, command);
  gripperStatusRequest(gripper);
  gripperReceiveBuffer(gripper, buffer);

  if (gripperReceiveBuffer(gripper, buffer)) {
    try {
      nlohmann::json object = nlohmann::json::parse(buffer);

      int T = object.value("T", -1);
      int load = object.value("load", -1);

      if (T == 1051 && load <= -100) {
        return true;
      }
    }
    catch (const nlohmann::json::parse_error &e) {
      return false;
    }
  }
  return false;
}
// Run Python AI detection on the current frame.
// Saves frame to /tmp/visp_ai_frame.jpg, then spawns detect_cylinder.py as a subprocess.
// Returns true on success and sets detected_center to vpImagePoint(v, u).
// Falls back gracefully: caller should call dot.initTracking(I) if this returns false.
// TODO: retune confidence_threshold in config.json if cylinder model scores differ from cube model.
// hint: if non-null, script picks the cylinder closest to hint (JOINT mode).
//       if null,     script picks the highest-confidence cylinder (INIT mode).
bool detectCylinderWithAI(const vpImage<unsigned char> &I,
                          vpImagePoint &detected_center,
                          const std::string &config_path = "ai_module/config.json",
                          const vpImagePoint *hint = nullptr)
{
  // Convert grayscale vpImage to BGR cv::Mat — model expects 3-channel input
  cv::Mat gray_mat, bgr_mat;
  vpImageConvert::convert(I, gray_mat);
  cv::cvtColor(gray_mat, bgr_mat, cv::COLOR_GRAY2BGR);
  if (!cv::imwrite("/tmp/visp_ai_frame.jpg", bgr_mat)) {
    std::cerr << "[AI] Failed to save frame to /tmp/visp_ai_frame.jpg" << std::endl;
    return false;
  }

  // Read python_bin from config.json (nlohmann::json already available via vpJSON.h)
  std::string python_bin;
  try {
    std::ifstream cfg_file(config_path);
    if (!cfg_file.is_open()) {
      std::cerr << "[AI] Cannot open config: " << config_path << std::endl;
      return false;
    }
    nlohmann::json cfg = nlohmann::json::parse(cfg_file, nullptr, true, true);
    python_bin = cfg.value("python_bin", "/usr/bin/python3");
  }
  catch (const std::exception &e) {
    std::cerr << "[AI] Config parse error: " << e.what() << std::endl;
    return false;
  }

  // Resolve detect_cylinder.py path from the same directory as config.json
  std::string script_dir;
  auto slash_pos = config_path.rfind('/');
  if (slash_pos != std::string::npos)
    script_dir = config_path.substr(0, slash_pos);
  else
    script_dir = ".";
  std::string cmd = python_bin + " " + script_dir + "/detect_cylinder.py /tmp/visp_ai_frame.jpg";
  if (hint != nullptr)
    cmd += " --hint " + std::to_string(hint->get_u()) + " " + std::to_string(hint->get_v());

  FILE *pipe = popen(cmd.c_str(), "r");
  if (!pipe) {
    std::cerr << "[AI] popen failed: " << cmd << std::endl;
    return false;
  }

  // 3-second timeout via POSIX select()
  int fd = fileno(pipe);
  fd_set rfds;
  struct timeval tv;
  FD_ZERO(&rfds);
  FD_SET(fd, &rfds);
  tv.tv_sec = 3;
  tv.tv_usec = 0;
  if (select(fd + 1, &rfds, nullptr, nullptr, &tv) <= 0) {
    std::cerr << "[AI] Subprocess timeout (3 s)" << std::endl;
    pclose(pipe);
    return false;
  }

  char line[512] = {};
  if (fgets(line, sizeof(line), pipe) == nullptr) {
    pclose(pipe);
    return false;
  }
  pclose(pipe);

  std::string result(line);
  if (result.rfind("SUCCESS", 0) == 0) {
    double u = 0, v = 0, conf = 0, x = 0, y = 0, w = 0, h = 0;
    if (std::sscanf(line, "SUCCESS %lf %lf %lf %lf %lf %lf %lf",
                    &u, &v, &conf, &x, &y, &w, &h) == 7) {
      detected_center = vpImagePoint(v, u);
      return true;
    }
    std::cerr << "[AI] Malformed SUCCESS line: " << result;
    return false;
  }
  if (result.rfind("FAILURE", 0) == 0)
    std::cerr << "[AI] " << result;
  return false;
}
int main()
{
  // ========================
  // Cấu hình hệ thống
  // ========================
  int count = 0;
  int opt_device = 2;
  bool opt_display = true;
  std::string opt_camera_name = "Camera";
  std::string opt_intrinsic_file = "camera.xml";
  std::string opt_eMc_filename = "rc5_ePc.yaml";
  GripperState gripperStatus = INIT_GRIPPER;
  // ========================
  // Khởi tạo gripper (UART)
  // ========================
  serialib *gripper = new serialib;
  gripper->openDevice("/dev/ttyACM0", 115200);

  // ========================
  // Khởi tạo camera
  // ========================
  cv::VideoCapture cap(opt_device, cv::CAP_V4L2); // open the default camera
  if (!cap.isOpened()) {            // check if we succeeded
    std::cout << "Failed to open the camera" << std::endl;
    return EXIT_FAILURE;
  }
  cv::Mat frame;
  int i = 0;
  // ========================
  // Load intrinsic camera
  // ========================
  vpCameraParameters cam;
  vpXmlParserCamera parser;
  if (!vpIoTools::checkFilename(opt_intrinsic_file)) {
    std::cout << "Camera parameters file " << opt_intrinsic_file << " doesn't exist." << std::endl;
    std::cout << "Use --help option to see how to set its location..." << std::endl;
    return EXIT_FAILURE;
  }
  if (parser.parse(cam, opt_intrinsic_file, opt_camera_name, vpCameraParameters::perspectiveProjWithDistortion) !=
    vpXmlParserCamera::SEQUENCE_OK) {
    std::cout << "Unable to parse parameters with distortion for camera \"" << opt_camera_name << "\" from "
      << opt_intrinsic_file << " file" << std::endl;
    std::cout << "Attempt to find parameters without distortion" << std::endl;

    if (parser.parse(cam, opt_intrinsic_file, opt_camera_name,
                     vpCameraParameters::perspectiveProjWithoutDistortion) != vpXmlParserCamera::SEQUENCE_OK) {
      std::cout << "Unable to parse parameters without distortion for camera \"" << opt_camera_name << "\" from "
        << opt_intrinsic_file << " file" << std::endl;
      return EXIT_FAILURE;
    }
  }

  // ========================
  // Load extrinsic eMc
  // ========================
  vpPoseVector e_P_c;
  if (!opt_eMc_filename.empty()) {
    e_P_c.loadYAML(opt_eMc_filename, e_P_c);
  }
  else {
  }
  vpHomogeneousMatrix e_M_c(e_P_c);

  // ========================
  // Display
  // ========================
  vpImage<unsigned char> I;
  vpDisplayOpenCV *d = nullptr;
  std::shared_ptr<vpDisplay> display = nullptr;

  while ((i++ < 60) && !cap.read(frame)) {
  } // warm up camera by skiping unread frames

  cap >> frame;
  vpImageConvert::convert(frame, I);

  if ((opt_display) && d == nullptr) {
    d = new vpDisplayOpenCV(I);
  }
  display = vpDisplayFactory::createDisplay(I, 10, 10, "Current image");
  vpDisplay::display(I);
  vpDisplay::flush(I);

  // ========================
  // Khởi tạo robot Denso
  // ========================
  vpRobotDenso6577 robot;
  robot.init(); // param: redefine tool and camera extrinsic parameters for eMC
  robot.set_eMc(e_M_c);

  vpImagePoint ai_hint;

  vpTRACE("sets the current position of the visual feature ");
  vpFeaturePoint p;

  vpTRACE("sets the desired position of the visual feature ");
  vpFeaturePoint pd;
  pd.buildFrom(0, 0, 1);
  // ========================
  // Visual servo task
  // ========================
  vpServo task;
  vpVelocityTwistMatrix cVe;
  vpMatrix eJe;

  // ========================
  // Biến điều khiển
  // ========================
  vpColVector q_cur(6), q_new(6);
  const uint8_t *converged = (const uint8_t *)"OKE\r";
  int state = PREINIT;
  bool gripper_init = false;
  bool pose_init = false;
  bool sendClassified = false;
  bool flushedGripper = false;
  bool init_feature = false;
  vpChrono chrono, chrene;
  for (;;) {
    cap >> frame;
    vpImageConvert::convert(frame, I);
    vpDisplay::display(I);

    if (state == PREINIT) {
      q_new[0] = 0;
      q_new[1] = 0;
      q_new[2] = 90;
      q_new[3] = 0;
      q_new[4] = 90;
      q_new[5] = 0;

      robot.sendPosition(q_new.data);
      task.setServo(vpServo::EYEINHAND_L_cVe_eJe);
      task.setInteractionMatrixType(vpServo::DESIRED, vpServo::PSEUDO_INVERSE);

      vpTRACE("Set the position of the end-effector frame in the camera frame");

      robot.get_cVe(cVe);
      task.set_cVe(cVe);
      vpTRACE("Set the Jacobian (expressed in the end-effector frame)");

      robot.get_eJe(eJe);
      task.set_eJe(eJe);

      vpTRACE("\t set the gain");
      task.setLambda(0.4);

      vpTRACE("Display task information ");
      task.print();

      robot.setRobotState(vpRobot::STATE_POSITION_CONTROL);
      state = INIT;
    }
    else if (state == INIT) {
      if (!gripper_init) {
        gripper_init = gripperOpen(gripper);
        if (gripper_init) {
          gripperStatus = OPENED;
        }
      }
      if (!pose_init) {
        robot.getPosition(vpRobot::ARTICULAR_FRAME, q_cur);
        q_cur.rad2deg();
        bool reached =
          std::abs(q_cur[0] - q_new[0])   < 0.01 &&
          std::abs(q_cur[1] - q_new[1])   < 0.01 &&
          std::abs(q_cur[2] - q_new[2])  < 0.01 &&
          std::abs(q_cur[3] - q_new[3])   < 0.01 &&
          std::abs(q_cur[4] - q_new[4])  < 0.01 &&
          std::abs(q_cur[5] - q_new[5])   < 0.01;
        if (reached) {
          try {
            // INIT: no hint — pick highest-confidence cylinder
            if (detectCylinderWithAI(I, ai_hint)) {
              std::cout << "[AI] Cylinder detected at: " << ai_hint << std::endl;
            }
            else {
              std::cout << "[AI] Detection fail, fallback to init click." << std::endl;
            }
            vpDisplay::displayCross(I, ai_hint, 10, vpColor::blue);
            vpDisplay::flush(I);

            vpFeatureBuilder::create(p, cam, ai_hint); // retrieve x,y and Z of the vpPoint structure

            p.set_Z(1);

            if (!init_feature) {
              task.addFeature(p, pd);
              init_feature = true;
            }
            task.print();

            pose_init = true;

          }
          catch (const vpTrackingException &e) {
          }
        }
      }
      if (pose_init && gripper_init) {
        chrono.start(true);
        chrene.start(true);
        state = JOINT;
        q_cur = q_new.deg2rad();
      }
    }
    else if (state == JOINT) {
      robot.getPosition(vpRobot::ARTICULAR_FRAME, q_cur);
      bool reached =
        std::abs(q_cur[0] - q_new[0])   < 0.01 &&
        std::abs(q_cur[1] - q_new[1])   < 0.01 &&
        std::abs(q_cur[2] - q_new[2])  < 0.01 &&
        std::abs(q_cur[3] - q_new[3])   < 0.01 &&
        std::abs(q_cur[4] - q_new[4])  < 0.01 &&
        std::abs(q_cur[5] - q_new[5])   < 0.01;

      if (reached) {
        try {
          // JOINT: pass &ai_hint so Python picks the cylinder closest to
          // the last known position, not the highest-confidence one.
          // This prevents the servo from jumping to a different cylinder
          // when scores fluctuate as the robot moves.
          if (detectCylinderWithAI(I, ai_hint, "ai_module/config.json", &ai_hint)) {
            std::cout << "[AI] Cylinder tracked at: " << ai_hint << std::endl;
          }
          else {
            std::cout << "[AI] Lost detection, holding last position." << std::endl;
          }
        }
        catch (const vpTrackingException &e) {
          sendClassified = false;
          pose_init = false;
          gripper_init = false;
          task.kill();
          state = PREINIT;
          continue;
        }
        // Display a green cross at the center of gravity position in the image
        vpDisplay::displayCross(I, ai_hint, 10, vpColor::green);

        vpFeatureBuilder::create(p, cam, ai_hint); // retrieve x,y and Z of the vpPoint structure
        robot.get_eJe(eJe);
        task.set_eJe(eJe);


        vpColVector v;
        vpColVector vel_max(6);
        double delta_t = 0.5; // 10 ms
        v = task.computeControlLaw();

        vpServoDisplay::display(task, cam, I);
      // if (getMaxRotationVelocity() == getMaxRotationVelocityJoint6()) {
        if (std::fabs(robot.getMaxRotationVelocity() - robot.getMaxRotationVelocityJoint6()) < std::numeric_limits<double>::epsilon()) {
          for (unsigned int i = 0; i < 6; i++)
            vel_max[i] = robot.getMaxRotationVelocity();
        }
        else {
          for (unsigned int i = 0; i < 5; i++)
            vel_max[i] = robot.getMaxRotationVelocity();
          vel_max[5] = robot.getMaxRotationVelocityJoint6();
        }
        v = vpRobot::saturateVelocities(v, vel_max, true);
        robot.getPosition(vpRobot::ARTICULAR_FRAME, q_cur);
        q_new = q_cur + v * delta_t;
        robot.setPosition(vpRobot::ARTICULAR_FRAME, q_new);

        if (abs(task.getError()[0]) < 5e-3 && abs(task.getError()[1]) < 5e-3) {
          chrene.stop();
          std::cout << " TIME CONVERGED:" << chrene.getDurationMs() << std::endl;
          task.print();
          robot.uartSend(converged, 4);
          state = APPROACH;
        }
        task.print();
      }
      vpDisplay::flush(I);
    }
    else if (state == APPROACH) {
      robot.getPosition(vpRobot::ARTICULAR_FRAME, q_cur);
      q_cur.rad2deg();
      if (q_cur.data[0] == -1 && q_cur.data[1] == -1 && q_cur.data[2] == -1 && q_cur.data[3] == -1 && q_cur.data[4] == -1 && q_cur.data[5] == -1) {
        state = GRIPPER;
      }
    }
    else if (state == GRIPPER) {
      if (gripperClose(gripper)) {
        state = CLASSIFIED;
      }
    }
    else if (state == CLASSIFIED) {
      // gripperClose(gripper);
      // SEND oke to RC5 controller
      //
      // robot.uartSend(converged, 4);
      if (!sendClassified) {
        q_new[0] = 53.35;
        q_new[1] = 25.15;
        q_new[2] = 91.58;
        q_new[3] = 0;
        q_new[4] = 63.27;
        q_new[5] = 53.35;

        robot.sendPosition(q_new.data);
        sendClassified = true;
      }
      // gripperClose(gripper);
      robot.flush();
      robot.getPosition(vpRobot::ARTICULAR_FRAME, q_cur);
      q_cur.rad2deg();
      bool reached =
        std::abs(q_cur[0] - q_new[0])   < 0.01 &&
        std::abs(q_cur[1] - q_new[1])   < 0.01 &&
        std::abs(q_cur[2] - q_new[2])  < 0.01 &&
        std::abs(q_cur[3] - q_new[3])   < 0.01 &&
        std::abs(q_cur[4] - q_new[4])  < 0.01 &&
        std::abs(q_cur[5] - q_new[5])   < 0.01;

      if (reached) {
        gripperFlush(gripper);
        gripperOpen(gripper);
        vpTime::wait(500);
        sendClassified = false;
        pose_init = false;
        gripper_init = false;
        std::cout << "###########################################################################" <<std::endl;
        chrono.stop();
        std::cout << "COMPLETE ONE " << chrono.getDurationMs() << std::endl;
        state = PREINIT;
      }
    }
    vpDisplay::flush(I);
  }
  return EXIT_SUCCESS;
}
