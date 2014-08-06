//
//  BlowDetecter.m
//  town
//
//  Created by Song on 13-8-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P1_BlowDetecter.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface P1_BlowDetecter ()
{
    BOOL _isBlowing;
    
    AVAudioRecorder *recorder;
	NSTimer *levelTimer;
	double lowPassResults;
}

@end

@implementation P1_BlowDetecter

static P1_BlowDetecter* blowDetecterInstance = nil;

+ (P1_BlowDetecter*)instance
{
    if(!blowDetecterInstance)
    {
        blowDetecterInstance = [[P1_BlowDetecter alloc] init];
    }
    return blowDetecterInstance;
}

+ (void)purge
{
    [[P1_BlowDetecter instance] removeDelegateAndTimer];
    blowDetecterInstance = nil;
}


- (id)init
{
    self = [super init];
    if(self)
    {
        _isBlowing = NO;
        
        
        
        NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
		
        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                                  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                                  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                                  nil];
		
        NSError *error;
		
        recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
		NSError *setCategoryError = nil;
        
        BOOL success = [[AVAudioSession sharedInstance]
                        setCategory:
//                        AVAudioSessionCategoryRecord
                        AVAudioSessionCategoryPlayAndRecord
                        error: &setCategoryError];
        if (recorder) {
            [recorder prepareToRecord];
            recorder.meteringEnabled = YES;
            [recorder record];
            levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        } else
            NSLog(@"%@",[error description]);
    }
    return self;
}

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    
	const double ALPHA = 0.05;
    
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
//    NSLog(@"%f,%f,%f",[recorder peakPowerForChannel:0],[recorder peakPowerForChannel:1],[recorder peakPowerForChannel:2]);
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
	
	if (lowPassResults > 0.8)
    {
        if(!_isBlowing)
        {
            _isBlowing = YES;
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(blowDetecterDidStartBlow)]) {
                [self.delegate blowDetecterDidStartBlow];
            }
        }
    }
    else
    {
        if(_isBlowing)
        {
            _isBlowing = NO;
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(blowDetecterDidEndBlow)]) {
                [self.delegate blowDetecterDidEndBlow];
            }
        }
    }
}

- (BOOL)isBlowing
{
    return _isBlowing;
}

#pragma mark - 退出时解决的delegate和Timer
- (void)removeDelegateAndTimer
{
    self.delegate = nil;
    [levelTimer invalidate];
    levelTimer = nil;
}
@end
