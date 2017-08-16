//
//  CHPlayerResourceLoaderDelegate.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/13.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerResourceLoaderDelegate.h"
#import "CHPlayerResourceLoaderManager.h"

@interface CHPlayerResourceLoaderDelegate ()

@property(nonatomic,strong)CHPlayerResourceLoaderManager *resourceLoaderManager;

@end

@implementation CHPlayerResourceLoaderDelegate

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        CHPlayerResourceLoaderManager *resourceLoaderManager = [[CHPlayerResourceLoaderManager alloc] init];
        self.resourceLoaderManager = resourceLoaderManager;
    }
    return self;
}

/**
 resoueceLoader等待资源下载
 */
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    [self.resourceLoaderManager addAssetResourceLoadingRequest:loadingRequest];
    return YES;
}



/**
 当avasset不需要资源了就取消请求
 */
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    [self.resourceLoaderManager cancelAssetResourceLoadingRequest:loadingRequest];
}


@end
