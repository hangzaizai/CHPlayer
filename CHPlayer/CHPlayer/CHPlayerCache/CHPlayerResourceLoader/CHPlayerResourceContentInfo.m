//
//  CHPlayerResourceContentInfo.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/14.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayerResourceContentInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CHPlayerResourceContentInfo ()

@property(nonatomic,readwrite,copy)NSString *contentType;
@property(nonatomic,readwrite,assign)BOOL byteRangeAccessSupported;
@property (nonatomic,readwrite,assign) long long contentLength;

@end

@implementation CHPlayerResourceContentInfo

- (instancetype)initWithHTTPResponse:(NSHTTPURLResponse *)response
{
    self = [super init];
    if ( self ) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            NSString *acceptRange = HTTPURLResponse.allHeaderFields[@"Accept-Ranges"];
            self.byteRangeAccessSupported = [acceptRange isEqualToString:@"bytes"];
            self.contentLength = [[[HTTPURLResponse.allHeaderFields[@"Content-Range"] componentsSeparatedByString:@"/"] lastObject] longLongValue];
        }
        NSString *mimeType = response.MIMEType;
        CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);
        self.contentType = CFBridgingRelease(contentType);
    }
    return self;
}

@end
