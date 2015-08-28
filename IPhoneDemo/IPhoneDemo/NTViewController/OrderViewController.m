//
//  OrderViewController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/16.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "OrderViewController.h"
#import "DemoDefine.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

-(id)init
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

@end
