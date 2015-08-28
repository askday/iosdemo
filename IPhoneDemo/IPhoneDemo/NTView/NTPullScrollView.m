//
//  NTPullScrollView.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/30.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import <JLRoutes.h>
#import "NTCustomAlertView.h"
#import "NTPullScrollView.h"
#import "NTWebRequest.h"

@interface NTPullScrollView () <UIWebViewDelegate> {
    UIScrollView *_scrollView;
}
@property (nonatomic, strong) NTCustomAlertView *otherWindow;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *loadActivityView;
@property (nonatomic, strong) UIButton *btnShowOtherWindow;
@property (nonatomic, strong) UIButton *btnCheckIn;
@property (nonatomic, strong) NTAutoScrollView *autoScrollView;

@end

@implementation NTPullScrollView

@synthesize otherWindow;

@synthesize loadActivityView;
@synthesize webView;
@synthesize autoScrollView;
@synthesize btnShowOtherWindow;

- (void)dealloc
{
    webView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor grayColor];
        self.tableHeaderView = _scrollView;

        CGRect rect = self.bounds;
        rect.size.height /= 3;
        self.autoScrollView = [[NTAutoScrollView alloc] initWithFrame:rect];

        NSMutableArray *imageArray = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIImage *startupImage = [UIImage imageNamed:[NSString stringWithFormat:@"startup_%d", i + 1]];
            [imageArray addObject:startupImage];
        }
        [autoScrollView setScrollPages:imageArray];
        [_scrollView addSubview:autoScrollView];

        rect.origin.y += rect.size.height;
        self.webView = [[UIWebView alloc] initWithFrame:rect];
        webView.delegate = self;
        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_scrollView addSubview:webView];
        [webView loadRequest:urlRequest];

        self.loadActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadActivityView.center = _scrollView.center;
        [_scrollView addSubview:loadActivityView];

        rect.origin.y += rect.size.height;
        rect.size.height = 30;
        self.btnShowOtherWindow = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnShowOtherWindow setTitle:@"弹窗测试" forState:UIControlStateNormal];
        [btnShowOtherWindow addTarget:self action:@selector(showOtherWindow) forControlEvents:UIControlEventTouchUpInside];
        btnShowOtherWindow.frame = rect;
        btnShowOtherWindow.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:btnShowOtherWindow];

        rect.origin.y += rect.size.height + 5;
        rect.size.height = 30;
        self.btnCheckIn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCheckIn setTitle:@"值机接口" forState:UIControlStateNormal];
        [_btnCheckIn addTarget:self action:@selector(checkInTest) forControlEvents:UIControlEventTouchUpInside];
        _btnCheckIn.frame = rect;
        _btnCheckIn.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:_btnCheckIn];
    }
    return self;
}

- (void)checkInTest
{
    NTWebRequest *webRequest = [[NTWebRequest alloc] init];
    [webRequest doCheckInTest];
    //    NSLog(@"=================================");
    //    [webRequest doHttpCommonRequest];
}

- (void)showOtherWindow
{
    NSLog(@"%@", NSStringFromCGRect(self.bounds));
    self.otherWindow = [[NTCustomAlertView alloc] initWithFrame:self.bounds];
    [otherWindow makeKeyAndVisible];

    NSURL *viewUserURL = [NSURL URLWithString:@"train1063://queryair?from=%E6%AD%A6%E6%B1%89&to=%E6%9D%AD%E5%B7%9E&date=2015-07-11&lowprice=263"];
    BOOL canOpen = [[UIApplication sharedApplication] openURL:viewUserURL];
    NSLog(@"%d", canOpen);
    viewUserURL = [NSURL URLWithString:@"test://demo"];
    canOpen = [JLRoutes routeURL:viewUserURL];
    NSLog(@"%d", canOpen);
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [loadActivityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadActivityView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (void)addView:(UIView *)view
{
    [_scrollView addSubview:view];
}

@end
