//
//  NTAlbumView.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/16.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTAlbumView.h"
#import "NTAlbumPhotoView.h"

@interface NTAlbumView()
@property(nonatomic,strong)UIBezierPath* linePath;
@end

@implementation NTAlbumView
@synthesize linePath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        self.pagingEnabled = YES;
        self.scrollEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)setLinePoints:(NSArray *)linePoints
{
    if (linePoints && linePoints.count >1) {
        UIBezierPath* path  = [UIBezierPath bezierPath];
        for (int i=0; i < linePoints.count; i++) {
            CGPoint point = [[linePoints objectAtIndex:i] CGPointValue];
            if (i==0) {
                [path moveToPoint:point];
            }
            else{
                [path addLineToPoint:point];
            }
        }
        self.linePath = path;
    }
}

- (void)resetPhotoViews
{
    NSArray* subViews = self.subviews;
    for (NTAlbumPhotoView* subView in subViews) {
        [subView resetPhotoLocations];
    }
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextAddPath(context, linePath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
//    [linePath stroke];
//    if (linePoints && linePoints.count > 1) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetAllowsAntialiasing(context, YES);
//      
//        for (int i=0; i<linePoints.count; i++) {
//            CGPoint point = [[linePoints objectAtIndex:i] CGPointValue];
//            if (i== 0) {
//                CGContextMoveToPoint(context, point.x, point.y);
//            }
//            else{
//                CGContextAddLineToPoint(context, point.x, point.y);
//            }
//        }
//        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//        CGContextDrawPath(context, kCGPathStroke);
////        CGContextRelease(context);
//    }
}

@end
