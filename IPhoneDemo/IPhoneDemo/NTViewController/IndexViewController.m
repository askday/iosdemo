//
//  IndexViewController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/16.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import "NTPullScrollView.h"
#import "IndexViewController.h"
//#import "NTCameraViewController.h"

@interface IndexViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NTPullScrollView *_pullScrollView;
}
@property (nonatomic, strong) UIButton *btnShowCamera;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IndexViewController

@synthesize btnShowCamera;
@synthesize imageView;

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"首页";
        self.view.backgroundColor = [UIColor clearColor];
        self.hidesBottomBarWhenPushed = NO;

        [self.tabBarItem setTitle:nil];
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_index"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_index_s"]];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@,%@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
    _pullScrollView = [[NTPullScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_pullScrollView];

    CGRect rect = CGRectMake(0, 515, self.view.bounds.size.width, 35);
    self.btnShowCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShowCamera setUserInteractionEnabled:YES];
    [btnShowCamera setTitle:@"相机测试" forState:UIControlStateNormal];
    [btnShowCamera addTarget:self action:@selector(showOtherCamera) forControlEvents:UIControlEventTouchUpInside];
    btnShowCamera.frame = rect;
    btnShowCamera.backgroundColor = [UIColor redColor];
    [_pullScrollView addView:btnShowCamera];

    for (int i = 0; i < self.view.subviews.count; i++) {
        NSLog(@"%@", [[self.view.subviews objectAtIndex:i] class]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showOtherCamera
{
    NSLog(@"showCamera");
    //    UIImagePickerController *photo = [[UIImagePickerController alloc] init];
    //    photo.delegate = self;
    //    photo.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    photo.allowsEditing = YES;
    //    [self presentViewController:photo animated:YES completion:nil];

    //    NTCameraViewController *cameraController = [[NTCameraViewController alloc] init];
    //    if (self.navigationController) {
    //        [self.navigationController pushViewController:cameraController animated:YES];
    //    }
    //    else {
    //        [self presentViewController:cameraController animated:YES completion:nil];
    //    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                 [self handleQrImg:pickedImage];
                               }];
}

- (void)handleQrImg:(UIImage *)img
{
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 515, img.size.width, img.size.height);
        [_pullScrollView addView:imageView];
    }
    imageView.image = img;
}

@end
