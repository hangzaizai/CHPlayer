//
//  CHPlayerResourceLoaderManager.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/13.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerResourceLoaderManager.h"
#import "CHPlayerResourceCacheInfo.h"
#import "CHPlayerResourceLoadingRequestManager.h"
#import "NSHTTPURLResponse+HeadersConvenient.h"

@interface CHPlayerResourceLoaderManager ()<CHPlayerResourceLoadingRequestManagerDelegate>

@property(nonatomic,strong)CHPlayerResourceCacheInfo *resourceCacheInfo;

@property(nonatomic,strong)NSMutableArray *loadingRequestManagerArray;

@property(nonatomic,strong)dispatch_queue_t cacheInfoQueue;

@end

@implementation CHPlayerResourceLoaderManager

- (instancetype)initWithURL:(NSURL *)playUrl
{
    self = [super init];
    if ( self ) {
        CHPlayerResourceCacheInfo *cacheInfo = [[CHPlayerResourceCacheInfo alloc] initWithFileName:[playUrl lastPathComponent]];
        self.resourceCacheInfo = cacheInfo;
        self.loadingRequestManagerArray = [NSMutableArray array];
    }
    return self;
}

- (void)addAssetResourceLoadingRequest:(AVAssetResourceLoadingRequest *)request
{
    CHPlayerResourceLoadingRequestManager *loadingRequest = [[CHPlayerResourceLoadingRequestManager alloc] initWithResourceLoadingRequest:request withChPlayerCacheInfo:self.resourceCacheInfo];
    loadingRequest.delegate = self;
    [loadingRequest startDownload];
    [self.loadingRequestManagerArray addObject:loadingRequest];
}

- (void)cancelAssetResourceLoadingRequest:(AVAssetResourceLoadingRequest *)request
{
    for ( CHPlayerResourceLoadingRequestManager *loadingRequest in self.loadingRequestManagerArray ) {
        if ( [request isEqual:loadingRequest.currentLoadingRequest] ) {
            [loadingRequest cancelDownload];
            [self.loadingRequestManagerArray removeObject:loadingRequest];
            return;
        }
    }
}

#pragma mark -delegate
- (void)playerResourceLoadingRequestManager:(CHPlayerResourceLoadingRequestManager *)requestManager didComplicatedWithError:(NSError *)error
{
    //无论是否出现错误，都取消请求，不重试
    if ( error ) {
        NSLog(@"下载出现了错误:%@",error);
    }
    
    [self.resourceCacheInfo writeDataToFileWithData:requestManager.receiveData withRange:requestManager.currentRange];
    
    [self.loadingRequestManagerArray removeObject:requestManager];
}

- (void)playerResourceLoadingRequestManager:(CHPlayerResourceLoadingRequestManager *)requestManager didReceiveResponse:(NSHTTPURLResponse *)response
{
    self.resourceCacheInfo.fileSize = [response getContentLength];
}

@end
