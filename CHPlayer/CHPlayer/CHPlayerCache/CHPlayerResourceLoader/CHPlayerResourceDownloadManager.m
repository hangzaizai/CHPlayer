//
//  CHPlayerResourceDownloadManager.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/13.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerResourceDownloadManager.h"

@interface CHPlayerResourceDownloadManager ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,strong)NSURL *currentURL;
@property(nonatomic,assign)NSRange currentRange;


@end

@implementation CHPlayerResourceDownloadManager

- (instancetype)initWithURL:(NSURL *)url withRange:(NSRange)range
{
    self = [super init];
    if ( self ) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        configuration.timeoutIntervalForRequest = 30;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self.session = session;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
        [task resume];
        
    }
    return self;
}

- (void)cancelDownload
{
    [self.session invalidateAndCancel];
}


#pragma mark - session Delegate
/**
 收到服务器响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
}


/**
 接受到数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
}


/**
 完成
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}

@end
