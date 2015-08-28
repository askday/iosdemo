//
//  NTMapViewController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/18.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "NTMapAnnotation.h"
#import "NTMapAnnotationView.h"

#import "NTMapOverlay.h"
#import "NTMapOverlayRender.h"

#import "NTMapViewController.h"

@interface NTMapViewController ()<MKMapViewDelegate,UIGestureRecognizerDelegate>
{
    MKMapView* mapView;
    int tapFlag;
    CLLocationCoordinate2D lineLocation[2];
}
@end

@implementation NTMapViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor grayColor];
        tapFlag = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = self.view.bounds;
    rect.origin.x +=10;
    rect.origin.y +=80;
    rect.size.height -=150;
    rect.size.width  -=20;
    mapView = [[MKMapView alloc] initWithFrame:rect];
//    mapView.pitchEnabled = NO;
//    mapView.scrollEnabled = NO;
//    mapView.zoomEnabled = NO;
    [self showCompass:NO];
    mapView.showsBuildings = YES;
    mapView.delegate = self;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [mapView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer* tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tapGesture2.delegate = self;
    tapGesture2.numberOfTapsRequired = 1;
    tapGesture2.numberOfTouchesRequired = 2;
    [mapView addGestureRecognizer:tapGesture2];
    
    [tapGesture requireGestureRecognizerToFail:tapGesture2];
    
    [self.view addSubview:mapView];
}

-(void)showCompass:(BOOL)bShow
{
    if (mapView) {
        for (UIView* subView in mapView.subviews ) {
            NSLog(@"%@",[subView class]);
            if ([subView isKindOfClass:NSClassFromString(@"MKCompassView")]) {
                subView.hidden = !bShow;
            }
        }
    }
}

#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)tmpmapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NTMapAnnotation class]]) {
        static NSString *identifier=@"custom";
        NTMapAnnotationView *customPinView = (NTMapAnnotationView *)[tmpmapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (customPinView == nil)
        {
            customPinView = [[NTMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            UIImage* image = [UIImage imageNamed:@"AppIcon"];
            customPinView.image = image;
        }
        else
        {
            customPinView.annotation = annotation;
        }
        return customPinView;
    }
    else if([annotation isKindOfClass:[MKPointAnnotation class]]){
        static NSString *identifier=@"pin";
        MKAnnotationView *pinView = (MKAnnotationView *)[tmpmapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (pinView == nil)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//            UIImage* image = [UIImage imageNamed:@"hongbao1"];
//            pinView.image = image;
//            pinView.canShowCallout = NO;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"annotation selected");
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"annotation deseelcted");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if( [overlay isKindOfClass:[NTMapOverlay class]]){
        NTMapOverlayRender* overlayRender = [[NTMapOverlayRender alloc] initWithOverlay:overlay];
        overlayRender.customImage = [UIImage imageNamed:@"flight_direction_mark"];
        overlayRender.strokeColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        overlayRender.lineWidth = overlayRender.customImage.size.height;
        return overlayRender;
    }
    else if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer* lineRender  = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineRender.fillColor = [UIColor redColor];
        lineRender.strokeColor = [UIColor grayColor];
        lineRender.lineWidth = 3;
        return lineRender;
    }
    return nil;
}

#pragma mark UIGestureRecognizerDelegate
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if ([gestureRecognizer.view isKindOfClass:[MKAnnotationView class]]) {
//        return NO;
//    }
//    return YES;
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isKindOfClass:[MKAnnotationView class]]) {
//        return NO;
//    }
//    return YES;
//}

-(void)handleTap:(UITapGestureRecognizer*)gesture
{
    if ([gesture.view isKindOfClass:[NTMapAnnotationView class]]) {
        return;
    }
    
    CGPoint location = [gesture locationInView:mapView];
    CLLocationCoordinate2D coordinate = [mapView convertPoint:location toCoordinateFromView:mapView];
    NSLog(@"%f,%f", coordinate.latitude,coordinate.longitude);
    NTMapAnnotation* annotation = [[NTMapAnnotation alloc] initWithCoordinate:coordinate];
    annotation.title = @"title";
    annotation.subtitle = @"subTitle";
    [mapView addAnnotation:annotation];
    
    switch (tapFlag) {
        case 0:
            lineLocation[0] = coordinate;
            tapFlag ++;
            break;
        case 1:
            lineLocation[1] = coordinate;
            tapFlag++;
        case 2:
            lineLocation[1] = coordinate;
        default:
            break;
    }
    
    if (tapFlag == 2) {
        NTMapOverlay* customOvler = [NTMapOverlay polylineWithCoordinates:lineLocation count:2];
        [mapView addOverlay:customOvler];
        
//        MKPolyline* ovlerline = [MKPolyline polylineWithCoordinates:lineLocation count:2];
//        [mapView addOverlay:ovlerline];
//        CLLocationCoordinate2D centerCoor = CLLocationCoordinate2DMake((lineLocation[0].latitude + lineLocation[1].latitude)/2, (lineLocation[0].longitude + lineLocation[1].longitude)/2);
//        
//        MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
//        annotation.coordinate = centerCoor;
//        annotation.title = @"title";
//        annotation.subtitle = @"subTitle";
//        [mapView addAnnotation:annotation];
        
        lineLocation[0] = coordinate;
    }
    
    
}

@end
