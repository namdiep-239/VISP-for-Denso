// /*
//  * ViSP, open source Visual Servoing Platform software.
//  * Copyright (C) 2005 - 2025 by Inria. All rights reserved.
//  *
//  * This software is free software; you can redistribute it and/or modify
//  * it under the terms of the GNU General Public License as published by
//  * the Free Software Foundation; either version 2 of the License, or
//  * (at your option) any later version.
//  * See the file LICENSE.txt at the root directory of this source
//  * distribution for additional information about the GNU GPL.
//  *
//  * For using ViSP with software that can not be combined with the GNU
//  * GPL, please contact Inria about acquiring a ViSP Professional
//  * Edition License.
//  *
//  * See https://visp.inria.fr for more information.
//  *
//  * This software was developed at:
//  * Inria Rennes - Bretagne Atlantique
//  * Campus Universitaire de Beaulieu
//  * 35042 Rennes Cedex
//  * France
//  *
//  * If you have questions regarding the use of this file, please contact
//  * Inria at visp@inria.fr
//  *
//  * This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
//  * WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//  *
//  * Description:
//  * Compute eye-in-hand calibration from chessboard poses and robot end-effector poses.
//  */

// /*!
//  * \example visp-compute-eye-in-hand-calibration.cpp
//  * App that allows to perform eye-in-hand calibration.
//  */
// #include <map>

// #include <visp3/core/vpConfig.h>
// #include <visp3/core/vpIoTools.h>
// #include <visp3/vision/vpHandEyeCalibration.h>

// void usage(const char *argv[], int error)
// {
//   std::cout << "Synopsis" << std::endl
//     << "  " << argv[0]
//     << " [--data-path <path>]"
//     << " [--rPe <generic name>]"
//     << " [--cPo <generic name>]"
//     << " [--output-ePc <filename>]"
//     << " [--help, -h]" << std::endl
//     << std::endl;
//   std::cout << "Description" << std::endl
//     << "  Compute eye-in-hand calibration." << std::endl
//     << std::endl
//     << "  --data-path <path>" << std::endl
//     << "    Path to the folder containing pose_rPe_%d.yaml and pose_cPo_%d.yaml data files." << std::endl
//     << "    Default: \"./\"" << std::endl
//     << std::endl
//     << "  --rPe <generic name>" << std::endl
//     << "    Generic name of the yaml files containing the pose of the end-effector expressed in the robot" << std::endl
//     << "    base frame and located in the data path folder." << std::endl
//     << "    Default: pose_rPe_%d.yaml" << std::endl
//     << std::endl
//     << "  --cPo <generic name>" << std::endl
//     << "    Generic name of the yaml files" << std::endl
//     << "    containing the pose of the calibration grid expressed in the camera frame and located in the" << std::endl
//     << "    data path folder." << std::endl
//     << "    Default: pose_cPo_%d.yaml" << std::endl
//     << std::endl
//     << "  --output-ePc <filename>" << std::endl
//     << "    File in yaml format containing the pose of the camera" << std::endl
//     << "    in the end-effector frame. Data are saved as a pose vector with first the 3 translations" << std::endl
//     << "    along X,Y,Z in [m] and then the 3 rotations in axis-angle representation (thetaU) in [rad]." << std::endl
//     << "    Default: ePc.yaml" << std::endl
//     << std::endl
//     << "  --output-rPo <filename>" << std::endl
//     << "    File in yaml format containing the pose of the object" << std::endl
//     << "    in the robot reference frame. Data are saved as a pose vector with first the 3 translations" << std::endl
//     << "    along X,Y,Z in [m] and then the 3 rotations in axis-angle representation (thetaU) in [rad]." << std::endl
//     << "    Default: rPo.yaml" << std::endl
//     << std::endl
//     << "  --help, -h" << std::endl
//     << "    Print this helper message." << std::endl
//     << std::endl;
//   if (error) {
//     std::cout << "Error" << std::endl
//       << "  "
//       << "Unsupported parameter " << argv[error] << std::endl;
//   }
// }

// int main(int argc, const char *argv[])
// {
// #if defined(ENABLE_VISP_NAMESPACE)
//   using namespace VISP_NAMESPACE_NAME;
// #endif

