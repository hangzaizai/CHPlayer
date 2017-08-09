//
//  CHPlayer.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/9.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayer.h"
#import <AVFoundation/AVFoundation.h>



@interface CHPlayer ()

@property(nonatomic,strong)NSURL *currentURL;

@end

@implementation CHPlayer

+ (NSArray *)assetKeysShouldBeLoaded
{
    return @[@"duration",@"playable"];
}

- (instancetype)initWithURL:(NSURL *)aURL
{
    self = [super init];
    if ( self ) {
        NSAssert(!aURL, @"url cann't be nil");
        self.currentURL = aURL;
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:aURL options:nil];
        [asset loadValuesAsynchronouslyForKeys:[[self class] assetKeysShouldBeLoaded] completionHandler:^{
            []
        }];
    }
    return self;
}

@end
