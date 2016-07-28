//
//  OrderViewController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/16.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "CSAnimationView.h"
#import "DataKVO.h"
#import "DemoDefine.h"
#import "MMPlaceHolder.h"
#import "Masonry.h"
#import "OrderViewController.h"


@interface ThirdController : UIViewController
@property (nonatomic, strong) UIButton *btnTest;
@end

@implementation ThirdController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];

    self.btnTest = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnTest.frame = CGRectMake(100, 100, 100, 100);
    [_btnTest setTitle:@"test" forState:UIControlStateNormal];
    [_btnTest addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnTest];
}

- (void)btnClick
{
    [self dismissViewControllerAnimated:self completion:nil];
}

//UIPopoverController 是它的 contentViewController，即 UIPopoverPresentationController 的默认的 delegate
//
// 这里有一个 bug：当双击 diming 视图时，presentation 视图控制器将调用两次
// dismissViewControllerAnimated:completion:，并 dismiss 掉它的父控制器.
//
// 通过实现这个 delegate 可以让代码运行另一条正确地检查了是否正在 dismiss 的代码路径
// rdar://problem/19067761
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    return YES;
}
@end

@interface SecViewController : UIViewController
@property (nonatomic, strong) UIButton *btnTest;
@end

@implementation SecViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.btnTest = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnTest.frame = CGRectMake(100, 100, 100, 100);
    [_btnTest setTitle:@"test" forState:UIControlStateNormal];
    [_btnTest addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnTest];
}

- (void)btnClick
{
    ThirdController *controller = [[ThirdController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}
@end


@interface OrderViewController () <UIAlertViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UITextField *
    txtInput;
@property (nonatomic, strong) NSArray *btnArrays;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) CSAnimationView *animationView;
@property (nonatomic, strong) DataKVO *kvo;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *lblSize;
@property (nonatomic, strong) UILabel *lblContentInset;
@property (nonatomic, strong) UILabel *lblContentOffset;

@end

@implementation OrderViewController

- (void)dealloc
{
    [_kvo removeObserver:self forKeyPath:@"stockName"];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"订单";
        self.hidesBottomBarWhenPushed = NO;

        [self.tabBarItem setTitle:nil];
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_order"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_order_s"]];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtInput = [[UITextField alloc] init];
    _txtInput.backgroundColor = [UIColor redColor];
    _txtInput.delegate = self;
    [_txtInput addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_txtInput];
    [_txtInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-140);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];

    self.kvo = [[DataKVO alloc] init];
    [_kvo setValue:@"netease" forKey:@"stockName"];
    [_kvo addObserver:self forKeyPath:@"stockName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

    self.btnArrays = @[ @[ @0, @"test", @"btnTestClick" ],
                        @[ @1, @"跳转到火车票", @"btnToTrainClick" ],
                        @[ @2, @"跳转到众筹", @"btnToCrowFundingClick" ],
                        @[ @3, @"presentTest", @"btnPresentTestClick" ],
                        @[ @4, @"KVO Test", @"btnKVOTestClick" ],
                        @[ @5, @"模拟推送", @"btnNotifyTestClick" ],
                        @[ @6, @"present", @"btnPresentTestClick1" ],
                        @[ @7, @"scrollView", @"btnScrollerViewText" ] ];

    UIView *preView = _txtInput;
    for (int i = 0; i < _btnArrays.count; i++) {
        NSArray *subArray = _btnArrays[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:subArray[1] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:0.5465 green:0.5328 blue:1.0 alpha:1.0]];
        [btn addTarget:self action:NSSelectorFromString(subArray[2]) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 40));
            make.centerX.equalTo(preView.mas_centerX);
            make.top.equalTo(preView.mas_bottom).offset(10);
        }];
        preView = btn;
    }

    [self.view showPlaceHolder];

    self.animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];

    self.animationView.backgroundColor = [UIColor redColor];

    self.animationView.duration = 0.5;
    self.animationView.delay = 0;
    self.animationView.type = CSAnimationTypeBounceDown;

    [self.view addSubview:self.animationView];

    // Add your subviews into animationView
    // [animationView addSubview:<#(UIView *)#>]

    // Kick start the animation immediately
    [self.animationView startCanvasAnimation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"stockName"]) {
        _txtInput.text = [_kvo valueForKey:@"stockName"];
    }
}

- (void)btnKVOTestClick
{
    [_kvo setValue:[NSString stringWithFormat:@"crowd found %d", arc4random()] forKey:@"stockName"];
}

