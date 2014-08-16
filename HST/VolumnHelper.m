//
//  VolumnHelper.m
//  HST
//
//  Created by Emerson on 14-8-5.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "VolumnHelper.h"
#import "SimpleAudioEngine.h"

static VolumnHelper * sharedVolumnHelper;

@interface VolumnHelper()

@property (nonatomic) BOOL isFinishedDown;
@property (nonatomic) BOOL isFinishedUp;


@end

@implementation VolumnHelper

+ (VolumnHelper *)sharedVolumnHelper
{
    if (!sharedVolumnHelper) {
        sharedVolumnHelper = [[VolumnHelper alloc]init];
    }
    return sharedVolumnHelper;
}

- (id)init
{
    if (self = [super init]) {
        self.isFinishedDown = YES;
        self.isFinishedUp = YES;
        self.isPlayingWordBgMusic = YES;
    }
    return self;
}


- (void)downBackgroundVolumn:(NSTimer *)timer
{
    if (_isFinishedUp) {
        _isFinishedDown = NO;
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume -= 0.1;
        [SimpleAudioEngine sharedEngine].effectsVolume -= 0.1;
        if (fabsf([SimpleAudioEngine sharedEngine].backgroundMusicVolume - 0.0) <= 0.15) {
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.0;
            [SimpleAudioEngine sharedEngine].effectsVolume = 0.0;
            
            [timer invalidate];
            _isFinishedDown = YES;
        }
    }

}

- (void)upBackgroundVolumn:(NSTimer *)timer
{
    if (_isFinishedDown) {
        _isFinishedUp = NO;
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume += 0.1;
        [SimpleAudioEngine sharedEngine].effectsVolume += 0.1;
        
        if (fabsf([SimpleAudioEngine sharedEngine].backgroundMusicVolume - 1.0) <= 0.15) {
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1.0;
            [SimpleAudioEngine sharedEngine].effectsVolume = 1.0;
            
            [timer invalidate];
            _isFinishedUp = YES;
        }
    }

}

@end
