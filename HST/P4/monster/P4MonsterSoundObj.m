//
//  P4MonsterSoundObj.m
//  HST
//
//  Created by wxy325 on 8/9/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P4MonsterSoundObj.h"
#import "SimpleAudioEngine.h"
#import "P4Monster.h"

@interface P4MonsterSoundObj ()

@property (assign,nonatomic) BOOL fIsPlay;
@property (strong, nonatomic) P4Monster* monster;
@end


@implementation P4MonsterSoundObj

- (float)maxDelay
{
    float delay = 1.f;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getMaxDelayTime)])
    {
        delay = [self.delegate getMaxDelayTime];
    }
    return delay;
}

#pragma mark - Init Method
- (id)initWithMonster:(P4Monster*)monster
{
    self = [super init];
    if (self)
    {
//        self.maxDelay = 1.f;
        self.fIsPlay = NO;
        self.monster = monster;
    }
    return self;
}
- (float)genDelayTime:(float)maxDelay
{
    return maxDelay * ( 0.5 + 0.5 * CCRANDOM_0_1());
}
- (void)beginSound
{
    if (!self.fIsPlay)
    {
        self.fIsPlay = YES;
        [self playEffect];
    }
//    [self performSelector:@selector(playEffect) withObject:nil afterDelay:[self genDelayTime]];
}
- (void)endSound
{
    self.fIsPlay = NO;
}

- (void)playEffect
{
    if (self.fIsPlay)
    {

        float maxDelayTime = self.maxDelay;
        if (maxDelayTime < 8.f)
        {
            float delayTime = [self genDelayTime:maxDelayTime] / 2;
            [[SimpleAudioEngine sharedEngine] playEffect:self.monster.selectedSoundEffectName];
            if ([self.delegate respondsToSelector:@selector(soundWillPlay:delay:)])
            {
                [self.delegate soundWillPlay:self delay:delayTime];
            }

            [self performSelector:@selector(playEffect) withObject:nil afterDelay:delayTime];
        }
        else
        {
            self.fIsPlay = NO;
        }
    }
}

- (void)dealloc
{
    self.monster = nil;
    self.delegate = nil;
    
    [super dealloc];
}
@end
