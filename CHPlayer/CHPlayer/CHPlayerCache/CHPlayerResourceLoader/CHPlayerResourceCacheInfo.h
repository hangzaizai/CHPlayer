//
//  CHPlayerResourceCacheInfo.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/14.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 播放器缓存信息
 */
@interface CHPlayerResourceCacheInfo : NSObject

//文件大小
@property(nonatomic,assign)long long fileSize;
@property(nonatomic,readonly,strong)NSArray<NSValue *> *ranges;

- (void)addCacheRange:(NSRange)range;

- (NSRange)findCachedRangeWithRange:(NSRange)range;

@end
