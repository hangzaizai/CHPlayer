//
//  CHPlayerProgressView.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/10.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerProgressView.h"
#import "CHPlayerSlider.h"
#import "PureLayout.h"
#import "ALView+PureLayout.h"

@interface CHPlayerProgressView ()

@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)CHPlayerSlider *slider;

@end

@implementation CHPlayerProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.trackHeight = 2.0f;
        UIProgressView *progressView = [UIProgressView newAutoLayoutView];
        self.progressView = progressView;
        [self addSubview:progressView];
        
        CHPlayerSlider *slider = [CHPlayerSlider newAutoLayoutView];
        slider.trackHeight = self.trackHeight;
        self.slider = slider;
        [self addSubview:slider];
        
    }
    return self;
}

#pragma mark -setter
- (void)setMaxColor:(UIColor *)maxColor
{
    _maxColor = maxColor;
    self.progressView.trackTintColor = maxColor;
}

- (void)setMinColor:(UIColor *)minColor
{
    _minColor = minColor;
    self.slider.minimumTrackTintColor = minColor;
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    _thumbImage = thumbImage;
    [self.slider setThumbImage:thumbImage forState:UIControlStateNormal];
}

- (void)setPreloadColor:(UIColor *)preloadColor
{
    _preloadColor = preloadColor;
    self.progressView.progressTintColor = preloadColor;
}

@end
