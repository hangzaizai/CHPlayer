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

@end


@implementation CHPlayerContainerView

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
    [button setImage:[UIImage imageNamed:@"course_play"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button autoCenterInSuperview];
    [button autoSetDimensionsToSize:CGSizeMake(60, 60)];
    
    //操作区
    CHPlayerOperationView *operationView = [CHPlayerOperationView newAutoLayoutView];
    operationView.delegate = self;
    self.operationView = operationView;
    [self addSubview:operationView];
    [operationView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [operationView autoSetDimension:ALDimensionHeight toSize:45];
}

#pragma mark -target
- (void)playButtonPressed:(UIButton *)button
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerContainerView:expectedPlay:)]) {
        [self.delegate playerContainerView:self expectedPlay:YES];
    }
}

#pragma mark -setter
- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
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
