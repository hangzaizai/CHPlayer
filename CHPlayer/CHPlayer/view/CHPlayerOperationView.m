//
//  CHPlayerOperationView.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/10.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerOperationView.h"
#import "CHPlayerProgressView.h"

@interface CHPlayerOperationView ()<CHPlayerProgressViewDelegate>

@property(nonatomic,strong)CHPlayerProgressView *progressView;
@property(nonatomic,strong)UIImageView *playImageView;
@property(nonatomic,strong)UILabel *currentTimeLabel;
@property(nonatomic,strong)UILabel *totalTimeLabel;


@end

@implementation CHPlayerOperationView

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
    //播放按钮触控区
    UIButton *playButton = [UIButton newAutoLayoutView];
    [playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    [playButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
    [playButton autoSetDimension:ALDimensionWidth toSize:45];
    
    //播放按钮
    UIImageView *playImageView = [UIImageView newAutoLayoutView];
    self.playImageView = playImageView;
    playImageView.image = [UIImage imageNamed:@"public_video_play"];
    [playButton addSubview:playImageView];
    [playImageView autoCenterInSuperview];
    [playImageView autoSetDimensionsToSize:CGSizeMake(18, 18)];
    
    //当前播放时间
    UILabel *currentTimeLabel = [UILabel newAutoLayoutView];
    self.currentTimeLabel = currentTimeLabel;
    currentTimeLabel.font = [UIFont systemFontOfSize:12];
    currentTimeLabel.textColor = [UIColor whiteColor];
    currentTimeLabel.text = @"00:00";
    currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:currentTimeLabel];
    
    [currentTimeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [currentTimeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:playButton];
    [currentTimeLabel autoSetDimension:ALDimensionWidth toSize:45];
    
    //总时间
    UILabel *totalTimeLabel = [UILabel newAutoLayoutView];
    self.totalTimeLabel = totalTimeLabel;
    totalTimeLabel.font = [UIFont systemFontOfSize:12];
    totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.text = @"00:00";
    totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalTimeLabel];
    [totalTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [totalTimeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [totalTimeLabel autoSetDimension:ALDimensionWidth toSize:45];
    
    //进度条
    CHPlayerProgressView *progressView = [CHPlayerProgressView newAutoLayoutView];
    self.progressView = progressView;
    progressView.trackHeight = 2;
    progressView.minColor = [UIColor whiteColor];
    progressView.maxColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    progressView.thumbImage = [UIImage imageNamed:@"course_audio_button"];
    progressView.preloadColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    progressView.delegate = self;
    [self addSubview:progressView];
    [progressView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [progressView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [progressView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:currentTimeLabel];
    [progressView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:totalTimeLabel];
}

#pragma mark target
- (void)playButtonPressed:(UIButton *)button
{
    self.isPlaying = !self.isPlaying;
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerOperationView:expectedPlaying:)]) {
        [self.delegate playerOperationView:self expectedPlaying:self.isPlaying];
    }
}

#pragma mark setter
- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    self.playImageView.image = isPlaying ? [UIImage imageNamed:@"public_video_play"] : [UIImage imageNamed:@"public_vedio_pause"];
}

- (void)setPreloadTime:(NSTimeInterval)preloadTime
{
    _preloadTime = preloadTime;
    self.progressView.preloadTime = preloadTime;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    self.progressView.currentTime = currentTime;
}

- (void)setTotalTime:(NSTimeInterval)totalTime
{
    _totalTime = totalTime;
    self.progressView.totalTime = totalTime;
}

#pragma mark -progressView Delegate
- (void)progressView:(CHPlayerProgressView *)progressView change:(NSTimeInterval)value
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerOperationView:change:)] ) {
        [self.delegate playerOperationView:self change:value];
    }
}

- (void)progressView:(CHPlayerProgressView *)progressView endChange:(NSTimeInterval)value
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerOperationView:seekToTime:)]) {
        [self.delegate playerOperationView:self seekToTime:value];
    }
}



@end
