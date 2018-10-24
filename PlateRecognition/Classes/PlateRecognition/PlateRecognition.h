//
//  PlateRecognition.h
//  PlateRecognition
//
//  Created by Siyang Liu on 17/5/9.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//


#ifndef PLATE_RECOGNITION_H
#define PLATE_RECOGNITION_H

#include <iostream>
#include <string>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include "DetectPlates.h"
#include "PossiblePlate.h"
#include "DetectChars.h"

using namespace cv;
using std::cout;
using std::endl;
using std::string;
using std::vector;

//#define SHOW_STEPS            // un-comment or comment this line to show steps or not

// global constants ///////////////////////////////////////////////////////////////////////////////
const Scalar SCALAR_BLACK = Scalar(0.0, 0.0, 0.0);
const Scalar SCALAR_WHITE = Scalar(255.0, 255.0, 255.0);
const Scalar SCALAR_YELLOW = Scalar(0.0, 255.0, 255.0);
const Scalar SCALAR_GREEN = Scalar(0.0, 255.0, 0.0);
const Scalar SCALAR_RED = Scalar(0.0, 0.0, 255.0);


string recognizePlate(Mat& image);
void drawRedRectangleAroundPlate(cv::Mat &imgOriginalScene, PossiblePlate &licPlate);
void writeLicensePlateCharsOnImage(cv::Mat &imgOriginalScene, PossiblePlate &licPlate);


# endif

