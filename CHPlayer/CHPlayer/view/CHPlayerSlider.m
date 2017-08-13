//
//  CHPlayerSlider.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/10.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerSlider.h"

@implementation CHPlayerSlider

- (void)dealloc
{
    
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

//自定义滑块的区域
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x,(bounds.size.height-self.trackHeight)/2, bounds.size.width, self.trackHeight);
}

@end
