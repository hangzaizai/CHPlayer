//
//  CHPlayerResourceCacheConfiguration.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/16.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerResourceCacheConfiguration.h"

@interface CHPlayerResourceCacheConfiguration ()

@property(nonatomic,copy)NSString *fileDirectoryPath;

@end

@implementation CHPlayerResourceCacheConfiguration

+ (instancetype)shareInstance
{
    static CHPlayerResourceCacheConfiguration *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CHPlayerResourceCacheConfiguration alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.fileDirectoryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"video"];
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:self.fileDirectoryPath] ) {
            
            NSError *error = nil;
            
            [[NSFileManager defaultManager] createDirectoryAtPath:self.fileDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
            if ( error ) {
                return nil;
            }
        }
    }
    return self;
}

- (void)copyFileWithResource:(NSURL *)sourceURL withDesName:(NSString *)fileName withError:(NSError **)error
{
    if ( !fileName || [fileName length]==0 ) {
        fileName = [[sourceURL absoluteString] lastPathComponent];
    }
    NSString *descPath = [self.fileDirectoryPath stringByAppendingPathComponent:fileName];
    
    NSURL *descURL = [NSURL fileURLWithPath:descPath];
    
    
    [[NSFileManager defaultManager] copyItemAtURL:sourceURL toURL:descURL error:error];
}

- (NSString *)filePathForFileName:(NSString *)fileName
{
    NSString *filePath = [self.fileDirectoryPath stringByAppendingPathComponent:fileName];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:fileName] ) {
        return filePath;
    }
    
    return nil;
    
}

@end
