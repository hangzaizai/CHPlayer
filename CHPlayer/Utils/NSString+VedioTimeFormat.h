//
//  NSString+VedioTimeFormat.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/11.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VedioTimeFormat)


/**
 根据时间返回固定格式的文本
 time = 3 返回 00:03
 @param time time
 @return text
 */
+ (NSString *)textForTime:(NSTimeInterval)time;

@end
