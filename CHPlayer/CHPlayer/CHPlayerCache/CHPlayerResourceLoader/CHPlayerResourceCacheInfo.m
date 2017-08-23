//
//  CHPlayerResourceCacheInfo.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/14.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerResourceCacheInfo.h"
#import "CHPlayerResourceCacheConfiguration.h"

@interface CHPlayerResourceCacheInfo ()

@property(nonatomic,readwrite,copy)NSString *fileName;

//写入文件
@property(nonatomic,readwrite,strong)NSFileHandle *writeFileHandle;
//读文件操作
@property(nonatomic,readwrite,strong)NSFileHandle *readFileHandle;
//文件操作的URL
@property(nonatomic,readwrite,strong)NSURL *fileHandleURL;

@property(nonatomic,readwrite,strong)NSMutableArray *cacheRanges;

@end

@implementation CHPlayerResourceCacheInfo

- (void)dealloc
{
    [self.writeFileHandle closeFile];
    [self.readFileHandle closeFile];
}

- (instancetype)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if ( self ) {
        self.cacheRanges = [NSMutableArray array];
        self.fileName = fileName;
        [self createTmpFilePath];
    }
    return self;
}

#pragma mark -accessor
- (NSArray<NSValue *> *)ranges
{
    return [self.cacheRanges copy];
}

- (void)setFileSize:(long long)fileSize
{
    if ( _fileSize!=0 ) {
        return;
    }
    _fileSize = fileSize;
    //设置的大小
    [self.writeFileHandle truncateFileAtOffset:fileSize];
}

//根据文件名，创建临时文件路径，文件路径组成为:tmp/filename去后缀/filename
- (void)createTmpFilePath
{
    NSString *tmpDirectory = NSTemporaryDirectory();
    //通过文件名来建立临时文件
    NSString *fileName = [self.fileName stringByDeletingPathExtension];
    
    NSString *tmpFileDirectory = [tmpDirectory stringByAppendingPathComponent:fileName];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:tmpFileDirectory] ) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpFileDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if ( error ) {
            if ( self.delegate && [self.delegate respondsToSelector:@selector(playerResourceCacheInfo:withError:)] ) {
                [self.delegate playerResourceCacheInfo:self withError:error];
            }
            return;
        }
    }
    
    NSError *error = nil;
    
    NSString *filePath = [tmpFileDirectory stringByAppendingPathComponent:self.fileName];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSURL *fileHandleURL = [NSURL fileURLWithPath:filePath];
    self.fileHandleURL = fileHandleURL;
    NSLog(@"文件地址为:%@",self.fileHandleURL);
    self.writeFileHandle = [NSFileHandle fileHandleForWritingToURL:fileHandleURL error:&error];
    if ( !error ) {
        if ( self.delegate && [self.delegate respondsToSelector:@selector(playerResourceCacheInfo:withError:)] ) {
            [self.delegate playerResourceCacheInfo:self withError:error];
        }
        return;
    }
}



//将文件写入指定的range中
- (void)writeDataToFileWithData:(NSData *)data withRange:(NSRange)range
{
    self.cacheRanges = [[self deleteRepeatedRange] mutableCopy];
    
    if ( [self checkDownloadDataIsFull] ) {
        
        NSError *error = nil;
        
        //将临时文件拷贝到永久文件
        [[CHPlayerResourceCacheConfiguration shareInstance] copyFileWithResource:self.fileHandleURL withDesName:self.fileName withError:&error];
        if ( error ) {
            NSLog(@"拷贝文件失败,错误信息为:%@",error);
        }else{
            NSLog(@"拷贝文件成功临时文件的路径为:%@",self.fileHandleURL);
        }
        return;
    }
    
    [self.cacheRanges addObject:[NSValue valueWithRange:range]];
    [self.writeFileHandle seekToFileOffset:range.location];
    [self.writeFileHandle writeData:data];
    
    
}

#pragma mark -range
- (NSArray *)deleteRepeatedRange
{
    NSMutableArray *valueRangeArray = [self.cacheRanges mutableCopy];
    NSMutableArray *remainRangeArray = [self.cacheRanges mutableCopy];
    
    NSLog(@"下载的ranges为:%@",self.cacheRanges);
    
    if ( self.cacheRanges.count==0 ) {
        return valueRangeArray;
    }
    
    for ( int i = 0 ; i < valueRangeArray.count -1 ; i++ ) {
        NSRange rangeI = [valueRangeArray[i] rangeValue];
        for (int j = i+1 ; j < valueRangeArray.count ; j++ ) {
            NSRange rangeJ = [valueRangeArray[j] rangeValue];
            if ( rangeI.location==rangeJ.location && rangeI.length <= rangeJ.length ) {
                [remainRangeArray removeObjectAtIndex:i];
            }else if ( rangeI.location<rangeJ.location && NSMaxRange(rangeI) >=NSMaxRange(rangeJ) ) {
                [remainRangeArray removeObjectAtIndex:i];
            }
        }
    }
    
    return remainRangeArray;

}

/**
 检测下载的数据是否已经下载完
 */
- (BOOL)checkDownloadDataIsFull
{
    if ( self.cacheRanges.count==0 ) {
        return NO;
    }
    
    //对数据进行排序
    //NSLog(@"下载的range=%@",self.cacheRanges);
    
    NSArray *sortedArr = [self.cacheRanges sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSRange rangeOne = [(NSValue *)obj1 rangeValue];
        NSRange rangeTwo = [(NSValue *)obj2 rangeValue];
        
        NSComparisonResult result = rangeOne.location <= rangeTwo.location ? NSOrderedAscending : NSOrderedDescending;
        return result==NSOrderedDescending;
    }];
    
    NSLog(@"排序后的range=%@",sortedArr);
    
    NSRange firstRange = [((NSValue *)[sortedArr firstObject]) rangeValue];
    NSRange lastRange = [((NSValue *)[sortedArr lastObject]) rangeValue];
    
    
    if ( firstRange.location > 0 ) {
        return NO;
    }
    
    if ( NSMaxRange(lastRange) < self.fileSize ) {
        return NO;
    }
    
    NSInteger maxRange = NSMaxRange(firstRange);
    for ( int i = 1 ; i < sortedArr.count ; i++ ) {
        NSRange range = [sortedArr[i] rangeValue];
        if ( maxRange < range.location ) {
            return NO;
        }
        maxRange = NSMaxRange(range);
    }
    
    return YES;
}


@end
