//
//  ViewController.m
//  IPhoneDemo
//
//  Created by wx on 15-6-10.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "ViewController.h"
#import "CollectionTest.h"

#import "NaviViewController.h"

@interface ViewController () {
    UIImageView *_imgContentView;
    UIButton *_btnTest;
}
@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        self.view.backgroundColor = [UIColor whiteColor];
        [self isKindOfClass:[NSString class]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadUI];
}

- (void)loadUI
{
    _imgContentView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSURL *imageUrl = [NSURL URLWithString:@"https://www.google.com.hk/images/srpr/logo11w.png"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    [_imgContentView setImage:[UIImage imageWithData:imageData]];
    _imgContentView.autoresizesSubviews = YES;
    _imgContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_imgContentView];

    _btnTest = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTest.frame = CGRectMake(10, 80, 80, 40);
    _btnTest.backgroundColor = [UIColor redColor];
    [_btnTest setUserInteractionEnabled:YES];
    [_btnTest addTarget:self action:@selector(btnTestClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnTest];

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"下一个" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)rightBarClick
{
    NaviViewController *naviVc = [[NaviViewController alloc] init];
    naviVc.title = @"naviViewController";
    [self.navigationController pushViewController:naviVc animated:YES];
}

- (void)btnTestClick
{
    NSLog(@"btnTestClick");
    CollectionTest *test = [[CollectionTest alloc] init];
    [test doBlockTest:^(int num) {
      NSLog(@"%d", num);
    }];

    NaviViewController *naviVc = [[NaviViewController alloc] init];

    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:naviVc animated:YES];

    CGRect rect = self.view.bounds;
    rect.size.height /= 2;
    naviVc.view.bounds = rect;
    naviVc.title = @"naviViewController";
}

@end
