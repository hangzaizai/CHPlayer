//
//  CHPlayerOperationView.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/10.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHPlayerOperationViewDelegate;

/**
 播放器操作视图，播放按钮、播放进度条，播放器暂时不支持全屏后续完善
 */
@interface CHPlayerOperationView : UIView

//缓冲时间
@property(nonatomic,assign)NSTimeInterval preloadTime;
//当前时间
@property(nonatomic,assign)NSTimeInterval currentTime;
//总时间
@property(nonatomic,assign)NSTimeInterval totalTime;


@property(nonatomic,assign)BOOL isPlaying;
@property(nonatomic,weak)id<CHPlayerOperationViewDelegate> delegate;

@end

@protocol CHPlayerOperationViewDelegate <NSObject>


/**
 操作视图，是否期望播放

 @param view operationView
 @param play YES 表示期望播放, NO表示暂停
 */
- (void)playerOperationView:(CHPlayerOperationView *)view expectedPlaying:(BOOL)play;


/**
 正在拖动，value表示拖动的值
 */
- (void)playerOperationView:(CHPlayerOperationView *)view change:(NSTimeInterval)value;


/**
 希望从哪里开始播放
 */
- (void)playerOperationView:(CHPlayerOperationView *)view seekToTime:(NSTimeInterval)time;

@end
