//
//  CHPlayerResourceDownloadManager.h
//  CHPlayer
//
//  Created by 陈行 on 17/8/13.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 负责处理文件的下载，用NSURLSession
 */
@interface CHPlayerResourceDownloadManager : NSObject

- (instancetype)initWithURL:(NSURL *)url withRange:(NSRange )range;

@end
