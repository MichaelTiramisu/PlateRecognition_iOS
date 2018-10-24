//
//  RealtimePlateRecognitionViewController.m
//  PlateRecognition
//
//  Created by Siyang Liu on 17/5/9.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

#import "RealtimePlateRecognitionViewController.h"
//#import "PlateRecognition.h"
//#import "MatUIImageConversion.h"
#import "PlateRecognizer.h"

@interface RealtimePlateRecognitionViewController ()

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIImageView *generateImageView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) PlateRecognizer *plateRecognizer;

// 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;
// AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
// 输出图片
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
// session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头)
@property (nonatomic, strong) AVCaptureSession *session;
// 图像预览层，实时显示捕获的图像
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) AVCaptureConnection *connection;

@end

@implementation RealtimePlateRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeCamera];
    self.plateRecognizer = [[PlateRecognizer alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载connection
- (AVCaptureConnection *)connection {
    if (_connection == nil) {
        _connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    }
    return _connection;
}

#pragma mark - Initialize the camera
- (void)initializeCamera {
    // AVCaptureDevicePositionBack  后置摄像头
    // AVCaptureDevicePositionFront 前置摄像头
    self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.session = [[AVCaptureSession alloc] init];
    // 拿到的图像的大小可以自行设定
    // AVCaptureSessionPreset320x240
    // AVCaptureSessionPreset352x288
    // AVCaptureSessionPreset640x480
    // AVCaptureSessionPreset960x540
    // AVCaptureSessionPreset1280x720
    // AVCaptureSessionPreset1920x1080
    // AVCaptureSessionPreset3840x2160
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    // 输入输出设备结合
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    // 预览层的生成
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    //    self.videoPreviewLayer.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.videoPreviewLayer.frame = self.previewView.bounds;
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    [self.view.layer addSublayer:self.videoPreviewLayer];
    [self.previewView.layer addSublayer:self.videoPreviewLayer];
    if ([self.device lockForConfiguration:nil]) {
        // 自动闪光灯
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        // 自动白平衡,但是好像一直都进不去
        if ([self.device isWhiteBalanceModeSupported:(AVCaptureWhiteBalanceModeAutoWhiteBalance)]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [self.device unlockForConfiguration];
    }
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
        if (device.position == position) {
            return device;
        }
    return nil;
}

#pragma mark - Handle start button click event
- (IBAction)startButtonClick:(UIButton *)sender {
    if (self.timer == nil) {
        // 设备取景开始
        [self.session startRunning];
        // 设置定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getImageAndRecognizePlate) userInfo:nil repeats:YES];        
    }
}

#pragma mark - Handle stop button click event
- (IBAction)stopButtonClick:(UIButton *)sender {
    [self.session stopRunning];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 获取照片并设别车牌
- (void)getImageAndRecognizePlate {
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:self.connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != nil) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//            [self.generateImageView setImage:[UIImage imageWithData:imageData]];
            
            self.plateRecognizer.image = [UIImage imageWithData:imageData];
            [self.resultLabel setText:[self.plateRecognizer recognizePlate]];
            [self.generateImageView setImage:self.plateRecognizer.image];
        }
    }];
}

@end
