//
//  NSHTTPURLResponse+HeadersConvenient.h
//  CHPlayer
//
//  Created by 陈行 on 17/8/17.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (HeadersConvenient)

//获取contentLength,没有返回0
- (long long)getContentLength;

@end
