//
//  CHPlayerResourceDownloadManager.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/13.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerResourceDownloadManager.h"

@interface CHPlayerResourceDownloadManager ()

@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,strong)NSURL *currentURL;
@property(nonatomic,assign)NSRange currentRange;

@end

@implementation CHPlayerResourceDownloadManager

- (instancetype)initWithURL:(NSURL *)url withRange:(NSRange)range
{
    self = [super init];
    if ( self ) {
        
    }
    return self;
}

@end
