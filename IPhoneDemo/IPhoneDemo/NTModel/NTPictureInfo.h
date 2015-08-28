//
//  NTPictureInfo.h
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/16.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NTPictureInfo : NSObject

@property(nonatomic,assign)NSDate* date;//拍摄日期
@property(nonatomic,assign)CGPoint location;//拍摄经纬度
@property(nonatomic,strong)NSString* info;//附属信息

@end
