//
//  CHPlayerContrainerView.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/11.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerContainerView.h"
#import "CHPlayerOperationView.h"

@interface CHPlayerContainerView ()<CHPlayerOperationViewDelegate>

@property(nonatomic,strong)CHPlayerOperationView *operationView;
//封面图片
@property(nonatomic,strong)UIImageView *backImgView;
@property(nonatomic,strong)UIButton *playCoverButton;

@property(nonatomic,strong)MBProgressHUD *hud;

@end


@implementation CHPlayerContainerView

- (void)dealloc
{
    
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self configView];
    }
    return self;
}

- (void)configView
{
    UIImageView *backImgView = [UIImageView newAutoLayoutView];
    backImgView.image = [UIImage imageNamed:@"public_video_default_pic"];
    self.backImgView = backImgView;
    [self addSubview:backImgView];
    [backImgView autoPinEdgesToSuperviewEdges];
    
    //播放按钮
    UIButton *button = [UIButton newAutoLayoutView];
    self.playCoverButton = button;
    [button setImage:[UIImage imageNamed:@"course_play"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button autoCenterInSuperview];
    [button autoSetDimensionsToSize:CGSizeMake(60, 60)];
    
    //操作区
    CHPlayerOperationView *operationView = [CHPlayerOperationView newAutoLayoutView];
    operationView.hidden = YES;
    operationView.delegate = self;
    self.operationView = operationView;
    [self addSubview:operationView];
    [operationView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [operationView autoSetDimension:ALDimensionHeight toSize:45];
}

#pragma mark -hiddlen
- (void)hiddlenCoverContentWithBool:(BOOL)hiddlen
{
    self.backImgView.hidden = hiddlen;
    self.playCoverButton.hidden = hiddlen;
}

- (void)showStartPlayerActivity
{
    self.playCoverButton.hidden = YES;
    if ( self.hud ) {
        [self.hud hideAnimated:YES];
        self.hud = nil;
    }
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.hud = hud;
}

- (void)hideActivityView
{
    [self hiddlenCoverContentWithBool:YES];
    self.operationView.hidden = NO;
    [self.hud hideAnimated:YES];
    self.hud = nil;
}

#pragma mark -target
- (void)playButtonPressed:(UIButton *)button
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerExpectedStartToPlayContainerView:)]) {
        [self.delegate playerExpectedStartToPlayContainerView:self];
    }
}

#pragma mark -setter
- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    self.operationView.isPlaying = isPlaying;
}

- (void)setPreloadTime:(NSTimeInterval)preloadTime
{
    _preloadTime = preloadTime;
    self.operationView.preloadTime = preloadTime;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    self.operationView.currentTime = currentTime;
}

- (void)setTotalTime:(NSTimeInterval)totalTime
{
    _totalTime = totalTime;
    self.operationView.totalTime = totalTime;
}

#pragma mark -OperationView delegate
- (void)playerOperationView:(CHPlayerOperationView *)view expectedPlaying:(BOOL)play
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerContainerView:expectedPlay:)]) {
        [self.delegate playerContainerView:self expectedPlay:play];
    }
}

- (void)playerOperationView:(CHPlayerOperationView *)view change:(NSTimeInterval)value
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerContainerView:isDraging:)]){
        [self.delegate playerContainerView:self isDraging:value];
    }

}

- (void)playerOperationView:(CHPlayerOperationView *)view seekToTime:(NSTimeInterval)time
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerContainerView:expectedToTime:)]){
        [self.delegate playerContainerView:self expectedToTime:time];
    }

}

@end
