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
#include <visp3/core/vpImageConvert.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>
using json = nlohmann::json;
enum ROBOT_STATE
{
  INIT,
  JOINT,
  APPROACH,
  GRIPPER
};

int main()
{
// Parameter definition
  int count = 0;
  int opt_device = 2;
  bool opt_display = true;
  std::string opt_camera_name = "Camera";
  std::string opt_intrinsic_file = "camera.xml";
  std::string opt_eMc_filename = "rc5_ePc.yaml";
// Initialize gripper
  serialib gripper;
  gripper.openDevice("/dev/ttyACM0", 115200);
// Initialize camera and display
  cv::VideoCapture cap(opt_device, cv::CAP_V4L2); // open the default camera
  if (!cap.isOpened()) {            // check if we succeeded
    std::cout << "Failed to open the camera" << std::endl;
    return EXIT_FAILURE;
  }
  cv::Mat frame;
  int i = 0;
// Get camera intrinsics
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

// Get camera extrinsics
  vpPoseVector e_P_c;
  if (!opt_eMc_filename.empty()) {
    e_P_c.loadYAML(opt_eMc_filename, e_P_c);
  }
  else {
    std::cout << "Warning, opt_eMc_filename is empty! Use hard coded values." << std::endl;
  }
  vpHomogeneousMatrix e_M_c(e_P_c);
  std::cout << "e_M_c:\n" << e_M_c << std::endl;
// Initialize display and camera parameters

  vpImage<unsigned char> I;
  vpDisplayOpenCV *d = nullptr;
  std::shared_ptr<vpDisplay> display = nullptr;

  vpRobotDenso6577 robot;
  robot.init(); // param: redefine tool and camera extrinsic parameters for eMC
  robot.set_eMc(e_M_c);

  vpDot2 dot;
  vpImagePoint cog;

  vpTRACE("sets the current position of the visual feature ");
  vpFeaturePoint p;

  vpTRACE("sets the desired position of the visual feature ");
  vpFeaturePoint pd;
  pd.buildFrom(0, 0, 1);

  vpServo task;
  task.setServo(vpServo::EYEINHAND_L_cVe_eJe);
  task.setInteractionMatrixType(vpServo::DESIRED, vpServo::PSEUDO_INVERSE);

  vpTRACE("Set the position of the end-effector frame in the camera frame");

  vpVelocityTwistMatrix cVe;
  robot.get_cVe(cVe);
  std::cout << cVe << std::endl;
  task.set_cVe(cVe);

  //    vpDisplay::getClick(I) ;
  vpTRACE("Set the Jacobian (expressed in the end-effector frame)");
  vpMatrix eJe;
  robot.get_eJe(eJe);
  task.set_eJe(eJe);

  vpTRACE("\t set the gain");
  task.setLambda(0.3);

  vpTRACE("Display task information ");
  task.print();

  robot.setRobotState(vpRobot::STATE_POSITION_CONTROL);
  vpColVector q;
  std::cout << "\nHit CTRL-C to stop the loop...\n" << std::flush;
  const uint8_t *converged = (const uint8_t *)"OKE\r";
  int state = INIT;
  bool gripper_init = false;
  bool pose_init = false;

  vpColVector initPose(6);  // cấp phát 6 phần tử
  initPose[0] = 0;
  initPose[1] = 0;
  initPose[2] = 90;
  initPose[3] = 0;
  initPose[4] = 90;
  initPose[5] = 0;

  robot.sendPosition(initPose.data);

  for (;;) {
    if (state == INIT) {
      if (!gripper_init) {
        json object = {
          {"T", 101},
          {"spd", 500},
          {"acc", 0}
        };

        // Tạo chuỗi command
        std::string command = object.dump() + "\r\n";

        // Gửi dữ liệu
        bool ok = gripper.writeBytes(
            reinterpret_cast<const uint8_t *>(command.data()),
            command.size()
        );

        if (!ok) {
          std::cerr << "Write failed\n";
        }

        // ================== SEND SECOND COMMAND ==================
        object = { {"T", 105} };
        command = object.dump() + "\r\n";

        ok = gripper.writeBytes(
            reinterpret_cast<const uint8_t *>(command.data()),
            command.size()
        );

        if (!ok) {
          std::cerr << "Write failed\n";
        }

        // ================== RECEIVE ==================
        char buffer[128];
        int idx = 0;

        bool received_left = false;
        bool received_right = false;

        char c;
        int ret;

        timeOut timer;
        timer.initTimer();

        // Đọc từng byte cho tới khi nhận đủ JSON + '\r'
        while (true) {
          ret = gripper.readChar(&c, 10);

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

            if ((idx < (int)sizeof(buffer) - 1) && received_left) {
              buffer[idx++] = c;
            }
          }
          if (timer.elapsedTime_ms() > 1000) {
            std::cout << "TIMEOUT\n";
            break;
          }
        }
        if (received_left && received_right) {
          try {
            nlohmann::json object = nlohmann::json::parse(buffer);

            int T = object.value("T", -1);
            int load = object.value("load", -1);

            if (T == 1051 && load >= 70) {
              std::cout << "Gripper init ok" << std::endl;
              gripper_init = true;
            }
          }
          catch (const nlohmann::json::parse_error &e) {
              // Debug nếu cần
              // std::cerr << "Parse error: " << e.what() << std::endl;
            continue;
          }
        }
      }
      if (!pose_init) {

        robot.getPosition(vpRobot::ARTICULAR_FRAME, q);
        q.rad2deg();
        bool reached =
          std::abs(q[0] - 0)   < 0.01 &&
          std::abs(q[1] - 0)   < 0.01 &&
          std::abs(q[2] - 90)  < 0.01 &&
          std::abs(q[3] - 0)   < 0.01 &&
          std::abs(q[4] - 90)  < 0.01 &&
          std::abs(q[5] - 0)   < 0.01;

        if (reached) {
          std::cout << "pose init oke" << std::endl;

          while ((i++ < 60) && !cap.read(frame)) {
          } // warm up camera by skiping unread frames
          std::cout << "Image size : " << frame.rows << " " << frame.cols << std::endl;

          cap >> frame;
          vpImageConvert::convert(frame, I);

          // state = JOINT;
          if ((opt_display) && d == nullptr) {
            d = new vpDisplayOpenCV(I);
          }
          display = vpDisplayFactory::createDisplay(I, 10, 10, "Current image");
          vpDisplay::display(I);
          vpDisplay::flush(I);

          dot.initTracking(I);
          cog = dot.getCog();

          vpDisplay::displayCross(I, cog, 10, vpColor::blue);
          vpDisplay::flush(I);

          vpFeatureBuilder::create(p, cam, dot); // retrieve x,y and Z of the vpPoint structure

          p.set_Z(1);

          vpTRACE("\t we want to see a point on a point..");
          std::cout << std::endl;
          task.addFeature(p, pd);
          std::cout << "GRIPPER INIT OKE" << std::endl;
          pose_init = true;
        }
      }
      if (pose_init && gripper_init) state = JOINT;
    }
    else if (state == JOINT) {
      cap >> frame; // get a new frame from camera
   // Convert the image in ViSP format and display it
      vpImageConvert::convert(frame, I);

      vpDisplay::display(I);

      // Achieve the tracking of the dot in the image
      dot.track(I);
      cog = dot.getCog();
      // Display a green cross at the center of gravity position in the image
      vpDisplay::displayCross(I, cog, 10, vpColor::green);

      // Update the point feature from the dot location
      vpFeatureBuilder::create(p, cam, dot);

      // Get the jacobian of the robot
      robot.get_eJe(eJe);
      // Update this jacobian in the task structure. It will be used to
      // compute the velocity skew (as an articular velocity) qdot = -lambda *
      // L^+ * cVe * eJe * (s-s*)
      task.set_eJe(eJe);

      //  std::cout << (vpMatrix)cVe*eJe << std::endl ;

      vpColVector v;
      // Compute the visual servoing skew vector
      v = task.computeControlLaw();

      // Display the current and desired feature points in the image display
      vpServoDisplay::display(task, cam, I);

      // Apply the computed joint velocities to the robot
      robot.setVelocity(vpRobot::ARTICULAR_FRAME, v);

      // Get the measured joint positions of the robot
      robot.getPosition(vpRobot::ARTICULAR_FRAME, q);
      for (int i = 0; i < 6; i++) {
        std::cout << q.data[i] << " ";
        if (i == 5) std::cout << std::endl;
      }

      if (abs(task.getError()[0]) < 5e-3 && abs(task.getError()[1]) < 5e-3) {
        std::cout << "TASK AFTER CONVERGED"<<std::endl;
        task.print();
        robot.uartSend(converged, 4);
        state = APPROACH;
      }
      // Save measured joint positions of the robot in the log file
      // - q[0], q[1], q[2] correspond to measured joint translation
      //   positions in m
      // - q[3], q[4], q[5] correspond to measured joint rotation
      //   positions in rad

      // Save feature error (s-s*) for the feature point. For this feature
      // point, we have 2 errors (along x and y axis).  This error is
      // expressed in meters in the camera frame

      vpDisplay::flush(I);

      // std::cout << "|| s - s* || = "  << ( task.getError() ).sumSquare() <<
      // std::endl;
      vpTime::wait(100); // ~100 Hz (mượt hơn)
    }
    else if (state == APPROACH) {
      robot.getPosition(vpRobot::ARTICULAR_FRAME, q);
      q.rad2deg();
      std::cout << q.t() << std::endl;
      if (q.data[0] == -1 && q.data[1] == -1 && q.data[2] == -1 && q.data[3] == -1 && q.data[4] == -1 && q.data[5] == -1) {
        std::cout << "CLOSED GRIPPER"<< std::endl;
        state = GRIPPER;
      }
    }
    else if (state == GRIPPER) {
      nlohmann::json object = {
          {"T", 102},
          {"spd", 500},
          {"acc", 20}
      };

      // Tạo chuỗi command trực tiếp
      std::string command = object.dump();
      command += "\r\n";

      // Gửi dữ liệu
      bool ok = gripper.writeBytes(
          reinterpret_cast<const uint8_t *>(command.data()),
          command.size()
      );

      if (!ok) {
        std::cerr << "Write failed\n";
      }
      object = { {"T", 105} };
      command = object.dump();
      command += "\r\n";
      ok = gripper.writeBytes(
          reinterpret_cast<const uint8_t *>(command.data()),
          command.size()
      );
      if (!ok) {
        std::cerr << "Write failed\n";
      }
      char buffer[128];
      int idx = 0;

      bool received_left = false;
      bool received_right = false;

      char c;
      int ret;

      timeOut timer;
      timer.initTimer();

      // 1. Đọc từng byte cho tới '\r'
      while (true) {
        ret = gripper.readChar(&c, 10);

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

          if ((idx < (int)sizeof(buffer) - 1) && received_left) {
            buffer[idx++] = c;
          }
        }
        if (timer.elapsedTime_ms() > 1000) {
          std::cout << "TIMEOUT\n";
          break;
        }
      }
      if (received_left && received_right) {
        try {
          nlohmann::json object = nlohmann::json::parse(buffer);

          int T = object.value("T", -1);
          int load = object.value("load", -1);

          if (T == 1051 && load <= -150) {
            std::cout << "Grabbed" << std::endl;
          }
        }
        catch (const nlohmann::json::parse_error &e) {
            // Debug nếu cần
            // std::cerr << "Parse error: " << e.what() << std::endl;
          continue;
        }
      }
    }
      // std::cout << "Display task information: " << std::endl;
      // task.print();
  }
  return EXIT_SUCCESS;
}
