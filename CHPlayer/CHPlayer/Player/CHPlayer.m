//
//  CHPlayer.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/9.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MacErrors.h>
#import "CHPlayerError.h"

#define REFRESH_INTERNAL 0.5

//播放状态
static NSString * const kCHPlayerPlayerItemStatus = @"status";
//缓冲时间
static NSString * const kCHPlayerPlayerPreloadTime = @"loadedTimeRanges";

static const NSString *playerItemContext;

@interface CHPlayer ()

@property(nonatomic,strong)NSURL *currentURL;
@property(nonatomic,strong)AVPlayerItem *playerItem;
@property(nonatomic,strong)AVPlayer *player;
@property(strong, nonatomic) id playEndObserver;
@property(strong,nonatomic)

@end

@implementation CHPlayer

+ (NSArray *)assetKeysShouldBeLoaded
{
    return @[@"duration",@"playable"];
}

- (void)dealloc
{
    if ( self.playEndObserver ) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.playEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        self.playEndObserver = nil;
    }
    if ( self.playerItem ) {
        [self.playerItem removeObserver:self forKeyPath:kCHPlayerPlayerPreloadTime context:&playerItemContext];
    }
}

- (instancetype)initWithURL:(NSURL *)aURL
{
    self = [super init];
    if ( self ) {
        NSAssert(!aURL, @"url cann't be nil");
        self.currentURL = aURL;
    }
    return self;
}

#pragma mark -observe for keyPath
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ( context==&playerItemContext ) {
        __weak CHPlayer *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong CHPlayer *strongSelf = weakSelf;
            
            if ( [keyPath isEqualToString:kCHPlayerPlayerItemStatus] ) {
                
                [strongSelf.playerItem removeObserver:strongSelf forKeyPath:kCHPlayerPlayerItemStatus context:&playerItemContext];
                if ( strongSelf.playerItem.status==AVPlayerItemStatusFailed ) {
                    [strongSelf handlePrepareToPlayWithDuration:kCMTimeZero WithError:strongSelf.playerItem.error];
                }else if ( strongSelf.playerItem.status==AVPlayerItemStatusReadyToPlay ) {
                    [strongSelf handlePrepareToPlayWithDuration:strongSelf.playerItem.duration WithError:nil];
                    [self addPlayerCurrentTimeObserver];
                    [self addPlayDoneObserver];
                }

            }
            
            if ( [keyPath isEqualToString:kCHPlayerPlayerPreloadTime] ) {
                
                if ( strongSelf.playerItem.loadedTimeRanges &&  [strongSelf.playerItem.loadedTimeRanges count] ) {
                    NSValue *value = [strongSelf.playerItem.loadedTimeRanges firstObject];
                    CMTimeRange timeRange = [value CMTimeRangeValue];
                    NSTimeInterval preloadTime = CMTimeGetSeconds(CMTimeAdd(timeRange.start, timeRange.duration));
                    if ( strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(player:withPreloadTime:)]) {
                        [strongSelf.delegate player:strongSelf withPreloadTime:preloadTime];
                    }
                }
                
            }
            
        });
    }
}

#pragma mark -add play time observer
//当前时间
- (void)addPlayerCurrentTimeObserver
{
    //当前时间的回调间隔
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERNAL, NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_main_queue();
    __weak CHPlayer *weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:interval queue:queue usingBlock:^(CMTime time) {
        __strong CHPlayer *strongSelf = weakSelf;
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        if ( strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(player:withCurrentTime:)] ) {
            [strongSelf.delegate player:strongSelf withCurrentTime:currentTime];
        }
        
    }];
}

#pragma mark -add play done observer
- (void)addPlayDoneObserver
{
    NSString *name = AVPlayerItemDidPlayToEndTimeNotification;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    __weak CHPlayer *weakSelf = self;
    self.playEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:name object:self.playerItem queue:queue usingBlock:^(NSNotification * _Nonnull note) {
        __strong CHPlayer *strongSelf = weakSelf;
        if ( strongSelf.delegate && [self.delegate respondsToSelector:@selector(player:complicatedWithError:)] ) {
            [strongSelf.delegate player:strongSelf complicatedWithError:nil];
        }
    }];
}



#pragma mark - prepare to play error handle
- (void)handlePrepareToPlayWithDuration:(CMTime)duration WithError:(NSError *)error
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(player:prepareToPlayWithDuration:WithError:)] ) {
        NSTimeInterval time = CMTimeGetSeconds(duration);
        [self.delegate player:self prepareToPlayWithDuration:time WithError:error];
    }
}

- (void)prepareToPlay
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.currentURL options:nil];
    __weak CHPlayer *weakSelf = self;
    [asset loadValuesAsynchronouslyForKeys:[[self class] assetKeysShouldBeLoaded] completionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong CHPlayer *strongSelf = weakSelf;
            for ( NSString *key in [[strongSelf class] assetKeysShouldBeLoaded] ) {
                NSError *error = nil;
                AVKeyValueStatus status =  [asset statusOfValueForKey:key error:&error];
                if ( status==AVKeyValueStatusFailed ) {
                    [strongSelf handlePrepareToPlayWithDuration:kCMTimeZero WithError:error];
                    return;
                }
            }
            if ( !asset.isPlayable ) {
                
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"item cannot be play",NSLocalizedDescriptionKey,@"The contents of the resource at the specified URL are not playable",NSLocalizedFailureReasonErrorKey, nil];
                
                NSError *error = [NSError errorWithDomain:@"CHPlayerDomain" code:playableErr userInfo:dictionary];
                [strongSelf handlePrepareToPlayWithDuration:kCMTimeZero WithError:error];
                return;
            }
            
            if ( strongSelf.playerItem ) {
                //移出缓冲时间监听
                [strongSelf.playerItem removeObserver:self forKeyPath:kCHPlayerPlayerPreloadTime context:&playerItemContext];
                strongSelf.playerItem = nil;
            }
            
            //avplayer
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
            [playerItem addObserver:strongSelf forKeyPath:kCHPlayerPlayerItemStatus options:NSKeyValueObservingOptionNew context:&playerItemContext];
            strongSelf.playerItem = playerItem;
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            strongSelf.player = player;
            
        });
    }];
}

- (void)play
{
    [self.player play];
}

- (void)pause
{
    [self.player pause];
}

- (void)seekToTime:(NSTimeInterval)aTime withComplicated:(void (^)(BOOL))complicated
{
    CMTime time = CMTimeMakeWithSeconds(aTime, NSEC_PER_SEC);
    
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if ( complicated ) {
            complicated(finished);
        }
    }];
}


@end