//   std::string opt_data_path = "./";
//   std::string opt_rPe_files = "pose_rPe_%d.yaml";
//   std::string opt_cPo_files = "pose_cPo_%d.yaml";
//   std::string opt_ePc_file = "ePc.yaml";
//   std::string opt_rPo_file = "rPo.yaml";
//   for (int i = 1; i < argc; i++) {
//     if (std::string(argv[i]) == "--data-path" && i + 1 < argc) {
//       opt_data_path = std::string(argv[++i]);
//     }
//     else if (std::string(argv[i]) == "--rPe" && i + 1 < argc) {
//       opt_rPe_files = std::string(argv[++i]);
//     }
//     else if (std::string(argv[i]) == "--cPo" && i + 1 < argc) {
//       opt_cPo_files = std::string(argv[++i]);
//     }
//     else if (std::string(argv[i]) == "--output-ePc" && i + 1 < argc) {
//       opt_ePc_file = std::string(argv[++i]);
//     }
//     else if (std::string(argv[i]) == "--output-rPo" && i + 1 < argc) {
//       opt_rPo_file = std::string(argv[++i]);
//     }
//     else if (std::string(argv[i]) == "--help" || std::string(argv[i]) == "-h") {
//       usage(argv, 0);
//       return EXIT_SUCCESS;
//     }
//     else {
//       usage(argv, i);
//       return EXIT_FAILURE;
//     }
//   }

//   // Create output folder if necessary
//   std::string output_parent = vpIoTools::getParent(opt_ePc_file);
//   if (!vpIoTools::checkDirectory(output_parent)) {
//     std::cout << "Create output directory: " << output_parent << std::endl;
//     vpIoTools::makeDirectory(output_parent);
//   }

//   std::vector<vpHomogeneousMatrix> cMo;
//   std::vector<vpHomogeneousMatrix> rMe;
//   vpHomogeneousMatrix eMc;
//   vpHomogeneousMatrix rMo;

//   std::map<long, std::string> map_rPe_files;
//   std::map<long, std::string> map_cPo_files;
//   std::vector<std::string> files = vpIoTools::getDirFiles(opt_data_path);
//   for (unsigned int i = 0; i < files.size(); i++) {
//     long index_rPe = vpIoTools::getIndex(files[i], opt_rPe_files);
//     long index_cPo = vpIoTools::getIndex(files[i], opt_cPo_files);
//     if (index_rPe != -1) {
//       map_rPe_files[index_rPe] = files[i];
//     }
//     if (index_cPo != -1) {
//       map_cPo_files[index_cPo] = files[i];
//     }
//   }

//   if (map_rPe_files.size() == 0) {
//     std::cout << "No " << opt_rPe_files
//       << " files found. Use --data-path <path> or --rPe <generic name> to be able to read your data." << std::endl;
//     std::cout << "Use --help option to see full usage..." << std::endl;
//     return EXIT_FAILURE;
//   }
//   if (map_cPo_files.size() == 0) {
//     std::cout << "No " << opt_cPo_files
//       << " files found. Use --data-path <path> or --cPo <generic name> to be able to read your data." << std::endl;
//     std::cout << "Use --help option to see full usage..." << std::endl;
//     return EXIT_FAILURE;
//   }

//   for (std::map<long, std::string>::const_iterator it_rPe = map_rPe_files.begin(); it_rPe != map_rPe_files.end();
//     ++it_rPe) {
//     std::string file_rPe = vpIoTools::createFilePath(opt_data_path, it_rPe->second);
//     std::map<long, std::string>::const_iterator it_cPo = map_cPo_files.find(it_rPe->first);
//     if (it_cPo != map_cPo_files.end()) {
//       vpPoseVector rPe;
//       double d2r = M_PI / 180.0;
//       if (rPe.loadYAML(file_rPe, rPe) == false) {
//         std::cout << "Unable to read data from " << file_rPe << ". Skip data" << std::endl;
//         continue;
//       }
//       for (int i = 0; i < 3; i++) {
//         rPe.data[i] = rPe.data[i] / 1000.0; // convert translation from mm to m
//       }
//       for (int i = 3; i < 6; i++) {
//         rPe.data[i] *= d2r; // convert rotation from deg to rad
//       }
//       vpPoseVector cPo;
//       std::string file_cPo = vpIoTools::createFilePath(opt_data_path, it_cPo->second);
//       if (cPo.loadYAML(file_cPo, cPo) == false) {
//         std::cout << "Unable to read data from " << file_cPo << ". Skip data" << std::endl;
//         continue;
//       }
//       std::cout << "Use data from " << opt_data_path << "/" << file_rPe << " and from " << file_cPo << std::endl;
//       rMe.push_back(vpHomogeneousMatrix(rPe));
//       cMo.push_back(vpHomogeneousMatrix(cPo));
//     }
//   }

