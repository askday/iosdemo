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

@interface OrderViewController () <UIAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITextField *txtInput;
@property (nonatomic, strong) UIButton *btnTest;
@end

@implementation OrderViewController

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
      make.size.mas_equalTo(CGSizeMake(100, 30));
    }];

    self.btnTest = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnTest setTitle:@"test" forState:UIControlStateNormal];
    [_btnTest setBackgroundColor:[UIColor greenColor]];
    [_btnTest addTarget:self action:@selector(btnTestClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnTest];

    [_btnTest mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(100, 30));
      make.centerX.equalTo(_txtInput.mas_centerX);
      make.top.equalTo(_txtInput.mas_bottom);
    }];
}

- (void)btnTestClick
{
    [_txtInput resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"cacel" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView
{
}
- (void)didPresentAlertView:(UIAlertView *)alertView
{
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIViewController *controller = [[UIViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark UITextfieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSLog(@"%@", textField.text);
}

- (void)textFieldDidChanged:(UITextField *)sender
{
    [self btnTestClick];
}
@end
