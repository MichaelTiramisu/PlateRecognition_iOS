//
//  MatUIImageConversion.m
//  PlateRecognition
//
//  Created by Siyang Liu on 17/5/9.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

#import "MatUIImageConversion.h"

#import <OpenCV/opencv2/opencv.hpp>
#import <OpenCV/opencv2/imgcodecs/ios.h>

@implementation MatUIImageConversion

+ (Mat)cvMatFromUIImage:(UIImage *)image {
    Mat matImage;
    UIImageToMat(image, matImage);
    cvtColor(matImage, matImage, CV_RGB2BGR);
    return matImage;
};

+ (UIImage *)UIImageFromCVMat:(Mat)cvMat {
    cvtColor(cvMat, cvMat, CV_BGR2RGB);
    
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    CGColorSpaceRef colorspace;
    
    if (cvMat.elemSize() == 1) {
        colorspace = CGColorSpaceCreateDeviceGray();
    }
    else
    {
        colorspace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols, cvMat.rows, 8, 8 * cvMat.elemSize(), cvMat.step[0], colorspace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorspace);
    
    return image;
};

@end
