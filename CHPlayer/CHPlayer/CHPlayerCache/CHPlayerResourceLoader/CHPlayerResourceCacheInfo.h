//
//  CHPlayerResourceCacheInfo.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/14.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  CHPlayerResourceCacheInfoDelegate;

/**
 播放器缓存信息
 */
@interface CHPlayerResourceCacheInfo : NSObject

//fileName带后缀的文件名
- (instancetype)initWithFileName:(NSString *)fileName;

//文件大小
@property(nonatomic,assign)long long fileSize;
@property(nonatomic,readonly,strong)NSArray<NSValue *> *ranges;
@property(nonatomic,readonly,copy)NSString *fileName;
@property(nonatomic,weak)id <CHPlayerResourceCacheInfoDelegate> delegate;

- (void)addCacheRange:(NSRange)range;
- (NSRange)findCachedRangeWithRange:(NSRange)range;

@end

@protocol CHPlayerResourceCacheInfoDelegate <NSObject>

//在操作缓存文件的时候发生了任何会执行该回调
- (void)playerResourceCacheInfo:(CHPlayerResourceCacheInfo *)cacheInfo withError:(NSError *)error;

@end
