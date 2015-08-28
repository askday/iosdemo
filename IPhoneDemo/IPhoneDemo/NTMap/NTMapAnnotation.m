//
//  NTMapAnnotation.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/18.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTMapAnnotation.h"

@implementation NTMapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}
@end
