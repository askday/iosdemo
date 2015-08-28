//
//  NTCameraViewController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/7/8.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTCameraViewController.h"
#import <ZXingObjC/ZXingObjC.h>

@interface NTCameraViewController () <ZXCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, assign) BOOL scanSuccess;
@end

@implementation NTCameraViewController

- (void)dealloc
{
    [self.capture.layer removeFromSuperlayer];
    [self.capture stop];
    self.capture.delegate = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor redColor];
        self.title = @"相机";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = NO;
    }
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.frame;
    self.capture.scanRect = self.view.frame;
    _scanSuccess = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    UIImagePickerController *photo = [[UIImagePickerController alloc] init];
    //    photo.delegate = self;
    //    photo.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    photo.allowsEditing = YES;
    //    [self presentViewController:photo animated:YES completion:nil];

    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.layer.frame = self.view.frame;
    [self.view.layer addSublayer:self.capture.layer];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   //        [self handleQrImg:pickedImage];
                               }];
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureCameraIsReady:(ZXCapture *)capture
{
}

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
{
    if (!result)
        return;
    if (!_scanSuccess) {
        [self handleScanResult:result.text];
    }
}

- (void)alertSuccess
{
    _scanSuccess = YES;
    //    static SystemSoundID soundID=0;
    //    if (soundID==0) {
    //        //注册声音到系统
    //        NSString *path = [[NSBundle mainBundle] pathForResource:@"help_scan_success" ofType:@"mp3"];
    //        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
    //    }
    //    AudioServicesPlaySystemSound(soundID);
}

- (void)handleScanResult:(NSString *)result
{

    [self alertSuccess];
    if (!result || result.length == 0) {
        NSLog(@"提示信息,无效的二维码");
        return;
    }
    NSLog(@"result:%@", result);

    if ([self isValidUrl:result]) { //是url链接

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
    }
}

- (BOOL)isValidUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    return url && url.scheme && url.host;
}

@end
