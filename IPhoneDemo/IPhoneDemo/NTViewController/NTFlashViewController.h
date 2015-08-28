//
//  flashViewController.h
//  IPhoneDemo
//
//  Created by wangxiang on 15-6-12.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTFlashViewDelegate <NSObject>

- (void)flashComplete;

@end

@interface NTFlashViewController : UIViewController

@property (nonatomic, weak) id<NTFlashViewDelegate> delegate;

@end
