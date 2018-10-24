//
//  PicturePlateRecognitionViewController.m
//  PlateRecognition
//
//  Created by Siyang Liu on 17/5/9.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

#import "PicturePlateRecognitionViewController.h"
#import "PlateRecognition.h"
#import "MatUIImageConversion.h"
#import "PlateRecognizer.h"

@interface PicturePlateRecognitionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) PlateRecognizer *plateRecognizer;

@end

@implementation PicturePlateRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.plateRecognizer = [[PlateRecognizer alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Handle select picture button click event
- (IBAction)selectPictureButtonClick:(UIButton *)sender {
    // 创建AlertController对象
    // preferredStyle可以设置是AlertView样式或者ActionSheet样式
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please select the source of the picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // Initialize an Image Picker Controller
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // Set the delegate to the view controller itself
    imagePickerController.delegate = self;
    // Check if the source of camera is avaliable
    // 创建取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    // 创建拍照按钮
    UIAlertAction *takePictureAction = [UIAlertAction actionWithTitle:@"Take a picture from camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    // 创建从相册选择按钮
    UIAlertAction *chooseFromAlbum = [UIAlertAction actionWithTitle:@"Choose from album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    // 添加按钮
    [alertController addAction:cancelAction];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:takePictureAction];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [alertController addAction:chooseFromAlbum];
    }
    // 显示
    [self presentViewController:alertController animated:YES completion:nil];
}

# pragma mark - Handle recognize button click event
- (IBAction)recognizeButtonClick:(UIButton *)sender {
    if (self.imageView.image != nil) {
//        NSDate *firstDate = [NSDate date];
        // Test 100 time for performace testing
//        for (NSInteger i = 0; i < 100; i++) {
//            Mat image = [MatUIImageConversion cvMatFromUIImage:self.imageView.image];
//            string plateNumber = recognizePlate(image);
//            [self.imageView setImage:[MatUIImageConversion UIImageFromCVMat:image]];
//            [self.resultLabel setText:[NSString stringWithCString:plateNumber.c_str() encoding:[NSString defaultCStringEncoding]]];
            self.plateRecognizer.image = self.imageView.image;
            [self.resultLabel setText:[self.plateRecognizer recognizePlate]];
            [self.imageView setImage:self.plateRecognizer.image];
//        }
//        NSDate *secondDate = [NSDate date];
//        int a = 0;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Close the Image Picker Controller
    [self dismissViewControllerAnimated:YES completion:nil];
    // Update the image in the image view
    [self.imageView setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
}


@end
