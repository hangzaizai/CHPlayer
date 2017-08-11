//
//  CHPlayer.h
//  CHPlayer
//
//  Created by 陈行 on 17/8/9.
//  Copyright © 2017年 陈行. All rights reserved.
//
#import <Foundation/Foundation.h>
@import UIKit;

@protocol CHPlayerDelegate;

@interface CHPlayer : NSObject


@property(nonatomic,weak)id<CHPlayerDelegate> delegate;
/**
 视频播放视图，当readToPlay之后，才会生成,否者为空
 */
@property(nonatomic,readonly)UIView *videoView;

@property(nonatomic,readonly)NSURL *currentURL;

- (instancetype)initWithURL:(NSURL *)aURL;

/**
readyToPlay
 */
- (void)prepareToPlay;


/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;


/**
 拖动到指定时间

 @param aTime des Time
 @param complicated block
 */
- (void)seekToTime:(NSTimeInterval)aTime withComplicated:(void(^)(BOOL finish) )complicated;

@end


@protocol CHPlayerDelegate <NSObject>



/**
 准备播放完成回调,error为nil,表示没有错误，准备播放成功，时长信息存在，如果
 error不为空，准备播放失败，时长信息不存在
 @param player 当前player
 @param duration 时长
 @param error 错误
 */
- (void)player:(CHPlayer *)player prepareToPlayWithDuration:(NSTimeInterval)duration WithError:(NSError *)error;


/**
 当前播放时间
 @param player 当前player
 @param currentTime 当前时间，单位为秒
 */
- (void)player:(CHPlayer *)player withCurrentTime:(NSTimeInterval)currentTime;


/**
 获取到缓冲时间
 @param player 当前player
 @param preloadTime 缓冲时间,单位为秒
 */
- (void)player:(CHPlayer *)player withPreloadTime:(NSTimeInterval)preloadTime;

//是否正在播放
- (void)player:(CHPlayer *)player isPlaying:(BOOL)isPlaying;


/**
 在处理player的过程中(在播放过程中，或者是加载基本数据过程中,比如获取时长、播放状态信息)发生了任何错误或者是顺利完成播放，都会执行该回调.
 @param player 当前的player
 @param error error为空表示没有错误，
 */
- (void)player:(CHPlayer *)player complicatedWithError:(NSError *)error;



@end