//   if (rMe.size() < 3) {
//     std::cout << "Not enough data pairs found." << std::endl;
//     return EXIT_FAILURE;
//   }
//   for (int i = 0; i< rMe.size(); i++) {
//     for (int j = 0; j < rMe[i].getRows(); j++) {
//       for (int k = 0; k < rMe[i].getCols(); k++) {
//         std::cout << rMe[i][j][k] << " ";
//       }
//       std::cout << std::endl;
//     }
//     std::cout << std::endl;
//   }
//   int ret = vpHandEyeCalibration::calibrate(cMo, rMe, eMc, rMo);

//   if (ret == 0) {
//     std::cout << std::endl << "Eye-in-hand calibration succeed" << std::endl;
//     std::cout << std::endl << "Estimated eMc transformation:" << std::endl;
//     std::cout << "-----------------------------" << std::endl;
//     //std::cout << eMc << std::endl << std::endl;
//     vpMatrix(eMc).print(std::cout, 15, "eMc");
//     std::cout << "- Corresponding pose vector [tx ty tz tux tuy tuz] in [m] and [rad]: " << vpPoseVector(eMc).t() << std::endl;

//     vpThetaUVector erc(eMc.getRotationMatrix());
//     std::cout << std::endl << "- Translation [m]: " << eMc[0][3] << " " << eMc[1][3] << " " << eMc[2][3] << std::endl;
//     std::cout << "- Rotation (theta-u representation) [rad]: " << erc.t() << std::endl;
//     std::cout << "- Rotation (theta-u representation) [deg]: " << vpMath::deg(erc[0]) << " " << vpMath::deg(erc[1])
//       << " " << vpMath::deg(erc[2]) << std::endl;
//     vpQuaternionVector quaternion(eMc.getRotationMatrix());
//     std::cout << "- Rotation (quaternion representation) [rad]: " << quaternion.t() << std::endl;
//     vpRxyzVector rxyz(eMc.getRotationMatrix());
//     std::cout << "- Rotation (r-x-y-z representation) [rad]: " << rxyz.t() << std::endl;
//     std::cout << "- Rotation (r-x-y-z representation) [deg]: " << vpMath::deg(rxyz).t() << std::endl;

//     std::cout << std::endl << "Estimated rMo transformation:" << std::endl;
//     std::cout << "-----------------------------" << std::endl;
//     //std::cout << rMo << std::endl;
//     vpMatrix(rMo).print(std::cout, 15, "rMo");
//     std::cout << "- Corresponding pose vector [tx ty tz tux tuy tuz] in [m] and [rad]: " << vpPoseVector(rMo).t() << std::endl;

//     vpThetaUVector wrc(rMo.getRotationMatrix());
//     std::cout << std::endl << "- Translation [m]: " << rMo[0][3] << " " << rMo[1][3] << " " << rMo[2][3] << std::endl;
//     std::cout << "- Rotation (theta-u representation) [rad]: " << wrc.t() << std::endl;
//     std::cout << "- Rotation (theta-u representation) [deg]: " << vpMath::deg(wrc[0]) << " " << vpMath::deg(wrc[1])
//       << " " << vpMath::deg(wrc[2]) << std::endl;
//     vpQuaternionVector quaternion2(rMo.getRotationMatrix());
//     std::cout << "- Rotation (quaternion representation) [rad]: " << quaternion2.t() << std::endl;
//     vpRxyzVector rxyz2(rMo.getRotationMatrix());
//     std::cout << "- Rotation (r-x-y-z representation) [rad]: " << rxyz2.t() << std::endl;
//     std::cout << "- Rotation (r-x-y-z representation) [deg]: " << vpMath::deg(rxyz).t() << std::endl;

