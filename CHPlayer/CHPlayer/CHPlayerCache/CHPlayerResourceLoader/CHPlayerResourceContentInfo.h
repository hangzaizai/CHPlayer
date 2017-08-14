//
//  CHPlayerResourceContentInfo.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/14.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 资源的基本信息
 */
@interface CHPlayerResourceContentInfo : NSObject

- (instancetype)initWithHTTPResponse:(NSHTTPURLResponse *)response;

@property(nonatomic,readonly,copy)NSString *contentType;
@property(nonatomic,readonly,assign)BOOL byteRangeAccessSupported;
@property (nonatomic,readonly,assign) long long contentLength;

@end
