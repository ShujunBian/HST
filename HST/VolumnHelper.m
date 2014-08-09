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

@implementation VolumnHelper


+ (VolumnHelper *)sharedVolumnHelper
{
    if (!sharedVolumnHelper) {
        sharedVolumnHelper = [[VolumnHelper alloc]init];
    }
    return sharedVolumnHelper;
}

- (void)downBackgroundVolumn:(NSTimer *)timer
{
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume -= 0.01;
    if (fabsf([SimpleAudioEngine sharedEngine].backgroundMusicVolume - 0.0) < 0.05) {
        [timer invalidate];
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.0;
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
}

- (void)upBackgroundVolumn:(NSTimer *)timer
{
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume += 0.01;
    if (fabsf([SimpleAudioEngine sharedEngine].backgroundMusicVolume - 1.0) < 0.05) {
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1.0;
        [timer invalidate];
    }
}

@end
