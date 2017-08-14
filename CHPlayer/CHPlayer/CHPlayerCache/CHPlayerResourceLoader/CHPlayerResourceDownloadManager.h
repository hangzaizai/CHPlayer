//
//  CHPlayerResourceDownloadManager.h
//  CHPlayer
//
//  Created by 陈行 on 17/8/13.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;

@protocol CHPlayerResourceDownloadManagerDelegate;

/**
 负责处理文件的下载，用NSURLSession
 */
@interface CHPlayerResourceDownloadManager : NSObject

@property(nonatomic,readonly)NSURL *currentURL;
@property(nonatomic,readonly)NSRange range;
@property(nonatomic,readonly)NSURLSession *session;
@property(nonatomic,weak)id<CHPlayerResourceDownloadManagerDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)url withRange:(NSRange )range;

/**
 取消下载
 */
- (void)cancelDownload;

@end

@protocol CHPlayerResourceDownloadManagerDelegate <NSObject>


/**
 接收服务端响应
 */
- (void)playerResourceDownloadManager:(CHPlayerResourceDownloadManager *)mamager didReceiveResponse:(NSHTTPURLResponse *)response;


/**
 接受到数据
 */
- (void)playerResourceDownloadManager:(CHPlayerResourceDownloadManager *)mamager didReceiveReceiveData:(NSData *)data;


/**
 完成,error为空，表示没有错误
 */
- (void)playerResourceDownloadManager:(CHPlayerResourceDownloadManager *)mamager didComplicatedWithError:(NSError *)error;

@end
