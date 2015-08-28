//
//  UserViewController.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/6/16.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import <UIToast.h>
#import "UserViewController.h"
#import "DemoDefine.h"
#import "NTAlbumController.h"
#import "NTMapViewController.h"

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *myTableView;
    NSArray *tableSource;
}
@end

@implementation UserViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"我的";
        self.hidesBottomBarWhenPushed = NO;

        [self.tabBarItem setTitle:nil];
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_me"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_me_s"]];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableSource = [NSArray arrayWithObjects:@[ @"纪念册" ], @[ @"地图" ], @[ @"其他" ], nil];

    myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
}

#pragma mark UITableViewDelegate·
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            NTAlbumController *albumController = [[NTAlbumController alloc] init];

            //    [self presentViewController:albumController animated:YES completion:^{
            //
            //    }];
            [self.navigationController pushViewController:albumController animated:YES];
        } break;
        case 1: {
            NTMapViewController *mapViewController = [[NTMapViewController alloc] init];

            [self.navigationController pushViewController:mapViewController animated:YES];
        } break;
        case 2: {
            //            UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
            //            view.backgroundColor = [UIColor redColor];
            //            view.alpha = 0.5;
            //            UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
            //            [currentWindow addSubview:view];
            //            [self.view makeToast:@"test...." duration:3 position:[NSValue valueWithCGPoint:CGPointMake(200, 300)]];
            [UIToast makeText:@"test..."];
        } break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    sectionView.backgroundColor = [UIColor colorWithRed:(0xF0F0F0 >> 16) / 255.0f green:(0xff & (0xF0F0F0 >> 8)) / 255.0f blue:(0xff & 0xF0F0F0) / 255.0f alpha:1.0];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSArray *array = [tableSource objectAtIndex:indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setText:[array objectAtIndex:indexPath.row]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

@end
