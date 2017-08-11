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

@end


@implementation CHVedioPlayerCtrl

- (instancetype)initWithURL:(NSURL *)aURL playInView:(UIView *)view
{
    self = [super init];
    if ( self ) {
        
        CHPlayer *player = [[CHPlayer alloc] initWithURL:aURL];
        self.player = player;
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
        self.containerView.totalTime = duration;
        [self.containerView insertSubview:player.videoView atIndex:0];
        [player.videoView autoPinEdgesToSuperviewEdges];
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
    self.isDraging = NO;
    __weak CHVedioPlayerCtrl *weakSelf = self;
    [self.player seekToTime:time withComplicated:^(BOOL finish) {
        if ( !finish ) {
            __strong CHVedioPlayerCtrl *strongSelf = weakSelf;
            [strongSelf.player pause];
        }
    }];
}

@end
