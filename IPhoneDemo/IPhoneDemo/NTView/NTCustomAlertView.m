//
//  NTCustomAlertView.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/7/3.
//  Copyright (c) 2015年 wx. All rights reserved.
//
#import "DemoDefine.h"
#import "NTCustomAlertView.h"

@interface NTCustomAlertView ()
@property (nonatomic, strong) UIView *backgroundView; //默认是一个黑色半透明UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NTCustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    frame = [UIApplication sharedApplication].keyWindow.frame;
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal + 1.0;

        UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        content.backgroundColor = [UIColor whiteColor];

        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [content addSubview:self.headerView];

        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom]; // [UIFactory buttonWithTitle:@"取消" target:self selector:@selector(onCancel:)];
        [cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.frame = CGRectMake(10, 0, 60, 40);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.headerView addSubview:cancelButton];

        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom]; //[UIFactory buttonWithTitle:@"确定" target:self selector:@selector(onConfirm:)];
        confirmButton.backgroundColor = [UIColor greenColor];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.frame = CGRectMake(250, 0, 60, 40);
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.headerView addSubview:confirmButton];

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0)];
        _tableView.backgroundColor = [UIColor clearColor];
        //        _tableView.delegate = self;
        //        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _tableView.top = self.headerView.height;
        //        _tableView.height = self.content.height - self.headerView.height;
        //        _tableView.tableFooterView = [self tableViewFooterView];
        _tableView.allowsSelection = NO;
        _tableView.scrollEnabled = NO;
        [content addSubview:_tableView];

        self.contentView = content;

        self.backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]; // 加深背景黑色
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.backgroundView.bounds;
        //        gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
        gradientLayer.colors = @[ (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor, (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor ];
        gradientLayer.locations = @[ @0.0f, @0.4f ];
        self.backgroundView.layer.mask = gradientLayer;

        [self insertSubview:_backgroundView atIndex:0];
    }
    return self;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    }
    return _backgroundView;
}

- (void)setContentView:(UIView *)contentView
{
    [self.contentView removeFromSuperview];

    _contentView = contentView;
    [self addSubview:contentView];
}

- (void)onCancel
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fillMode = kCAFillModeBoth;
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.duration = 0.4;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.duration = 0.4;

    CAAnimationGroup *animationGroun = [CAAnimationGroup animation];
    animationGroun.animations = @[ animation, opacityAnimation ];
    [animationGroun setValue:@"content" forKey:@"id"];
    animationGroun.delegate = self;

    self.contentView.layer.opacity = 0.0;
    [self.contentView.layer addAnimation:animationGroun forKey:@"dismiss"];

    CABasicAnimation *backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    backgroundAnimation.fromValue = (id)[NSNumber numberWithFloat:1.0];
    ;
    backgroundAnimation.toValue = (id)[NSNumber numberWithFloat:0.0];
    backgroundAnimation.fillMode = kCAFillModeBoth;
    backgroundAnimation.duration = 0.2;
    backgroundAnimation.delegate = self;
    [backgroundAnimation setValue:@"background" forKey:@"id"];

    self.backgroundView.layer.opacity = 0.0;
    [self.backgroundView.layer addAnimation:backgroundAnimation forKey:@"dismiss"];

    self.hidden = YES;
}

- (void)onConfirm
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
