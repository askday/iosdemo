//
//  NTAlbumPhotoView.h
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/17.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTAlbumPhotoView : UIView

- (void)setPhotos:(NSArray*) photos center:(CGPoint)center;
- (void)resetPhotoLocations;

@end
