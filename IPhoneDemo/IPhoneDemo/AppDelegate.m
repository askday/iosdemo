//
//  AppDelegate.m
//  IPhoneDemo
//
//  Created by wx on 15-6-10.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import "Test.h"
#import "NTWebRequest.h"
#import "AppDelegate.h"
#import "DemoDefine.h"
#import "NTFlashViewController.h"
#import "TabViewController.h"
//#import <NetEasePatch/LDPatchService.h>
#import <JLRoutes.h>

@interface AppDelegate () <UIGestureRecognizerDelegate> {
    NTFlashViewController *_flashViewController;
}
@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [JLRoutes routeURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    //j2objc代码调试
    NTTest *test = [[NTTest alloc] init];
    //普通调用以及包含oc代码引用的调用
    [test doSomeThing];
    //函数传参
    int result = [test getIntegerValueWithInt:10];
    NSLog(@"%d===", result);
    [test callOtherJava];
    //静态函数测试
    [NTTest staticFuncTest];

    //java反射测试
    [test doReflectionTest];

    [test doThreadTest];

    NSDictionary *appDictionary = [[NSBundle mainBundle] infoDictionary];
    float currentAppVersion = [[NSUserDefaults standardUserDefaults] floatForKey:@"currentAppVersion"];
    float appVersion = [[appDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    float appBuildVersion = [[appDictionary objectForKey:@"CFBundleVersion"] floatValue];
    float currentLaunchAppVersion = appVersion * 100 + appBuildVersion;

    [[ApplicationTools tools] showStatusBar:YES];

    //启动app主页
    TabViewController *vc = [[TabViewController alloc] init];
    window.rootViewController = vc;
    if (currentAppVersion != currentLaunchAppVersion) {
        //启动引导页
        _flashViewController = [[NTFlashViewController alloc] init];
        _flashViewController.view.frame = window.bounds;
        _flashViewController.delegate = (id<NTFlashViewDelegate>)self;
        [window addSubview:_flashViewController.view];
    }

    //AFNetworking 实践
    //    NTWebRequest* webRequest = [[NTWebRequest alloc] init];
    //    [webRequest doCheckInTest];

    [window makeKeyAndVisible];

    //wax框架代码引用测试
    //    [[LDPatchService sharedManager] startNetpatchWithAppcode:[appDictionary objectForKey:@"CFBundleShortVersionString"] andAppVersion:[appDictionary objectForKey:@"CFBundleVersion"]];

    UITapGestureRecognizer *tabbed = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    tabbed.delegate = self;
    [window addGestureRecognizer:tabbed];

    //jurlroute 实践
    [JLRoutes addRoute:@"/demo"
               handler:^BOOL(NSDictionary *parameters) {
                 NSString *userID = parameters[@"userID"];
                 NSLog(@"%@", userID);
                 return YES;
               }];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark flashViewDelegate
- (void)flashComplete
{
    NSDictionary *appDictionary = [[NSBundle mainBundle] infoDictionary];
    float appVersion = [[appDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    float appBuildVersion = [[appDictionary objectForKey:@"CFBundleVersion"] floatValue];
    float currentLaunchAppVersion = appVersion * 100 + appBuildVersion;

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:currentLaunchAppVersion] forKey:@"currentAppVersion"];

    [UIView animateWithDuration:0.8
        delay:0.0f
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
          _flashViewController.view.transform = CGAffineTransformMakeScale(3.0, 3.0);
          _flashViewController.view.alpha = 0.0f;
        }
        completion:^(BOOL finished) {
          [_flashViewController.view removeFromSuperview];
          _flashViewController = nil;
        }];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@", [touch.view class]);
    return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
}

@end
