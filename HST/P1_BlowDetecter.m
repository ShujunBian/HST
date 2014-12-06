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
#import "UIDevice+Hardware.h"

#define kIsFirstMicDetectKey @"kIsFirstMicDetectKey"
#define kIsEnableMicDetectKey @"kIsEnableMicDetectKey"
@interface P1_BlowDetecter ()
{
    BOOL _isBlowing;
    
    AVAudioRecorder *recorder;
	NSTimer *levelTimer;
	double lowPassResults;
}

@end

@implementation P1_BlowDetecter
+ (BOOL)isFirstDetect
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* fFirst = [userDefaults objectForKey:kIsFirstMicDetectKey];
    return !fFirst || [fFirst isEqual:[NSNull null]] || fFirst.boolValue;
}
+ (void)setIsFirstDetect:(BOOL)fFirst
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(fFirst) forKey:kIsFirstMicDetectKey];
    [userDefaults synchronize];
}
+ (BOOL)isEnableDetect
{
    if ([self checkIsAir]) {
        return NO;
    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* fFirst = [userDefaults objectForKey:kIsEnableMicDetectKey];
    return !fFirst || [fFirst isEqual:[NSNull null]] || fFirst.boolValue;
}
+ (BOOL)checkIsAir
{
    UIDevice* device = [UIDevice currentDevice];
    Hardware h = [device hardware];

    switch (h) {
        case IPAD_AIR_WIFI:
        case IPAD_AIR_WIFI_GSM:
        case IPAD_AIR_WIFI_CDMA:
        case IPAD_AIR_2_WIFI:
        case IPAD_AIR_2_WIFI_CELLULAR:
            return YES;
        default:
            return NO;
    }
}

+ (void)setIsEnableDetect:(BOOL)fFirst
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(fFirst) forKey:kIsEnableMicDetectKey];
    [userDefaults synchronize];
}

static P1_BlowDetecter* blowDetecterInstance = nil;

- (BOOL)isDetect
{
    if (![P1_BlowDetecter isEnableDetect] || !self.success){
        return false;
    } else {
        return true;
    }
}

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
    [blowDetecterInstance release];
    blowDetecterInstance = nil;
}


- (id)init
{
    self = [super init];
    
    if (![P1_BlowDetecter isEnableDetect]) {
        return self;
    }

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
        
        _success = [[AVAudioSession sharedInstance]
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
    
    NSString *mediaType = AVMediaTypeAudio; // Or AVMediaTypeAudio
    
    _success = [self checkMicrophoneIsReady];
    return self;
}
- (BOOL)checkMicrophoneIsReady
{
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if (!captureInput) {
        return NO;
    } else {
        return YES;
    }
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
