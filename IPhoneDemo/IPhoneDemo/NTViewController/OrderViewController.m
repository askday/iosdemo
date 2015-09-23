//
//  OrderViewController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/16.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "OrderViewController.h"
#import "DemoDefine.h"
#import "Masonry.h"
#import "DataKVO.h"

@interface OrderViewController () <UIAlertViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate>
@property (nonatomic, strong) UITextField *txtInput;
@property (nonatomic, strong) NSArray *btnArrays;
@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, strong) DataKVO *kvo;
@end

@implementation OrderViewController

- (void)dealloc
{
    [_kvo removeObserver:self forKeyPath:@"stockName"];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"订单";
        self.hidesBottomBarWhenPushed = NO;

        [self.tabBarItem setTitle:nil];
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_order"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_order_s"]];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtInput = [[UITextField alloc] init];
    _txtInput.backgroundColor = [UIColor redColor];
    _txtInput.delegate = self;
    [_txtInput addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_txtInput];
    [_txtInput mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.view.mas_centerX);
      make.centerY.equalTo(self.view.mas_centerY).offset(-40);
      make.size.mas_equalTo(CGSizeMake(150, 40));
    }];

    self.kvo = [[DataKVO alloc] init];
    [_kvo setValue:@"netease" forKey:@"stockName"];
    [_kvo addObserver:self forKeyPath:@"stockName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

    self.btnArrays = @[ @[ @0, @"test", @"btnTestClick" ],
                        @[ @1, @"跳转到火车票", @"btnToTrainClick" ],
                        @[ @2, @"跳转到众筹", @"btnToCrowFundingClick" ],
                        @[ @3, @"presentTest", @"btnPresentTestClick" ],
                        @[ @4, @"KVO Test", @"btnKVOTestClick" ] ];

    UIView *preView = _txtInput;
    for (int i = 0; i < _btnArrays.count; i++) {
        NSArray *subArray = _btnArrays[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:subArray[1] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:0.5465 green:0.5328 blue:1.0 alpha:1.0]];
        [btn addTarget:self action:NSSelectorFromString(subArray[2]) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.size.mas_equalTo(CGSizeMake(150, 40));
          make.centerX.equalTo(preView.mas_centerX);
          make.top.equalTo(preView.mas_bottom).offset(10);
        }];
        preView = btn;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"stockName"]) {
        _txtInput.text = [_kvo valueForKey:@"stockName"];
    }
}

- (void)btnKVOTestClick
{
    [_kvo setValue:[NSString stringWithFormat:@"crowd found %d", arc4random()] forKey:@"stockName"];
}

- (void)btnPresentTestClick
{
    UIViewController *vc = [[UIViewController alloc] init];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controllerClick:)];
    [vc.view addGestureRecognizer:tapGesture];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)controllerClick:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = tap.view;
    UIResponder *responser = [view nextResponder];
    UIViewController *vc = (UIViewController *)responser;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)popViewPorTimer
{
    UIViewController *controller = [[UIViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)btnTestClick
{
    [_txtInput resignFirstResponder];
    //    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 8.0) {
    //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
    //                                                               style:UIAlertActionStyleDefault
    //                                                             handler:^(UIAlertAction *action) {
    //                                                               UIViewController *controller = [[UIViewController alloc] init];
    //                                                               [self.navigationController pushViewController:controller animated:YES];
    //                                                             }];
    //
    //        [alert addAction:cancelAction];
    //        [self presentViewController:alert animated:YES completion:nil];
    //    }
    //    else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"cacel" otherButtonTitles:nil, nil];
    [alert becomeFirstResponder];
    [alert show];
    //    }
}

- (void)btnToTrainClick
{
    NSURL *url = [NSURL URLWithString:@"train163://mainOrder"];
    //    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //    [connect start];

    if ([[UIApplication sharedApplication]
            canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)btnToCrowFundingClick
{
    //    NSURL *url = [NSURL URLWithString:@"cf163://userAccount"];
    //    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //    [connect start];
    NSURL *url = [NSURL URLWithString:@"cf163://userAccount"];
    if ([[UIApplication sharedApplication]
            canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"getdata===");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finish load data");
}

#pragma mark UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"%s", __func__);
}
- (void)didPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"%s", __func__);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(popViewPorTimer) withObject:nil afterDelay:0.001];
    //    NSTimer *testTimer = [NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(popViewPorTimer) userInfo:nil repeats:NO];
}
#pragma mark UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%s", __func__);
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSLog(@"%s", __func__);
}

- (void)textFieldDidChanged:(UITextField *)sender
{
    [self btnTestClick];
}
@end