- (void)btnPresentTestClick
{
    UIViewController *vc = [[UIViewController alloc] init];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controllerClick:)];
    [vc.view addGestureRecognizer:tapGesture];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)controllerClick:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = tap.view;
    UIResponder *responser = [view nextResponder];
    UIViewController *vc = (UIViewController *)responser;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)popViewPorTimer
{
    UIViewController *controller = [[UIViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)btnTestClick
{
    [self.animationView startCanvasAnimation];
    //    [_txtInput resignFirstResponder];
    //    //    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 8.0) {
    //    //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    //    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
    //    //                                                               style:UIAlertActionStyleDefault
    //    //                                                             handler:^(UIAlertAction *action) {
    //    //                                                               UIViewController *controller = [[UIViewController alloc] init];
    //    //                                                               [self.navigationController pushViewController:controller animated:YES];
    //    //                                                             }];
    //    //
    //    //        [alert addAction:cancelAction];
    //    //        [self presentViewController:alert animated:YES completion:nil];
    //    //    }
    //    //    else {
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"cacel" otherButtonTitles:nil, nil];
    //    [alert becomeFirstResponder];
    //    [alert show];
    //    }
}

- (void)btnToTrainClick
{
    NSURL *url = [NSURL URLWithString:@"train163://mainOrder"];
    //    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //    [connect start];

    if ([[UIApplication sharedApplication]
            canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)btnToCrowFundingClick
{
    //    NSURL *url = [NSURL URLWithString:@"cf163://userAccount"];
    //    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //    [connect start];
    NSString *strUrl = @"cf163://mainCreditor/creditorDetail?productId=20151028144506PD252561";
    strUrl = @"cf163://mainUser/userAccount?isHeadNeedRefresh=1";
    strUrl = @"cf163://mainUser/userAssets";
    strUrl = @"cf163://mainUser/aboutUs";
    strUrl = @"cf163://creditorDetail?rate=8.0&namePrefix=银亿1号0621";
    NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication]
            canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)btnNotifyTestClick
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];

        //小于8.0
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound];
    }

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = @"推送内容";
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"cf163://mainCreditor/creditorDetail?productId=20151028144506PD252561" forKey:@"url"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}

- (void)btnPresentTestClick1
{
    SecViewController *controller = [[SecViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)btnScrollerViewText
{
    UIViewController *controller = [UIViewController new];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    //    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    self.scrollView.backgroundColor = [UIColor yellowColor];
    [controller.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(controller.view);
        make.width.equalTo(controller.view).dividedBy(2);
        make.height.equalTo(@(100));
    }];

    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    text.backgroundColor = [UIColor greenColor];
    text.text = @"123";
//    [self.scrollView addSubview:text];
    self.lblSize = [[UILabel alloc] init];

    self.lblSize.frame = CGRectMake(0, 80, SCREEN_WIDTH, 30);
    [controller.view addSubview:self.lblSize];


    self.lblContentInset = [[UILabel alloc] init];

    self.lblContentInset.frame = CGRectMake(0, 115, SCREEN_WIDTH, 30);
    [controller.view addSubview:self.lblContentInset];

    self.lblContentOffset = [[UILabel alloc] init];

    self.lblContentOffset.frame = CGRectMake(0, 160, SCREEN_WIDTH, 30);
    [controller.view addSubview:self.lblContentOffset];

    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView) {
        [self.lblSize setText:[NSString stringWithFormat:@"contentSize:%@", NSStringFromCGSize(self.scrollView.contentSize)]];
        [self.lblContentInset setText:[NSString stringWithFormat:@"contentInset:%@", NSStringFromUIEdgeInsets(self.scrollView.contentInset)]];
        [self.lblContentOffset setText:[NSString stringWithFormat:@"contentOffset:%@", NSStringFromCGPoint(self.scrollView.contentOffset)]];
    }
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"getdata===");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finish load data");
}

#pragma mark UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"%s", __func__);
}
- (void)didPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"%s", __func__);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(popViewPorTimer) withObject:nil afterDelay:0.001];
    //    NSTimer *testTimer = [NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(popViewPorTimer) userInfo:nil repeats:NO];
}
#pragma mark UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%s", __func__);
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSLog(@"%s", __func__);
}

- (void)textFieldDidChanged:(UITextField *)sender
{
    [self btnTestClick];
}
@end
