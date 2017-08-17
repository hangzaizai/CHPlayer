//
//  CHPlayerResourceLoaderDelegate.h
//  CHPlayer
//
//  Created by 陈行 on 17/8/13.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

/**
ResouceLoaderDelegate 在iOS7-iOS10player的边下边播是通过
 设置AVAssetResourceLoaderDelegate实现的，该类就是实现AVAssetResourceLoaderDelegate协议
 */
@interface CHPlayerResourceLoaderDelegate : NSObject<AVAssetResourceLoaderDelegate>

- (instancetype)initWithURL:(NSURL *)playUrl;

@end
