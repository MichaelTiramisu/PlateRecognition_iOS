//
//  MatUIImageConversion.h
//  PlateRecognition
//
//  Created by Siyang Liu on 17/5/9.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

#import <OpenCV/opencv2/world.hpp>

using namespace cv;

@interface MatUIImageConversion : NSObject

+ (Mat)cvMatFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(Mat)cvMat;

@end
