//
//  CHPlayerResourceLoadingRequestManager.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/14.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerResourceLoadingRequestManager.h"
#import "CHPlayerResourceDownloadManager.h"
#import "CHPlayerResourceCacheInfo.h"


@interface CHPlayerResourceLoadingRequestManager ()

@property(nonatomic,readwrite,strong)AVAssetResourceLoadingRequest *currentLoadingRequest;

@property(nonatomic,readwrite,strong)CHPlayerResourceCacheInfo *cacheInfo;

@end

@implementation CHPlayerResourceLoadingRequestManager

- (instancetype)initWithResourceLoadingRequest:(AVAssetResourceLoadingRequest *)request withChPlayerCacheInfo:(CHPlayerResourceCacheInfo *)cacheInfo
{
    self = [super init];
    if ( self ) {
        self.currentLoadingRequest = request;
        self.cacheInfo = cacheInfo;
    }
    return self;
}

- (void)startDownload
{
    
}

@end
