//
//  CHPlayerResourceLoaderManager.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/13.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerResourceLoaderManager.h"
#import "CHPlayerResourceCacheInfo.h"
#import "CHPlayerResourceDownloadManager.h"

@interface CHPlayerResourceLoaderManager ()

@property(nonatomic,strong)CHPlayerResourceCacheInfo *resourceCacheInfo;

@end

@implementation CHPlayerResourceLoaderManager

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        CHPlayerResourceCacheInfo *cacheInfo = [[CHPlayerResourceCacheInfo alloc] init];
        self.resourceCacheInfo = cacheInfo;
    }
    return self;
}

- (void)addAssetResourceLoadingRequest:(AVAssetResourceLoadingRequest *)request
{
    
}

- (void)cancelAssetResourceLoadingRequest:(AVAssetResourceLoadingRequest *)request
{
    
}

@end
