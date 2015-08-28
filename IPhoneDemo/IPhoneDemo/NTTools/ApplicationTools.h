//
//  ApplicationTools.h
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/15.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ApplicationTools : NSObject

+ (instancetype)tools;

- (NSInteger)getSystemVersion;
- (void)showStatusBar:(BOOL)bShow;
- (UIImage *)generatePureColorImage:(UIColor *)color size:(CGSize)size;
- (UIImage *)getNavibarImage;
@end
