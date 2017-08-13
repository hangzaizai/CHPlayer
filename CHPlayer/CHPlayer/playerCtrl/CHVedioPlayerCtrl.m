//
//  CHVedioPlayerCtrl.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/11.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHVedioPlayerCtrl.h"
#import "CHPlayerContainerView.h"
#import "CHPlayer.h"

@interface CHVedioPlayerCtrl ()<CHPlayerDelegate,CHPlayerContainerViewDelegate>

@property(nonatomic,strong)CHPlayer *player;
@property(nonatomic,strong)CHPlayerContainerView *containerView;

//正在拖动
@property(nonatomic,assign)BOOL isDraging;

//是否点击了播放按钮
@property(nonatomic,assign)BOOL expectedPlay;

@property(nonatomic,assign)BOOL isReadyToPlay;

@end


@implementation CHVedioPlayerCtrl

- (void)dealloc
{
    
    self.player = nil;
    self.containerView = nil;
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
- (instancetype)initWithURL:(NSURL *)aURL playInView:(UIView *)view
{
    self = [super init];
    if ( self ) {
        
        CHPlayer *player = [[CHPlayer alloc] initWithURL:aURL];
        self.player = player;
        player.delegate = self;
        [player prepareToPlay];
        
        CHPlayerContainerView *containerView = [CHPlayerContainerView newAutoLayoutView];
        self.containerView = containerView;
        containerView.delegate = self;
        
        [view addSubview:containerView];
        [containerView autoPinEdgesToSuperviewEdges];
        
    }
    return self;
}

- (void)play
{
    [self.containerView hiddlenCoverContentWithBool:YES];
    [self.player play];
}

- (void)pause
{
    [self.player pause];
}

#pragma mark -player
- (void)player:(CHPlayer *)player prepareToPlayWithDuration:(NSTimeInterval)duration WithError:(NSError *)error
{
    
    if ( !error ) {
        self.isReadyToPlay = YES;
        self.containerView.totalTime = duration;
        [self.containerView insertSubview:player.videoView atIndex:0];
        [player.videoView autoPinEdgesToSuperviewEdges];
        
        if ( self.expectedPlay ) {
            [self.containerView hideActivityView];
            [self.player play];
        }
    }
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(player:prepareToPlayWithDuration:WithError:)]) {
        [self.delegate vedioPlayerCtrl:self prepareToPlayWithDuration:duration withError:error];
    }
    

}

- (void)player:(CHPlayer *)player withCurrentTime:(NSTimeInterval)currentTime
{
    if ( !self.isDraging ) {
        self.containerView.currentTime = currentTime;
    }
}

- (void)player:(CHPlayer *)player withPreloadTime:(NSTimeInterval)preloadTime
{
    self.containerView.preloadTime = preloadTime;
}

- (void)player:(CHPlayer *)player isPlaying:(BOOL)isPlaying
{
    self.containerView.isPlaying = isPlaying;
}

- (void)player:(CHPlayer *)player complicatedWithError:(NSError *)error
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(player:complicatedWithError:)]) {
        [self.delegate vedioPlayerCtrl:self playComplicatedWithError:error];
    }
    self.containerView.currentTime = 0.0f;
    self.containerView.preloadTime = 0.0f;
}



#pragma mark -containerView

- (void)playerExpectedStartToPlayContainerView:(CHPlayerContainerView *)view
{
    
    if ( self.isReadyToPlay ) {
        [self.player play];
    }else{
        [self.containerView showStartPlayerActivity];
        self.expectedPlay = YES;
    }
}

- (void)playerContainerView:(CHPlayerContainerView *)view isDraging:(NSTimeInterval)time
{
    self.isDraging = YES;
}

- (void)playerContainerView:(CHPlayerContainerView *)view expectedPlay:(BOOL)play
{
    if ( play ) {
        [self.player play];
    }else{
        [self.player pause];
    }
}

- (void)playerContainerView:(CHPlayerContainerView *)view expectedToTime:(NSTimeInterval)time
{
    
    __weak CHVedioPlayerCtrl *weakSelf = self;
    [self.player seekToTime:time withComplicated:^(BOOL finish) {
        __strong CHVedioPlayerCtrl *strongSelf = weakSelf;
        if ( !finish ) {
            [strongSelf.player pause];
            return;
        }
        strongSelf.isDraging = NO;
        
        
    }];
}

@end
