//
//  CHPlayerResourceLoadingRequestManager.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/14.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHPlayerResourceCacheInfo;

@import AVFoundation;

@protocol CHPlayerResourceLoadingRequestManagerDelegate;

/*
 处理resourceLoadingRequest,从CHPlayerResourceLoaderManager
 和CHPlayerResourceDownloadManager之间提取了一层出来，这样下载就只管下载,下载也可以复用了
 */
@interface CHPlayerResourceLoadingRequestManager : NSObject

@property(nonatomic,readonly,strong)AVAssetResourceLoadingRequest *currentLoadingRequest;
@property(nonatomic,weak)id <CHPlayerResourceLoadingRequestManagerDelegate> delegate;

@property(nonatomic,readonly,assign)NSRange currentRange;

@property(nonatomic,readonly,strong)NSMutableData *receiveData;

- (instancetype)initWithResourceLoadingRequest:(AVAssetResourceLoadingRequest *)request withChPlayerCacheInfo:(CHPlayerResourceCacheInfo *)cacheInfo;

- (void)startDownload;

- (void)cancelDownload;

@end


@protocol CHPlayerResourceLoadingRequestManagerDelegate <NSObject>

- (void)playerResourceLoadingRequestManager:(CHPlayerResourceLoadingRequestManager *)requestManager didReceiveResponse:(NSHTTPURLResponse *)response;

- (void)playerResourceLoadingRequestManager:(CHPlayerResourceLoadingRequestManager *)requestManager didReceiveData:(NSData *)data withRange:(NSRange)range;

- (void)playerResourceLoadingRequestManager:(CHPlayerResourceLoadingRequestManager *)requestManager didComplicatedWithError:(NSError *)error;

@end
