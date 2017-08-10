//
//  CHPlayerView.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/10.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerView.h"

@implementation CHPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.layer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return self;
}

- (void)setPlayer:(AVPlayer *)player
{
    [((AVPlayerLayer *)self.layer) setPlayer:player];
}



@end
