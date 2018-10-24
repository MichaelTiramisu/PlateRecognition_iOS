//
//  MainViewController.m
//  PlateRecognition
//
//  Created by Siyang Liu on 17/5/9.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

#import "MainViewController.h"
#import "PicturePlateRecognitionViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) NSArray *cellNames;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy initialize cell names
- (NSArray *)cellNames {
    if (_cellNames == nil) {
        _cellNames = @[@"Picture Plate Recognition", @"Realtime Plate Recognition"];
    }
    return _cellNames;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell.textLabel setText:self.cellNames[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // Push the corresponding view controller
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PicturePlateRecognition" bundle:nil];
        PicturePlateRecognitionViewController *picturePlateRecognitionVC = [storyboard instantiateViewControllerWithIdentifier:@"PicturePlateRecognitionViewController"];
        [self.navigationController pushViewController:picturePlateRecognitionVC animated:YES];
    } else if (indexPath.row == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RealtimePlateRecognition" bundle:nil];
        PicturePlateRecognitionViewController *picturePlateRecognitionVC = [storyboard instantiateViewControllerWithIdentifier:@"RealtimePlateRecognitionViewController"];
        [self.navigationController pushViewController:picturePlateRecognitionVC animated:YES];
    }
}


@end
