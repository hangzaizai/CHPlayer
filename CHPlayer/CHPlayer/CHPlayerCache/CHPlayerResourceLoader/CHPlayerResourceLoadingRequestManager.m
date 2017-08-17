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
@property(nonatomic,readwrite,strong)CHPlayerResourceDownloadManager *downloadManager;
@property(nonatomic,readwrite,strong)CHPlayerResourceContentInfo *resourceContentInfo;

@property(nonatomic,strong)NSMutableData *receiveData;

@property(nonatomic,assign)NSRange currentRange;

@end

@implementation CHPlayerResourceLoadingRequestManager

- (instancetype)initWithResourceLoadingRequest:(AVAssetResourceLoadingRequest *)request withChPlayerCacheInfo:(CHPlayerResourceCacheInfo *)cacheInfo
{
    self = [super init];
    if ( self ) {
        self.currentLoadingRequest = request;
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
    
    if ( [[UIDevice currentDevice].systemName floatValue] >= 9.0 && self.currentLoadingRequest.response ) {
        if ( dataRequest.requestsAllDataToEndOfResource ) {
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.currentLoadingRequest.response;
            
            long long fileSize =  [[[response.allHeaderFields[@"Content-Range"] componentsSeparatedByString:@"/"] lastObject] longLongValue];
            if ( fileSize != 0 ) {
                offset = fileSize;
            }
            
            NSLog(@"全部下载fileSize=%@",@(fileSize));
        }
    }
    
    //获取URL
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self.currentLoadingRequest.request.URL resolvingAgainstBaseURL:NO];
    components.scheme = @"https";
    
    //获取range,暂时数据不用考虑，将本地的数据拼接起来(这样可以减少从网络下载的数据量)，只是简单的下载avplayer内核要求的数据
    NSRange range = NSMakeRange(offset, length);
    NSValue *value = [NSValue valueWithRange:range];
    NSLog(@"需要下载的range=%@",value);
    self.currentRange = range;
    CHPlayerResourceDownloadManager *downloadManager = [[CHPlayerResourceDownloadManager alloc] initWithURL:components.URL withRange:range];
    self.downloadManager = downloadManager;
    downloadManager.delegate = self;
}

- (void)cancelDownload
{
    [self.downloadManager cancelDownload];
}



#pragma mark - resourceDownloadManager
- (void)playerResourceDownloadManager:(CHPlayerResourceDownloadManager *)mamager didReceiveResponse:(NSHTTPURLResponse *)response
{
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerResourceLoadingRequestManager:didReceiveResponse:)] ) {
        [self.delegate playerResourceLoadingRequestManager:self didReceiveResponse:response];
    }
    
    CHPlayerResourceContentInfo *contentInfo = [[CHPlayerResourceContentInfo alloc] initWithHTTPResponse:response];
    self.currentLoadingRequest.contentInformationRequest.contentType = contentInfo.contentType;
    self.currentLoadingRequest.contentInformationRequest.contentLength = contentInfo.contentLength;
    self.currentLoadingRequest.contentInformationRequest.byteRangeAccessSupported = contentInfo.byteRangeAccessSupported;
    
    self.currentLoadingRequest.response = response;
    
    NSLog(@"fileSize=%@",@(contentInfo.contentLength));
    
    //初始化接收数据
    self.receiveData = [NSMutableData dataWithLength:contentInfo.contentLength];
    
    
}

- (void)playerResourceDownloadManager:(CHPlayerResourceDownloadManager *)mamager didReceiveReceiveData:(NSData *)data
{
    [self.currentLoadingRequest.dataRequest respondWithData:data];
    [self.receiveData appendData:data];
}

- (void)playerResourceDownloadManager:(CHPlayerResourceDownloadManager *)mamager didComplicatedWithError:(NSError *)error
{
    
    NSLog(@"下载完成range=%@",[NSValue valueWithRange:mamager.range]);
    
    if ( error ) {
        [self.currentLoadingRequest finishLoadingWithError:error];
    }else{
        [self.currentLoadingRequest finishLoading];
    }
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(playerResourceLoadingRequestManager:didComplicatedWithError:)] ) {
        [self.delegate playerResourceLoadingRequestManager:self didComplicatedWithError:error];
    }
}

@end
