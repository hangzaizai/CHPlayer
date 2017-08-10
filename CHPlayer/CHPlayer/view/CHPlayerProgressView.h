//
//  CHPlayerProgressView.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/10.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 进度条(缓冲进度、当前播放进度)
 */
@interface CHPlayerProgressView : UIView

//进度条轨道的高，默认为2
@property(nonatomic,assign)CGFloat trackHeight;
//左边的颜色
@property(nonatomic,strong)UIColor *minColor;
//右边的颜色
@property(nonatomic,strong)UIColor *maxColor;
//滑块的图片
@property(nonatomic,strong)UIImage *thumbImage;
//缓冲颜色
@property(nonatomic,strong)UIColor *preloadColor;

//缓冲时间
@property(nonatomic,assign)NSTimeInterval preloadTime;
//当前时间
@property(nonatomic,assign)NSTimeInterval currentTime;
//总时间
@property(nonatomic,assign)NSTimeInterval totalTime;

@end
