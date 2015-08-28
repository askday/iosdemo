//
//  NTAlbumController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/16.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTAlbumController.h"
#import "NTAlbumView.h"
#import "NTAlbumPhotoView.h"

@interface NTAlbumController ()<UIScrollViewDelegate>
{
    NTAlbumView* albumView;
}
@end

@implementation NTAlbumController
- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"纪念册";
        self.automaticallyAdjustsScrollViewInsets = NO;//禁止垂直方向的滑动
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int imageCount  = 8;
    NSMutableArray* linePoints  = [NSMutableArray arrayWithCapacity:imageCount];
    
    albumView = [[NTAlbumView alloc] initWithFrame:self.view.bounds];
    albumView.contentSize = CGSizeMake(self.view.bounds.size.width*imageCount, self.view.bounds.size.height);
    
    albumView.delegate = self;
    [self.view addSubview:albumView];
    
    int flag = 1;
    int centerY = 0;
    int height = self.view.bounds.size.height;
    
    for (int i= 0; i<imageCount; i++) {
        
        if (i==0||i==imageCount -1) {
            flag = 0;
        }
        else if(flag == 0){
            flag = 1;
        }
        else{
            flag *= -1;
        }
        centerY = flag*height/8;
        
        UIImage *startupImage = [UIImage imageNamed:[NSString stringWithFormat:@"startup_%d",i%4 + 1]];
        
        CGRect rect = CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        CGPoint centerPoint  = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2 + centerY);
        
        NTAlbumPhotoView* photoView = [[NTAlbumPhotoView alloc] initWithFrame:rect];
        
        if (i==4) {
            UIImage *startupImage1 = [UIImage imageNamed:[NSString stringWithFormat:@"startup_%d",i%4 + 1]];
            
            [photoView setPhotos: [NSArray arrayWithObjects:startupImage,startupImage1, nil] center:centerPoint];
        }
        else{
            [photoView setPhotos: [NSArray arrayWithObjects:startupImage, nil] center:centerPoint];
        }
        [albumView addSubview:photoView];
        
        [linePoints addObject: [NSValue valueWithCGPoint:centerPoint]];
    }
    
    [albumView setLinePoints:linePoints];
    [albumView setNeedsDisplay];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [albumView setNeedsDisplay];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [albumView resetPhotoViews];
}

@end
