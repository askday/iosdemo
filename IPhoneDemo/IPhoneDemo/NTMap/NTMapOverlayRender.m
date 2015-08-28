//
//  MTMapOverlayRender.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/19.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTMapOverlayRender.h"

@implementation NTMapOverlayRender

@synthesize customImage;

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{

    if (customImage) {
        
        CGFloat imageWidth = customImage.size.width/zoomScale;
        CGFloat imageHeight = customImage.size.height/zoomScale;
        
        MKMapPoint* mapPoint = [[self polyline] points];
        MKMapPoint startMapPoint = mapPoint[0];
        MKMapPoint endPoint = mapPoint[1];
        
        CGPoint start = [self pointForMapPoint:startMapPoint];
        CGPoint end = [self pointForMapPoint:endPoint];
        
//        CGContextMoveToPoint(context, start.x, start.y);
//        CGContextAddLineToPoint(context, end.x, end.y);
//        CGContextSetLineCap(context, kCGLineCapRound);
//        CGContextSetLineWidth(context, imageHeight);
//        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
//        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextSaveGState(context);
        CGFloat angle = atan2(end.y -start.y, end.x -start.x);
        CGAffineTransform transform = CGAffineTransformMakeTranslation(start.x,start.y);
        transform = CGAffineTransformRotate(transform, angle);
        CGContextConcatCTM(context, transform);
        int lineLength = sqrtf(pow(end.y-start.y,2) + pow(end.x -start.x, 2));
        int i =0,imageCount = lineLength/imageWidth;
        CGRect imageRect = CGRectMake(0, -imageHeight/2, imageWidth, imageHeight);
        while (i<imageCount) {
            CGContextDrawImage(context, imageRect, customImage.CGImage);
            imageRect.origin.x += imageWidth;
            i++;
        }
        CGContextConcatCTM(context, CGAffineTransformInvert(transform));
        CGContextRestoreGState(context);
        
//        MKMapPoint imageCenter = MKMapPointMake(MKMapRectGetMidX(theMapRect), MKMapRectGetMidY(theMapRect));
//        CLLocationCoordinate2D coord = MKCoordinateForMapPoint(imageCenter);
//        CGRect imageRect = theRect;
//        imageRect.origin.x = centerX - 20;
//        imageRect.origin.y = centerY - 20;
//        imageRect.size.width = 40;
//        imageRect.size.height = 40;
//        CGContextDrawImage(context, imageRect, customImage.CGImage);
        
        // Clip the context to the bounding rectangle.
//        CGContextAddRect(context, theRect);
//        CGContextClip(context);
//        
//        // Set up the gradient color and location information.
//        CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
//        CGFloat locations[4] = {0.0, 0.33, 0.66, 1.0};
//        CGFloat components[16] = {0.0, 0.0, 1.0, 0.5,
//            1.0, 1.0, 1.0, 0.8,
//            1.0, 1.0, 1.0, 0.8,
//            0.0, 0.0, 1.0, 0.5};
//        // Create the gradient.
//        CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, 4);
//        CGPoint start, end;
//        start = CGPointMake(CGRectGetMidX(theRect), CGRectGetMinY(theRect));
//        end = CGPointMake(CGRectGetMidX(theRect), CGRectGetMaxY(theRect));
//        
//        // Draw.
//        CGContextDrawLinearGradient(context, myGradient, start, end, 0);
//        
//        // Clean up.
//        CGColorSpaceRelease(myColorSpace);
//        CGGradientRelease(myGradient);
        
//         [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
    }
}

@end
