//
//  CHPlayerContrainerView.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/11.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHPlayerContainerViewDelegate;

/**
 播放器容器视图(操作区,视频,菊花)
 */
@interface CHPlayerContainerView : UIView

//正在播放
@property(nonatomic,assign)BOOL isPlaying;

@property(nonatomic,weak)id<CHPlayerContainerViewDelegate> delegate;

//缓冲时间
@property(nonatomic,assign)NSTimeInterval preloadTime;
//当前时间
@property(nonatomic,assign)NSTimeInterval currentTime;
//总时间
@property(nonatomic,assign)NSTimeInterval totalTime;

- (void)hiddlenCoverContentWithBool:(BOOL)hiddlen;

//显示加载菊花
- (void)showStartPlayerActivity;

- (void)hideActivityView;

@end


@protocol CHPlayerContainerViewDelegate <NSObject>


- (void)playerExpectedStartToPlayContainerView:(CHPlayerContainerView *)view;

/**
 视图是否期望播放
 @param view contatinerView
 @param play YES 表示期望播放,NO表示期望暂停
 */
- (void)playerContainerView:(CHPlayerContainerView *)view expectedPlay:(BOOL)play;


/**
 正在拖动

 @param view containerView
 @param time 拖动的时间
 */
- (void)playerContainerView:(CHPlayerContainerView *)view isDraging:(NSTimeInterval)time;


/**
 期望播放的时间

 @param view containerView
 @param time  时间
 */
- (void)playerContainerView:(CHPlayerContainerView *)view expectedToTime:(NSTimeInterval)time;

@end
