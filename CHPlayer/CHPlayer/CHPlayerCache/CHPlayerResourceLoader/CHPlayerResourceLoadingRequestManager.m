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
#import "CHPlayerResourceContentInfo.h"


@interface CHPlayerResourceLoadingRequestManager ()<CHPlayerResourceDownloadManagerDelegate>

@property(nonatomic,readwrite,strong)AVAssetResourceLoadingRequest *currentLoadingRequest;

@property(nonatomic,readwrite,strong)CHPlayerResourceCacheInfo *cacheInfo;
@property(nonatomic,readwrite,strong)CHPlayerResourceDownloadManager *downloadManager;
@property(nonatomic,readwrite,strong)CHPlayerResourceContentInfo *resourceContentInfo;

@property(nonatomic,strong)NSMutableData *receiveData;

//写入文件
@property(nonatomic,strong)NSFileHandle *writeFileHandle;
//读文件操作
@property(nonatomic,strong)NSFileHandle *readFileHandel;


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
    AVAssetResourceLoadingDataRequest *dataRequest = self.currentLoadingRequest.dataRequest;
    long long offset = dataRequest.requestedOffset;
    NSInteger length = dataRequest.requestedLength;
    if ( dataRequest.currentOffset !=0 ) {
        offset = dataRequest.currentOffset;
    }
    
    if ( [[UIDevice currentDevice].systemName floatValue] >= 9.0 ) {
        if ( dataRequest.requestsAllDataToEndOfResource ) {
            offset = self.cacheInfo.fileSize;
        }
    }
    
    //获取URL
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self.currentLoadingRequest.request.URL resolvingAgainstBaseURL:NO];
    components.scheme = @"https";
    
    //创建下载的临时文件
    
    
    //获取range,暂时数据不用考虑，将本地的数据拼接起来(这样可以减少从网络下载的数据量)，只是简单的下载avplayer内核要求的数据
    NSRange range = NSMakeRange(offset, length);
    
    CHPlayerResourceDownloadManager *downloadManager = [[CHPlayerResourceDownloadManager alloc] initWithURL:components.URL withRange:range];
    self.downloadManager = downloadManager;
    downloadManager.delegate = self;
}


/**
 创建下载临时文件路径
 */
- (void)createDownloadFilePathWithURL:(NSURL *)aURL
{
    NSString *tmpDirectory = NSTemporaryDirectory();
    //通过文件名来建立临时文件
    NSString *fileName = [[aURL lastPathComponent] stringByDeletingPathExtension];
    
    NSString *tmpFileDirectory = [tmpDirectory stringByAppendingPathComponent:fileName];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:tmpFileDirectory] ) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpFileDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if ( error ) {
            if ( self.delegate && [self.delegate respondsToSelector:@selector(playerResourceLoadingRequestManager:didComplicatedWithError:)] ) {
                [self.delegate playerResourceLoadingRequestManager:self didComplicatedWithError:error];
            }
            return;
        }
    }
    
    NSError *error = nil;
    
    NSString *filePath = [tmpFileDirectory stringByAppendingPathComponent:[aURL lastPathComponent]];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    self.writeFileHandle = [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:filePath] error:&error];
    if ( !error ) {
        if ( self.delegate && [self.delegate respondsToSelector:@selector(playerResourceLoadingRequestManager:didComplicatedWithError:)] ) {
            [self.delegate playerResourceLoadingRequestManager:self didComplicatedWithError:error];
        }
        return;
    }
    
}

#pragma mark - resourceDownloadManager
- (void)playerResourceDownloadManager:(CHPlayerResourceDownloadManager *)mamager didReceiveResponse:(NSHTTPURLResponse *)response
{
    
    CHPlayerResourceContentInfo *contentInfo = [[CHPlayerResourceContentInfo alloc] initWithHTTPResponse:response];
    self.currentLoadingRequest.contentInformationRequest.contentType = contentInfo.contentType;
    self.currentLoadingRequest.contentInformationRequest.contentLength = contentInfo.contentLength;
    self.currentLoadingRequest.contentInformationRequest.byteRangeAccessSupported = contentInfo.byteRangeAccessSupported;
    
    self.cacheInfo.fileSize = contentInfo.contentLength;
    self.receiveData = [NSMutableData dataWithLength:contentInfo.contentLength];
}

- (void)playerResourceDownloadManager:(CHPlayerResourceDownloadManager *)mamager didReceiveReceiveData:(NSData *)data
{
    [self.currentLoadingRequest.dataRequest respondWithData:data];
    //[self.receiveData appendData:data];
}

- (void)playerResourceDownloadManager:(CHPlayerResourceDownloadManager *)mamager didComplicatedWithError:(NSError *)error
{
    if ( error ) {
        [self.currentLoadingRequest finishLoadingWithError:error];
    }else{
        [self.currentLoadingRequest finishLoading];
        
        //内存记录下载信息
        [self.cacheInfo addCacheRange:mamager.range];
        
        //将数据的下载信息写入文件
        
    }
}

@end