//     {
//       // save eMc
//       std::string name_we = vpIoTools::createFilePath(vpIoTools::getParent(opt_ePc_file), vpIoTools::getNameWE(opt_ePc_file)) + ".txt";
//       std::cout << std::endl << "Save transformation matrix eMc as an homogeneous matrix in: " << name_we << std::endl;

// #if (VISP_CXX_STANDARD > VISP_CXX_STANDARD_98)
//       std::ofstream file_eMc(name_we);
// #else
//       std::ofstream file_eMc(name_we.c_str());
// #endif

//       eMc.save(file_eMc);

//       vpPoseVector pose_vec(eMc);
//       std::string output_filename = vpIoTools::createFilePath(vpIoTools::getParent(opt_ePc_file), vpIoTools::getName(opt_ePc_file));
//       std::cout << "Save transformation matrix eMc as a vpPoseVector in       : " << output_filename << std::endl;
//       pose_vec.saveYAML(output_filename, pose_vec);
//     }

//     {
//       // save rMo
//       std::string name_we = vpIoTools::createFilePath(vpIoTools::getParent(opt_rPo_file), vpIoTools::getNameWE(opt_rPo_file)) + ".txt";
//       std::cout << std::endl << "Save transformation matrix rMo as an homogeneous matrix in: " << name_we << std::endl;

// #if (VISP_CXX_STANDARD > VISP_CXX_STANDARD_98)
//       std::ofstream file_rMo(name_we);
// #else
//       std::ofstream file_rMo(name_we.c_str());
// #endif

//       rMo.save(file_rMo);

//       vpPoseVector pose_vec(rMo);
//       std::string output_filename = vpIoTools::createFilePath(vpIoTools::getParent(opt_rPo_file), vpIoTools::getName(opt_rPo_file));
//       std::cout << "Save transformation matrix rMo as a vpPoseVector in       : " << output_filename << std::endl;
//       pose_vec.saveYAML(output_filename, pose_vec, "Robot reference to object frames transformation (rMo)");
//     }
//   }
//   else {
//     std::cout << std::endl << "** Eye-in-hand calibration failed" << std::endl;
//     std::cout << std::endl << "Check your input data and ensure they are covering the half sphere over the chessboard." << std::endl;
//     std::cout << std::endl << "See https://visp-doc.inria.fr/doxygen/visp-daily/tutorial-calibration-extrinsic-eye-in-hand.html" << std::endl;
//   }

//   return EXIT_SUCCESS;
// }
#include <visp3/core/vpHomogeneousMatrix.h>
#include <visp3/core/vpPoseVector.h>
#include <visp3/core/vpCameraParameters.h>
#include <visp3/vision/vpPose.h>
#include <visp3/core/vpXmlParserCamera.h>
#include <opencv2/opencv.hpp>

#include <iostream>
#include <vector>

using namespace std;

