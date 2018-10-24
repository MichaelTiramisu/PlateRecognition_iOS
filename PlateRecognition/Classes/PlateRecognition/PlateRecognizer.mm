//
//  PlateRecognizer.m
//  PlateRecognition
//
//  Created by Siyang Liu on 17/5/10.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

#import "PlateRecognizer.h"
#import "PlateRecognition.h"
#import "MatUIImageConversion.h"

@implementation PlateRecognizer

- (NSString *)recognizePlate {
    if (self.image != nil) {
        if (!self.didTrainKNN) {
            [self trainKNN];
        }
        Mat matImage = [MatUIImageConversion cvMatFromUIImage:self.image];
        string resultString = recognizePlate(matImage);
        self.image = [MatUIImageConversion UIImageFromCVMat:matImage];
        return [NSString stringWithCString:resultString.c_str() encoding:[NSString defaultCStringEncoding]];
    }
    return nil;
}

// Method to train the KNN
- (void)trainKNN {
    if (!self.didTrainKNN) {
        // attempt KNN training
        if (loadKNNDataAndTrainKNN()) {
            self.didTrainKNN = YES;
        } else {
            // if KNN training was not successful
            // show error message
            cout << endl << endl << "error: error: KNN traning was not successful" << endl << endl;
            NSLog(@"Train KNN failed!");
        }
    }
}

@end
