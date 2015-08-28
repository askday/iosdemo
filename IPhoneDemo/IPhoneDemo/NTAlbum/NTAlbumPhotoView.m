//
//  NTAlbumPhotoView.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/17.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTAlbumPhotoView.h"
#import "NTAlbumPhotoImageView.h"

@interface NTAlbumPhotoView()<UIGestureRecognizerDelegate>

@end

@implementation NTAlbumPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2];
//        self.pagingEnabled = YES;
//        self.scrollEnabled = YES;
//        self.showsVerticalScrollIndicator = NO;
//        self.showsHorizontalScrollIndicator = NO;
        self.clipsToBounds = NO;
        
       
    }
    return self;
}

-(void)setPhotos:(NSArray *)photos center:(CGPoint)center
{
    int width  = self.bounds.size.width * 0.8;
    CGRect photoRect = CGRectMake(0, 0, width - 5, width -5);
    CGPoint imageCenter  = CGPointMake(center.x - self.frame.origin.x, center.y - self.frame.origin.y);
    if (photos.count > 1) {
        photoRect = CGRectMake(0, 0, width - 5, width/2 - 5);
    }
    
    NSUInteger photosCount = photos.count >1 ? 2 : photos.count;
    for (NSUInteger i=0 ;i < photosCount;i++) {
        UIImage* image = [photos objectAtIndex:i];
        NTAlbumPhotoImageView* imageView = [[NTAlbumPhotoImageView alloc] initWithImage:image];
        imageView.frame = photoRect;
        imageView.center = imageCenter;
        imageView.defaultCenter = imageCenter;
        [imageView setUserInteractionEnabled:YES];
        
        if (i==0) {
            UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
            panGesture.delegate = self;
            [imageView addGestureRecognizer:panGesture];
        }
        
        [self addSubview:imageView];
        
        if (center.y > self.bounds.size.height/2) {
            imageCenter.y -= photoRect.size.height;
        }
        else{
            imageCenter.y += photoRect.size.height;
        }
        imageCenter.y += 20;
    }
//    self.contentOffset = imageCenter;
//    self.contentSize = CGSizeMake(width*1.4, height*1.1);
//    NSLog(@"%@",NSStringFromCGSize(self.contentSize));
}

- (void)resetPhotoLocations
{
    for (NSUInteger i = 0;i<self.subviews.count;i++) {
        UIView* subview = [self.subviews objectAtIndex:i];
        if ([subview isKindOfClass:[NTAlbumPhotoImageView class]]) {
            NTAlbumPhotoImageView* photoImageView = (NTAlbumPhotoImageView*)subview;
            photoImageView.center = photoImageView.defaultCenter;
        }
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIImageView class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)gesture
{
    UIView* touchView = gesture.view;
    CGPoint panPoint = [gesture translationInView:self];
    if ([touchView isKindOfClass:[NTAlbumPhotoImageView class]]) {
        NTAlbumPhotoImageView* touchImageView = (NTAlbumPhotoImageView*)touchView;
        //添加移出中心点判断
        CGRect currentFrame = touchView.frame;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(panPoint.x, panPoint.y);
        CGRect afterMoverFrame = CGRectApplyAffineTransform(currentFrame, transform);
        
        if (CGRectContainsPoint(afterMoverFrame, touchImageView.defaultCenter)) {
            touchView.center = CGPointMake(touchView.center.x + panPoint.x, touchView.center.y);
        }
    }
    [gesture setTranslation:CGPointMake(0, 0) inView:self];
}


@end
