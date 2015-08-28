//
//  flashViewController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15-6-12.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTFlashViewController.h"
#import "DemoDefine.h"

@interface NTFlashViewController () <UIScrollViewDelegate>

@end

@implementation NTFlashViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[ApplicationTools tools] showStatusBar:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 4, self.view.bounds.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];

    for (int i = 0; i < 4; i++) {
        UIImage *startupImage = [UIImage imageNamed:[NSString stringWithFormat:@"startup_%d", i + 1]];
        UIImageView *startupImageV = [[UIImageView alloc] initWithImage:startupImage];
        startupImageV.frame = CGRectMake(i * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [scrollView addSubview:startupImageV];
    }

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, 50 * SCREEN_HEIGHT / 568);
    CGPoint center = CGPointMake(scrollView.bounds.size.width * 3.5, (568 - 74) * SCREEN_HEIGHT / 568);
    closeBtn.center = center;

    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:closeBtn];
}

- (void)closeBtnClick
{
    [[ApplicationTools tools] showStatusBar:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(flashComplete)]) {
        [self.delegate flashComplete];
    }
}

#pragma mark UIScrollViewDelegate

@end
