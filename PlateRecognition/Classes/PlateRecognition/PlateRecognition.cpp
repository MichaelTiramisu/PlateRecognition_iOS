//
//  PlateRecognition.cpp
//  PlateRecognition
//
//  Created by Siyang Liu on 17/5/9.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

#include "PlateRecognition.h"

string recognizePlate(Mat& imgOriginalScene) {
//    bool blnKNNTrainingSuccessful = loadKNNDataAndTrainKNN();           // attempt KNN training
//    
//    if (blnKNNTrainingSuccessful == false) {                            // if KNN training was not successful
//        // show error message
//        cout << endl << endl << "error: error: KNN traning was not successful" << endl << endl;
//        return "Train KNN failed!";                                                      // and exit program
//    }
    
    //    imgOriginalScene = cv::imread("/Users/lsy/Downloads/OpenCV_3_License_Plate_Recognition_Cpp-master/image1.png");         // open image
//    imgOriginalScene = imread("/Users/lsy/Desktop/plate.jpg");
    
    if (imgOriginalScene.empty()) {                             // if unable to open image
        cout << "error: image not read from file\n\n";     // show error message on command line
        return "Input image error!";                                              // and exit program
    }
    
    vector<PossiblePlate> vectorOfPossiblePlates = detectPlatesInScene(imgOriginalScene);          // detect plates
    
    vectorOfPossiblePlates = detectCharsInPlates(vectorOfPossiblePlates);                               // detect chars in plates
    
    
    if (vectorOfPossiblePlates.empty()) {                                               // if no plates were found
        cout << endl << "no license plates were detected" << endl;       // inform user no plates were found
        return "No plate found!";
    }
    else {                                                                            // else
        // if we get in here vector of possible plates has at leat one plate
        
        // sort the vector of possible plates in DESCENDING order (most number of chars to least number of chars)
        std::sort(vectorOfPossiblePlates.begin(), vectorOfPossiblePlates.end(), PossiblePlate::sortDescendingByNumberOfChars);
        
        // suppose the plate with the most recognized chars (the first plate in sorted by string length descending order) is the actual plate
        PossiblePlate licPlate = vectorOfPossiblePlates.front();
        
        if (licPlate.strChars.length() == 0) {                                                      // if no chars were found in the plate
            cout << endl << "no characters were detected" << endl << endl;      // show message
            return "No charactor detected!";                                                                              // and exit program
        }
        
        drawRedRectangleAroundPlate(imgOriginalScene, licPlate);                // draw red rectangle around plate
        
        cout << endl << "license plate read from image = " << licPlate.strChars << endl;     // write license plate text to std out
        cout << endl << "-----------------------------------------" << endl;
        
        writeLicensePlateCharsOnImage(imgOriginalScene, licPlate);              // write license plate text on the image
        
        return licPlate.strChars;
    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void drawRedRectangleAroundPlate(cv::Mat &imgOriginalScene, PossiblePlate &licPlate) {
    cv::Point2f p2fRectPoints[4];
    
    licPlate.rrLocationOfPlateInScene.points(p2fRectPoints);            // get 4 vertices of rotated rect
    
    for (int i = 0; i < 4; i++) {                                       // draw 4 red lines
        cv::line(imgOriginalScene, p2fRectPoints[i], p2fRectPoints[(i + 1) % 4], SCALAR_RED, 2);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void writeLicensePlateCharsOnImage(cv::Mat &imgOriginalScene, PossiblePlate &licPlate) {
    cv::Point ptCenterOfTextArea;                   // this will be the center of the area the text will be written to
    cv::Point ptLowerLeftTextOrigin;                // this will be the bottom left of the area that the text will be written to
    
    int intFontFace = CV_FONT_HERSHEY_SIMPLEX;                              // choose a plain jane font
    double dblFontScale = (double)licPlate.imgPlate.rows / 30.0;            // base font scale on height of plate area
    int intFontThickness = (int)std::round(dblFontScale * 1.5);             // base font thickness on font scale
    int intBaseline = 0;
    
    cv::Size textSize = cv::getTextSize(licPlate.strChars, intFontFace, dblFontScale, intFontThickness, &intBaseline);      // call getTextSize
    
    ptCenterOfTextArea.x = (int)licPlate.rrLocationOfPlateInScene.center.x;         // the horizontal location of the text area is the same as the plate
    
    if (licPlate.rrLocationOfPlateInScene.center.y < (imgOriginalScene.rows * 0.75)) {      // if the license plate is in the upper 3/4 of the image
        // write the chars in below the plate
        ptCenterOfTextArea.y = (int)std::round(licPlate.rrLocationOfPlateInScene.center.y) + (int)std::round((double)licPlate.imgPlate.rows * 1.6);
    }
    else {                                                                                // else if the license plate is in the lower 1/4 of the image
        // write the chars in above the plate
        ptCenterOfTextArea.y = (int)std::round(licPlate.rrLocationOfPlateInScene.center.y) - (int)std::round((double)licPlate.imgPlate.rows * 1.6);
    }
    
    ptLowerLeftTextOrigin.x = (int)(ptCenterOfTextArea.x - (textSize.width / 2));           // calculate the lower left origin of the text area
    ptLowerLeftTextOrigin.y = (int)(ptCenterOfTextArea.y + (textSize.height / 2));          // based on the text area center, width, and height
    
    // write the text on the image
    cv::putText(imgOriginalScene, licPlate.strChars, ptLowerLeftTextOrigin, intFontFace, dblFontScale, SCALAR_YELLOW, intFontThickness);
}
