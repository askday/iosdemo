//
//  TabViewController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/15.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import "IndexViewController.h"
#import "OrderViewController.h"
#import "UserViewController.h"
#import "TabViewController.h"

@interface TabViewController ()
{
    UINavigationController* indexNaviController;
    UINavigationController* orderNaviController;
    UINavigationController* userNaviController;
}
@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    IndexViewController* indexViewController = [[IndexViewController alloc] init];
    indexNaviController = [[UINavigationController alloc] initWithRootViewController:indexViewController];
    indexNaviController.title = indexViewController.title;
    
    OrderViewController* orderViewController = [[OrderViewController alloc] init];
    orderNaviController = [[UINavigationController alloc] initWithRootViewController:orderViewController];
    orderNaviController.title = orderViewController.title;
    
    UserViewController* userViewController = [[UserViewController alloc] init];
    userNaviController = [[UINavigationController alloc] initWithRootViewController:userViewController];
    userNaviController.title = userViewController.title;
    
    self.viewControllers = @[indexNaviController,orderNaviController,userNaviController];
    self.delegate = self;
    self.selectedIndex = 0;
    
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%@",viewController.title);
}
@end
