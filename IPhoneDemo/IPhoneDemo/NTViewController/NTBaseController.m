//
//  NTBaseController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/16.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "NTBaseController.h"
#import "DemoDefine.h"

@interface NTBaseController ()

@end

@implementation NTBaseController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.navigationController) {
        UIImage* naviBarImage = [[ApplicationTools tools] getNavibarImage];
        [self.navigationController.navigationBar setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.title = self.title;
        NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
        [self.navigationController.navigationBar setTitleTextAttributes:attributes];
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
        // ios7以后的版本，因为设计风格的原因，与ios6及以前的版本相差大概10pt
        if ([UINavigationController instancesRespondToSelector:@selector(interactivePopGestureRecognizer)]) { // ios 7+
            spacer.width = -5;
        } else { // ios6以下
            spacer.width = 5;
        }
        UIImage* backImage = [UIImage imageNamed:@"navi_back_button"];
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.exclusiveTouch = YES;
        [backButton setImage:backImage forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0,backImage.size.width, backImage.size.height);
        [backButton addTarget:self action:@selector(baseBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItems = @[spacer,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)baseBackButtonPressed:(id)sender {
    if (self.navigationController&&self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
