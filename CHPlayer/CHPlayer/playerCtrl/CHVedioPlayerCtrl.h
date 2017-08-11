//
//  CHVedioPlayerCtrl.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/11.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CHVedioPlayerCtrlDelegate;

@interface CHVedioPlayerCtrl : NSObject

- (instancetype)initWithURL:(NSURL *)aURL playInView:(UIView *)view;

@property(nonatomic,weak)id <CHVedioPlayerCtrlDelegate> delegate;

- (void)play;
- (void)pause;

@end

@protocol CHVedioPlayerCtrlDelegate <NSObject>

/**
 准备播放完成,有错误，表示准备播放失败，没错误，会返回时长信息
 */
- (void)vedioPlayerCtrl:(CHVedioPlayerCtrl *)playerCtrl prepareToPlayWithDuration:(NSTimeInterval)duration withError:(NSError *)error;

/**
播放完成，error 为空 表示顺利播放完成
 */
- (void)vedioPlayerCtrl:(CHVedioPlayerCtrl *)playerCtrl playComplicatedWithError:(NSError *)error;

@end

