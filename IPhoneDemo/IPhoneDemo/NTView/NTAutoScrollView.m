//
//  NTAutoScrollView.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/30.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTAutoScrollView.h"

@interface NTAutoScrollView () <UIScrollViewDelegate>
@property (nonatomic, assign) int pageCount;
@property (nonatomic, assign) int currentPageNum;
@property (nonatomic, assign) BOOL scrollToRight;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *autoScrollTimer;

@end

@implementation NTAutoScrollView

@synthesize pageCount;
@synthesize currentPageNum;
@synthesize scrollToRight;
@synthesize scrollView;
@synthesize autoScrollTimer;

- (void)dealloc
{
    [autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.directionalLockEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];

        self.pageCount = 0;
        self.currentPageNum = 0;
        self.scrollToRight = YES;
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScrollPage) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)autoScrollPage
{
    if (pageCount == 0)
        return;

    if (currentPageNum == 0) {
        scrollToRight = YES;
    }
    else if (currentPageNum == pageCount - 1) {
        scrollToRight = NO;
    }

    if (scrollToRight) {
        currentPageNum++;
    }
    else {
        currentPageNum--;
    }
    [scrollView setContentOffset:CGPointMake(currentPageNum * scrollView.bounds.size.width, 0) animated:YES];
}

- (void)setScrollPages:(NSArray *)pages
{
    CGSize viewSize = self.bounds.size;
    scrollView.contentSize = CGSizeMake(viewSize.width * pages.count, viewSize.height);
    int i = 0;
    for (UIImage *image in pages) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i * viewSize.width, 0, viewSize.width, viewSize.height);
        [scrollView addSubview:imageView];
        i++;
    }
    pageCount = pages.count;
}

#pragma mark UIScrollViewDelegate

@end
