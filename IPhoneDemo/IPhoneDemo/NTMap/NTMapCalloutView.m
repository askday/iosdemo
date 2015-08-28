//
//  NTMapCalloutView.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/18.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTMapCalloutView.h"

@interface NTMapCalloutView ()
{
    CGFloat kArrowHeight;
    
    UIButton* btnTest;
    UIImageView* imageView1;
    UIImageView* imageView2;
}

@end

@implementation NTMapCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        kArrowHeight = 10;
        CGRect rect =  self.bounds;
        rect.size.height -= kArrowHeight;
        rect = CGRectInset(rect, 4, 4);
        
        UIImage* image = [UIImage imageNamed:@"startup_2"];
        btnTest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnTest.frame = rect;
//        [btnTest setTitle:@"Test" forState:UIControlStateNormal];
//        [btnTest setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btnTest addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnTest];
        
        rect.size.width /=2;
        imageView1 = [[UIImageView alloc] initWithFrame:rect];
        imageView1.image = image;
        [self addSubview:imageView1];
        
        rect.origin.x += rect.size.width + 2;
        imageView2 = [[UIImageView alloc] initWithFrame:rect];
        imageView2.image = image;
        [self addSubview:imageView2];
    }
    return self;
}

-(void)btnAction
{
    NSLog(@"btn clicked");
}

- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(2.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect  rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect)- kArrowHeight;
    
    CGContextMoveToPoint(context, midx + kArrowHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy + kArrowHeight);
    CGContextAddLineToPoint(context,midx - kArrowHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

@end
