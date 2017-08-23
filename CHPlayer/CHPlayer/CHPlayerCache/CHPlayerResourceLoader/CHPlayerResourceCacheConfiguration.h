//
//  CHPlayerResourceCacheConfiguration.h
//  CHPlayer
//
//  Created by 陈行 on 17/8/16.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 缓存的配置类,可以配置视频文件缓存目录
 */
@interface CHPlayerResourceCacheConfiguration : NSObject

+ (instancetype)shareInstance;


/**
 将一个文件拷贝到另外一个文件

 @param sourceURL 源文件的完整URL
 @param fileName   目的文件的文件名
 @param error      有错误则表示拷贝失败
 */
- (void)copyFileWithResource:(NSURL *)sourceURL withDesName:(NSString *)fileName withError:(NSError **)error;


/**
 查找文件是否存在

 @param fileName 文件名

 @return 存在则返回文件完整路径，不存在则返回nil
 */
- (NSString *)filePathForFileName:(NSString *)fileName;

@end
