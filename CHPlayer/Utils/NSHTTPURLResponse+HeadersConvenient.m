//
//  NSHTTPURLResponse+HeadersConvenient.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/17.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "NSHTTPURLResponse+HeadersConvenient.h"

@implementation NSHTTPURLResponse (HeadersConvenient)

- (long long)getContentLength
{
    
    NSString *contentRange = self.allHeaderFields[@"Content-Range"];
    if ( !contentRange || contentRange.length==0 ) {
        return 0;
    }
    
    NSArray *contentRangeArray = [contentRange componentsSeparatedByString:@"/"];
    
    long long fileSize =  [[contentRangeArray lastObject] longLongValue];
    
    return fileSize;
}

@end
