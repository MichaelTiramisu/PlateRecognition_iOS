//
//  PlateRecognizer.h
//  PlateRecognition
//
//  Created by Siyang Liu on 17/5/10.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

@interface PlateRecognizer : NSObject

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, assign) BOOL didTrainKNN;

- (NSString *)recognizePlate;

@end
