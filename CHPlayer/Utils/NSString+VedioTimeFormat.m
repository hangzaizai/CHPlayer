//
//  NSString+VedioTimeFormat.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/11.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "NSString+VedioTimeFormat.h"

@implementation NSString (VedioTimeFormat)

+ (NSString *)textForTime:(NSTimeInterval)time
{
    NSUInteger totalTime;
    NSUInteger minitue;
    NSUInteger second;
    
    totalTime = time;
    minitue = totalTime/60;
    second = totalTime%60;
    NSString *totalStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)minitue,(long)second];
    return totalStr;
}

@end
