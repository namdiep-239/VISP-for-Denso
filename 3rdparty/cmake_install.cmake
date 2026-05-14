# Install script for directory: /home/nguyen/visp-ws/visp

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "RELEASE")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/man/man1" TYPE FILE PERMISSIONS OWNER_READ GROUP_READ WORLD_READ OWNER_WRITE FILES "/home/nguyen/visp-ws/visp/3rdparty/doc/man/man1/visp-config.1.gz")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/visp3/core" TYPE FILE FILES "/home/nguyen/visp-ws/visp/3rdparty/unix-install/vpConfig.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/visp3" TYPE FILE FILES "/home/nguyen/visp-ws/visp/3rdparty/include/visp3/visp_modules.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/visp3" TYPE FILE FILES "/home/nguyen/visp-ws/visp/3rdparty/include/visp3/visp.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/visp" TYPE FILE FILES
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/visp_modules.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vp1394CMUGrabber.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vp1394TwoGrabber.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpAR.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpAROgre.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpAdaptiveGain.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpAfma6.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpArray2D.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpBSpline.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpBasicFeature.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpBasicKeyPoint.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpBiclops.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpCPUFeatures.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpCalibration.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpCalibrationException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpCameraParameters.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpCannyEdgeDetection.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpCircle.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpCircleHoughTransform.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpClient.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpColVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpColor.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpColorBlindFriendlyPalette.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpColorDepthConversion.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpColorGetter.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpColormap.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpComedi.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpConfig.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpContours.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpConvert.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpCylinder.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpD3DRenderer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDebug.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDenso.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDenso6577.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDetectorAprilTag.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDetectorBase.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDetectorDNNOpenCV.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDetectorDataMatrixCode.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDetectorFace.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDetectorQRCode.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDirectShowDevice.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDirectShowGrabber.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDirectShowGrabberImpl.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDirectShowSampleGrabberI.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDiskGrabber.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplay.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplayD3D.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplayException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplayFactory.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplayGDI.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplayGTK.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplayOpenCV.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplayPCL.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplayWin32.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDisplayX.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDot.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpDot2.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpEigenConversion.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpEndian.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpExponentialMap.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureBuilder.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureDepth.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureDisplay.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureEllipse.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureLine.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureLuminance.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureLuminanceMapping.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMoment.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentAlpha.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentArea.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentAreaNormalized.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentBasic.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentCInvariant.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentCentered.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentCommon.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentDatabase.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentGravityCenter.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureMomentGravityCenterNormalized.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeaturePoint.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeaturePoint3D.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeaturePointPolar.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureSegment.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureThetaU.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureTranslation.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFeatureVanishingPoint.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFlyCaptureGrabber.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFont.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpForceTorqueAtiNetFTSensor.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpForceTorqueAtiSensor.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpForceTorqueIitSensor.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpForceTwistMatrix.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpForwardProjection.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFrameGrabber.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpFrameGrabberException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpGDIRenderer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpGEMM.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpGaussRand.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpGaussianFilter.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpGenericFeature.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpHSV.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpHandEyeCalibration.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpHinkley.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpHistogram.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpHistogramPeak.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpHistogramValey.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpHomogeneousMatrix.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpHomography.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImage.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageCircle.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageConvert.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageDraw.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageFilter.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageIo.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageMorphology.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImagePoint.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageQueue.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageSimulator.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageStorageWorker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageTools.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImageTools_warp.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImage_getters.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImage_lut.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImage_operators.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpImgproc.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpIoException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpIoTools.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpJSON.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpJsonArgumentParser.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpJsonParsing.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpKalmanFilter.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpKeyPoint.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpKeyboard.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpKinect.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpKltOpencv.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpLaserScan.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpLaserScanner.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpLinProg.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpLine.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpLinearKalmanFilterInstantiation.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpList.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMath.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMatrix.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMatrixException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbDepthDenseTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbDepthNormalTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbEdgeKltTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbEdgeTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbGenericTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbHiddenFaces.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbKltTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbScanLine.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtDistanceCircle.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtDistanceCylinder.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtDistanceKltCylinder.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtDistanceKltPoints.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtDistanceLine.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtFaceDepthDense.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtFaceDepthNormal.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtMeEllipse.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtMeLine.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtPolygon.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtTukeyEstimator.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMbtXmlGenericParser.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMe.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMeEllipse.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMeLine.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMeNurbs.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMeSite.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMeTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMegaPose.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMegaPoseTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMeterPixelConversion.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMocap.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMocapQualisys.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMocapVicon.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMoment.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentAlpha.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentArea.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentAreaNormalized.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentBasic.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentCInvariant.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentCentered.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentCommon.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentDatabase.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentGravityCenter.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentGravityCenterNormalized.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMomentObject.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMouseButton.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMunkres.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpMutex.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpNetwork.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpNoise.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpNullptrEmulated.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpNurbs.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpOccipitalStructure.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPanda3DBaseRenderer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPanda3DCommonFilters.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPanda3DFrameworkManager.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPanda3DGeometryRenderer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPanda3DLight.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPanda3DPostProcessFilter.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPanda3DRGBRenderer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPanda3DRenderParameters.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPanda3DRendererSet.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpParallelPort.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpParallelPortException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpParseArgv.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpParticleFilter.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPclViewer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPioneer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPioneerPan.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPixelMeterConversion.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPlane.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPlaneEstimation.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPlot.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPlotCurve.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPlotGraph.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPoint.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPololu.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPolygon.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPolygon3D.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPose.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPoseException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPoseFeatures.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPoseVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpProjectionDisplay.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPtu46.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPylonFactory.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpPylonGrabber.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpQbDevice.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpQbSoftHand.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpQuadProg.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpQuaternionVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRGBa.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRGBf.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRansac.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRealSense2.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRect.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRectOriented.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpReflexTakktile2.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRequest.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRingLight.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobot.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotAfma6.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotBebop2.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotBiclops.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotCamera.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotDenso.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotFlirPtu.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotFranka.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotKinova.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotMavsdk.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotPioneer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotPololuPtu.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotPtu46.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotSimulator.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotTemplate.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotUniversalRobots.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotViper650.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotViper850.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobotWireFrameSimulator.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRobust.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRotationMatrix.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRotationVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRowVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRxyzVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRzyxVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpRzyzVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpScale.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpScanPoint.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSerial.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpServer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpServo.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpServoData.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpServoDisplay.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpServoException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSickLDMRS.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSimulator.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSimulatorAfma6.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSimulatorCamera.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSimulatorException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSimulatorPioneer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSimulatorPioneerPan.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSimulatorViper850.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSphere.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpStatisticalTestAbstract.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpStatisticalTestEWMA.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpStatisticalTestHinkley.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpStatisticalTestMeanAdjustedCUSUM.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpStatisticalTestShewhart.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpStatisticalTestSigma.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSubColVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSubMatrix.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpSubRowVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerBSpline.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerHeader.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerMI.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerMIBSpline.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerMIESM.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerMIForwardAdditional.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerMIForwardCompositional.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerMIInverseCompositional.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerSSD.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerSSDESM.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerSSDForwardAdditional.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerSSDForwardCompositional.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerSSDInverseCompositional.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerTriangle.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerWarp.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerWarpAffine.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerWarpHomography.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerWarpHomographySL3.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerWarpRT.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerWarpSRT.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerWarpTranslation.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerZNCC.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerZNCCForwardAdditional.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerZNCCInverseCompositional.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTemplateTrackerZone.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpThetaUVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpThread.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTime.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTracker.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTrackingException.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTranslationVector.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpTriangle.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpUART.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpUDPClient.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpUDPServer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpUKSigmaDrawerAbstract.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpUKSigmaDrawerMerwe.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpUeyeGrabber.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpUniRand.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpUnicycle.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpUnscentedKalman.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpV4l2Grabber.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpVelocityTwistMatrix.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpVideoReader.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpVideoWriter.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpViewer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpViper.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpViper650.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpViper850.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpVirtuose.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpWin32API.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpWin32Renderer.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpWin32Window.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpWireFrameSimulator.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpWireFrameSimulatorTypes.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpXmlConfigParserKeyPoint.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpXmlParser.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpXmlParserCamera.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpXmlParserHomogeneousMatrix.h"
    "/home/nguyen/visp-ws/visp/3rdparty/include/visp/vpXmlParserRectOriented.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/visp/VISPModules.cmake")
    file(DIFFERENT EXPORT_FILE_CHANGED FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/visp/VISPModules.cmake"
         "/home/nguyen/visp-ws/visp/3rdparty/CMakeFiles/Export/lib/cmake/visp/VISPModules.cmake")
    if(EXPORT_FILE_CHANGED)
      file(GLOB OLD_CONFIG_FILES "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/visp/VISPModules-*.cmake")
      if(OLD_CONFIG_FILES)
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/visp/VISPModules.cmake\" will be replaced.  Removing files [${OLD_CONFIG_FILES}].")
        file(REMOVE ${OLD_CONFIG_FILES})
      endif()
    endif()
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/visp" TYPE FILE FILES "/home/nguyen/visp-ws/visp/3rdparty/CMakeFiles/Export/lib/cmake/visp/VISPModules.cmake")
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/visp" TYPE FILE FILES "/home/nguyen/visp-ws/visp/3rdparty/CMakeFiles/Export/lib/cmake/visp/VISPModules-release.cmake")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/visp" TYPE FILE FILES
    "/home/nguyen/visp-ws/visp/3rdparty/unix-install/VISPConfig-version.cmake"
    "/home/nguyen/visp-ws/visp/3rdparty/unix-install/VISPConfig.cmake"
    "/home/nguyen/visp-ws/visp/3rdparty/unix-install/VISPUse.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE FILE PERMISSIONS OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE OWNER_WRITE FILES "/home/nguyen/visp-ws/visp/3rdparty/unix-install/visp-config")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE PERMISSIONS OWNER_READ GROUP_READ WORLD_READ OWNER_WRITE FILES "/home/nguyen/visp-ws/visp/3rdparty/unix-install/visp.pc")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/clipper/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/apriltag/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/qbdevice/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/reflex-takktile2/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/pugixml-1.14/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/simdlib/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/stb_image/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/tinyexr/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/catch2/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/3rdparty/pololu/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/modules/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/apps/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/demo/cmake_install.cmake")
  include("/home/nguyen/visp-ws/visp/3rdparty/tutorial/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/nguyen/visp-ws/visp/3rdparty/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
