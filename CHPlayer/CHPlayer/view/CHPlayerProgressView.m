//
//  CHPlayerProgressView.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/10.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerProgressView.h"
#import "CHPlayerSlider.h"


@interface CHPlayerProgressView ()

@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)CHPlayerSlider *slider;
@property(nonatomic,strong)NSMutableArray *constraints;

@end

@implementation CHPlayerProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        
        self.trackHeight = 2.0f;
        UIProgressView *progressView = [UIProgressView newAutoLayoutView];
        progressView.progress = 0.0f;
        self.progressView = progressView;
        [self addSubview:progressView];
        
        CHPlayerSlider *slider = [CHPlayerSlider newAutoLayoutView];
        slider.trackHeight = self.trackHeight;
        self.slider = slider;
        slider.minimumValue = 0.0f;
        slider.value = 0.0f;
        //添加拖动事件
        [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(sliderValueEndChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:slider];
        
        self.constraints = [NSMutableArray array];
        
    }
    return self;
}

- (void)updateConstraints
{
    if ( self.constraints.count > 0 ) {
        [self removeConstraints:self.constraints];
        [self.constraints removeAllObjects];
    }
    
    //progressView
    [self.constraints addObject:[self.progressView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
    [self.constraints addObject:[self.progressView autoPinEdgeToSuperviewEdge:ALEdgeRight]];
    [self.constraints addObject:[self.progressView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    [self.constraints addObject:[self.progressView autoSetDimension:ALDimensionHeight toSize:self.trackHeight]];
    
    //slider
    [self.constraints addObjectsFromArray:[self.slider autoPinEdgesToSuperviewEdges]];
    
    [super updateConstraints];
}

#pragma mark -target
//正在拖动
- (void)sliderValueChange:(UISlider *)slider
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(progressView:change:)]) {
        [self.delegate progressView:self change:slider.value];
    }
}

//结束拖动
- (void)sliderValueEndChanged:(UISlider *)slider
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(progressView:endChange:)] ) {
        [self.delegate progressView:self endChange:slider.value];
    }
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


- (void)setPreloadTime:(NSTimeInterval)preloadTime
{
    _preloadTime = preloadTime;
    self.progressView.progress = preloadTime/self.totalTime;
}

- (void)setTotalTime:(NSTimeInterval)totalTime
{
    _totalTime = totalTime;
    self.slider.maximumValue = totalTime;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    self.slider.value = currentTime;
}

@end
