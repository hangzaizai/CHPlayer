//
//  CHPlayerResourceLoaderManager.h
//  CHPlayer
//
//  Created by 陈行 on 17/8/13.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;
/**
 resourceLoader经理类，负责调用资源的下载和资源的文件信息储存,由CHPlayerResourceLoaderDelegate调用
 */
@interface CHPlayerResourceLoaderManager : NSObject

- (void)addAssetResourceLoadingRequest:(AVAssetResourceLoadingRequest *)request;

- (void)cancelAssetResourceLoadingRequest:(AVAssetResourceLoadingRequest *)request;

@end
