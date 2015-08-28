//
//  NTMapAnnotationView.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/18.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTMapAnnotationView.h"
#import "NTMapCalloutView.h"

@interface NTMapAnnotationView()
{
}
@property(nonatomic,strong)NTMapCalloutView* calloutView;
@end

@implementation NTMapAnnotationView

@synthesize calloutView;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        //添加点击手势，屏蔽地图点击事件
        UITapGestureRecognizer* tapGestured = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGestured];
        
        self.calloutView = [[NTMapCalloutView alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer*)tapGesture
{
    //。。。
    NSLog(@"==%@",[tapGesture.view class]);
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == nil && self.selected) {
        point.y += CGRectGetHeight(calloutView.frame);
        hitView = [calloutView hitTest:point withEvent:event];
    }
    return hitView;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        CGRect annotationViewBounds = self.bounds;
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin.x = -(CGRectGetWidth(calloutViewFrame) - CGRectGetWidth(annotationViewBounds)) * 0.5;
        calloutViewFrame.origin.y = -CGRectGetHeight(calloutViewFrame);
        calloutView.frame = calloutViewFrame;
        [self addSubview:calloutView];
    } else{
        [calloutView removeFromSuperview];
    }
}

@end
