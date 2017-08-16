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

@interface CHPlayerResourceLoaderManager ()<CHPlayerResourceLoadingRequestManagerDelegate>

@property(nonatomic,strong)CHPlayerResourceCacheInfo *resourceCacheInfo;

@property(nonatomic,strong)NSMutableArray *loadingRequestManagerArray;

@end

@implementation CHPlayerResourceLoaderManager

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        CHPlayerResourceCacheInfo *cacheInfo = [[CHPlayerResourceCacheInfo alloc] init];
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
    
}

@end