int main()
{
    // ============================================
    // Checkerboard settings
    // ============================================

  int rows = 6;
  int cols = 9;

  double square_size = 0.025; // meters

  cv::Size board_size(cols, rows);

  // ============================================
  // Load intrinsic parameters
  // ============================================

  cv::Mat K1, D1;
  cv::Mat K2, D2;
  vpCameraParameters cam1, cam2;
  vpXmlParserCamera parser;
  std::string opt_intrinsic_file_left = "./data/pair/camera_left.xml";
  std::string opt_intrinsic_file_right = "./data/pair/camera_right.xml";
  std::string opt_camera_name = "Camera";
  if (parser.parse(cam1, opt_intrinsic_file_left, opt_camera_name, vpCameraParameters::perspectiveProjWithDistortion) !=
    vpXmlParserCamera::SEQUENCE_OK) {
    std::cout << "Unable to parse parameters with distortion for camera \"" << opt_camera_name << "\" from "
      << opt_intrinsic_file_left << " file" << std::endl;
    std::cout << "Attempt to find parameters without distortion" << std::endl;

    if (parser.parse(cam1, opt_intrinsic_file_left, opt_camera_name,
                     vpCameraParameters::perspectiveProjWithoutDistortion) != vpXmlParserCamera::SEQUENCE_OK) {
      std::cout << "Unable to parse parameters without distortion for camera \"" << opt_camera_name << "\" from "
        << opt_intrinsic_file_left << " file" << std::endl;
      return EXIT_FAILURE;
    }
  }
  if (parser.parse(cam2, opt_intrinsic_file_right, opt_camera_name, vpCameraParameters::perspectiveProjWithDistortion) !=
    vpXmlParserCamera::SEQUENCE_OK) {
    std::cout << "Unable to parse parameters with distortion for camera \"" << opt_camera_name << "\" from "
      << opt_intrinsic_file_right << " file" << std::endl;
    std::cout << "Attempt to find parameters without distortion" << std::endl;

    if (parser.parse(cam2, opt_intrinsic_file_right, opt_camera_name,
                     vpCameraParameters::perspectiveProjWithoutDistortion) != vpXmlParserCamera::SEQUENCE_OK) {
      std::cout << "Unable to parse parameters without distortion for camera \"" << opt_camera_name << "\" from "
        << opt_intrinsic_file_right << " file" << std::endl;
      return EXIT_FAILURE;
    }
  }

  K1 = cam1.get_K();
  D1 = cam1.get_kdu();
  fs1["camera_matrix"] >> K1;
  fs1["dist_coeffs"] >> D1;

  fs2["camera_matrix"] >> K2;
  fs2["dist_coeffs"] >> D2;

  fs2.release();

  cout << "Intrinsic loaded." << endl;

  // ============================================
  // Prepare checkerboard object points
  // ============================================

  vector<cv::Point3f> objp;

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {

      objp.push_back(
          cv::Point3f(
            j * square_size,
            i * square_size,
            0
          )
      );
    }
  }

  vector<vector<cv::Point3f>> object_points;

  vector<vector<cv::Point2f>> imgpoints_left;
  vector<vector<cv::Point2f>> imgpoints_right;

  // ============================================
  // Number of stereo pairs
  // ============================================

  int num_pairs = 25;

  for (int i = 0; i < num_pairs; i++) {

      // ========================================
      // Load stereo pair
      // ========================================

    string left_name =
      "data/pair/left_" +
      to_string(i) +
      ".png";

    string right_name =
      "data/pair/right_" +
      to_string(i) +
      ".png";

    cv::Mat imgL =
      cv::imread(left_name);

    cv::Mat imgR =
      cv::imread(right_name);

    if (imgL.empty() || imgR.empty()) {

      cout << "Cannot load pair "
        << i << endl;

      continue;
    }

    // ========================================
    // Convert grayscale
    // ========================================

    cv::Mat grayL;
    cv::Mat grayR;

    cv::cvtColor(
        imgL,
        grayL,
        cv::COLOR_BGR2GRAY
    );

    cv::cvtColor(
        imgR,
        grayR,
        cv::COLOR_BGR2GRAY
    );

    // ========================================
    // Find chessboard corners
    // ========================================

    vector<cv::Point2f> cornersL;
    vector<cv::Point2f> cornersR;

    bool foundL =
      cv::findChessboardCorners(
          grayL,
          board_size,
          cornersL
      );

    bool foundR =
      cv::findChessboardCorners(
          grayR,
          board_size,
          cornersR
      );

    if (foundL && foundR) {

        // ====================================
        // Corner refinement
        // ====================================

      cv::cornerSubPix(
          grayL,
          cornersL,
          cv::Size(11, 11),
          cv::Size(-1, -1),
          cv::TermCriteria(
            cv::TermCriteria::EPS +
            cv::TermCriteria::MAX_ITER,
            30,
            0.001
          )
      );

      cv::cornerSubPix(
          grayR,
          cornersR,
          cv::Size(11, 11),
          cv::Size(-1, -1),
          cv::TermCriteria(
            cv::TermCriteria::EPS +
            cv::TermCriteria::MAX_ITER,
            30,
            0.001
          )
      );

      // ====================================
      // Store calibration points
      // ====================================

      imgpoints_left.push_back(cornersL);

      imgpoints_right.push_back(cornersR);

      object_points.push_back(objp);

      // ====================================
      // Draw corners
      // ====================================

      cv::drawChessboardCorners(
          imgL,
          board_size,
          cornersL,
          foundL
      );

      cv::drawChessboardCorners(
          imgR,
          board_size,
          cornersR,
          foundR
      );

      cv::imshow("Left", imgL);
      cv::imshow("Right", imgR);

      cv::waitKey(200);
    }
  }

  // ============================================
  // Stereo calibration
  // ============================================

  cv::Mat R, T, E, F;

  double rms =
    cv::stereoCalibrate(
        object_points,
        imgpoints_left,
        imgpoints_right,

        K1,
        D1,

        K2,
        D2,

        cv::Size(640, 480),

        R,
        T,
        E,
        F,

        cv::CALIB_FIX_INTRINSIC
    );

  cout << endl;
  cout << "Stereo RMS error = "
    << rms << endl;

  cout << endl;

  cout << "R = " << endl;
  cout << R << endl;

  cout << endl;

  cout << "T = " << endl;
  cout << T << endl;

  cout << endl;

  // ============================================
  // Save stereo extrinsic
  // ============================================

  cv::FileStorage fs_out(
      "stereo_extrinsics.xml",
      cv::FileStorage::WRITE
  );

  fs_out << "R" << R;
  fs_out << "T" << T;
  fs_out << "E" << E;
  fs_out << "F" << F;

  fs_out.release();

  cout << "Stereo extrinsic saved." << endl;

  // ============================================
  // Stereo rectification
  // ============================================

  cv::Mat R1, R2;
  cv::Mat P1, P2;
  cv::Mat Q;

  cv::Rect roi1, roi2;

  cv::stereoRectify(
      K1,
      D1,
      K2,
      D2,
      cv::Size(640, 480),
      R,
      T,
      R1,
      R2,
      P1,
      P2,
      Q,
      cv::CALIB_ZERO_DISPARITY,
      0,
      cv::Size(640, 480),
      &roi1,
      &roi2
  );

  cout << "Stereo rectification done."
    << endl;

    // ============================================
    // Create rectify maps
    // ============================================

  cv::Mat map1x, map1y;
  cv::Mat map2x, map2y;

  cv::initUndistortRectifyMap(
      K1,
      D1,
      R1,
      P1,
      cv::Size(640, 480),
      CV_32FC1,
      map1x,
      map1y
  );

  cv::initUndistortRectifyMap(
      K2,
      D2,
      R2,
      P2,
      cv::Size(640, 480),
      CV_32FC1,
      map2x,
      map2y
  );

  // ============================================
  // Test rectify result
  // ============================================

  cv::Mat left =
    cv::imread("data/pair/left_0.png");

  cv::Mat right =
    cv::imread("data/pair/right_0.png");

  if (left.empty() || right.empty()) {

    cout << "Cannot load test pair."
      << endl;

    return -1;
  }

  cv::Mat left_rect;
  cv::Mat right_rect;

  cv::remap(
      left,
      left_rect,
      map1x,
      map1y,
      cv::INTER_LINEAR
  );

  cv::remap(
      right,
      right_rect,
      map2x,
      map2y,
      cv::INTER_LINEAR
  );

  // ============================================
  // Combine images
  // ============================================

  cv::Mat combined;

  cv::hconcat(
      left_rect,
      right_rect,
      combined
  );

  // ============================================
  // Draw epipolar lines
  // ============================================

  for (int y = 0;
       y < combined.rows;
       y += 40) {
    cv::line(
        combined,
        cv::Point(0, y),
        cv::Point(combined.cols, y),
        cv::Scalar(0, 255, 0),
        1
    );
  }

  // ============================================
  // Show rectified result
  // ============================================

  cv::imshow(
      "Rectified Stereo",
      combined
  );

  cv::waitKey(0);

  return 0;
}
