//
//  NTMapAnnotationView.h
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/18.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface NTMapAnnotationView : MKAnnotationView
- (instancetype)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
