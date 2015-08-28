//
//  ApplicationTools.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/15.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ApplicationTools.h"

@implementation ApplicationTools

+ (instancetype)tools
{
    static ApplicationTools *tools = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      tools = [[ApplicationTools alloc] init];
    });

    return tools;
}

- (NSInteger)getSystemVersion
{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    return version.integerValue;
}

- (void)showStatusBar:(BOOL)bShow
{
    [[UIApplication sharedApplication] setStatusBarHidden:!bShow withAnimation:UIStatusBarAnimationNone];
    if (bShow) {
        if (([[UIDevice currentDevice].systemVersion integerValue] < 7)) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
        }
        else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        }
    }
}

- (UIImage *)generatePureColorImage:(UIColor *)color size:(CGSize)size
{
    UIImage *pImage = nil;

    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    pImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pImage;
}

- (UIImage *)getNavibarImage
{
    if (self.getSystemVersion >= 7) {
        return [UIImage imageNamed:@"navigationBar_7"];
    }
    else {
        return [UIImage imageNamed:@"navigationBar"];
    }
}

@end
