//
//  CHPlayerResourceContentInfo.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/14.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHPlayerResourceContentInfo : NSObject

@property(nonatomic,copy)NSString *contentType;
@property(nonatomic,assign)BOOL byteRangeAccessSupported;
@property (nonatomic) long long contentLength;

@end
