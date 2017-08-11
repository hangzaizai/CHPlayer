//
//  CHVedioPlayViewController.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/11.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHVedioPlayViewController.h"
#import "CHVedioPlayerCtrl.h"

@interface CHVedioPlayViewController ()<CHVedioPlayerCtrlDelegate>

@property(nonatomic,strong)CHVedioPlayerCtrl *playCtrl;

@end

@implementation CHVedioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *contentView = [UIView newAutoLayoutView];
    [self.view addSubview:contentView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [contentView autoCenterInSuperview];
    [contentView autoSetDimensionsToSize:CGSizeMake(width, width*9/16)];
    
    CHVedioPlayerCtrl *ctrl = [[CHVedioPlayerCtrl alloc] initWithURL:self.vedioURL playInView:contentView];
    self.playCtrl = ctrl;
    ctrl.delegate = self;
}

- (void)vedioPlayerCtrl:(CHVedioPlayerCtrl *)playerCtrl prepareToPlayWithDuration:(NSTimeInterval)duration withError:(NSError *)error
{
    if ( error ) {
        NSLog(@"准备播放失败%@",error);
        return;
    }
    
    [playerCtrl play];
    
    NSLog(@"准备播放");
    
}

- (void)vedioPlayerCtrl:(CHVedioPlayerCtrl *)playerCtrl playComplicatedWithError:(NSError *)error
{
    if ( error ) {
        NSLog(@"播放失败%@",error);
        return;
    }
    
    NSLog(@"播放完成");
}

@end
