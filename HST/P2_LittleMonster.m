//
//  LittleMonster.m
//  jump
//
//  Created by Emerson on 13-9-2.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_LittleMonster.h"
#import "P2_MonsterEye.h"

#define EVERYDELTATIME 0.016667
#define ARC4RANDOM_MAX 0x100000000

@implementation P2_LittleMonster

@synthesize littleMonsterEye;
@synthesize isFinishJump;

- (id)init
{
	if( (self=[super init]))
    {
        jumpTime = 0.0f;
        theIdleTimes = 0;
        downSpeed = 0.0f;
        [self scheduleUpdate];
	}
	return self;
}


- (void)didLoadFromCCB
{
    isReadyToJump = NO;
    isReadyToDown = NO;
    isFinishJump = YES;
    
    eyesAnimationManager = littleMonsterEye.userObject;
    eyesAnimationManager.delegate = self;
    [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeMoving"];
    isRunningEyeMoving = YES;
    
    
    selfAnimationManager = self.userObject;
    selfAnimationManager.delegate = self;
    
}


-(void)update:(ccTime)delta
{
    if (isReadyToJump == YES) {
        jumpTime += EVERYDELTATIME;
        if (jumpTime < 15 * EVERYDELTATIME || (fabsf(jumpTime - 15 * EVERYDELTATIME) < 0.01)) {
            self.position = CGPointMake(self.position.x, EVERYDELTATIME * 326.66 + self.position.y);
        }
        else if (jumpTime > 15 * EVERYDELTATIME && ((jumpTime < 30 * EVERYDELTATIME) || (fabsf(jumpTime - 30 * EVERYDELTATIME) < 0.01)))
        {
            self.position = CGPointMake(self.position.x, EVERYDELTATIME * 206.66 + self.position.y);
        }
        else if (jumpTime > 30 * EVERYDELTATIME && ((jumpTime < 40 * EVERYDELTATIME) || (fabsf(jumpTime - 40 * EVERYDELTATIME) < 0.01)))
        {
            self.position = CGPointMake(self.position.x, EVERYDELTATIME * 100 + self.position.y);
        }
        else if (jumpTime > 40 * EVERYDELTATIME) {
            jumpTime = 0;
            isReadyToJump = NO;
            isReadyToDown = YES;
        }
    }
    
    if (isReadyToDown == YES) {
        [selfAnimationManager runAnimationsForSequenceNamed:@"Down"];
        jumpTime += EVERYDELTATIME;
        if (fabsf((jumpTime - EVERYDELTATIME)) < 0.01) {
            downSpeed = [self getMonsterDownSpeed:self.position.y];
        }
        if (jumpTime < 10 * EVERYDELTATIME || (fabsf(jumpTime - 10 * EVERYDELTATIME) < 0.01)) {
            self.position = CGPointMake(self.position.x, -EVERYDELTATIME * downSpeed + self.position.y);
        }
        else if (jumpTime > 10 * EVERYDELTATIME && ((jumpTime < 20 * EVERYDELTATIME) || (fabsf(jumpTime - 20 * EVERYDELTATIME) < 0.01)))
        {
            self.position = CGPointMake(self.position.x, -EVERYDELTATIME * downSpeed * 2 + self.position.y);
        }
        else if (jumpTime > 20 * EVERYDELTATIME && ((jumpTime < 30 * EVERYDELTATIME) || (fabsf(jumpTime - 30 * EVERYDELTATIME) < 0.01)))
        {
            self.position = CGPointMake(self.position.x, -EVERYDELTATIME * downSpeed * 3 + self.position.y);
        }
        else if (jumpTime > 30 * EVERYDELTATIME) {
            jumpTime = 0;
            isReadyToDown = NO;
            [selfAnimationManager runAnimationsForSequenceNamed:@"OverDown"];
        }
    }
}

-(float)getMonsterDownSpeed:(float)height
{
    return ((height / EVERYDELTATIME) / 60);
}


- (void) completedAnimationSequenceNamed:(NSString *)name
{
    if ([name isEqualToString:@"Idle"]) {
        [selfAnimationManager runAnimationsForSequenceNamed:@"LittleJump"];
    }
    else if ([name isEqualToString:@"ReadyToJump"])
    {
        isReadyToJump = YES;
        [selfAnimationManager runAnimationsForSequenceNamed:@"Jump"];
    }
    else if ([name isEqualToString:@"OverDown"])
    {
        isFinishJump = YES;
        [selfAnimationManager runAnimationsForSequenceNamed:@"LittleJump"];
    }
    else if ([name isEqualToString:@"LittleJump"])
    {
        [selfAnimationManager runAnimationsForSequenceNamed:@"LittleJump"];
        ++ theIdleTimes;
        float isRunNewMoving = (float)arc4random() / ARC4RANDOM_MAX;
        if (isRunNewMoving > 1.0) {
            isRunNewMoving = isRunNewMoving - 1.0;
        }
        if (isRunNewMoving > 0.8 && theIdleTimes >= 12) {
            [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeMoving"];
            theIdleTimes = 0;
        }
    }
}

#pragma mark - 退出场景是释放

- (void)releaseAnimationDelegate
{
    eyesAnimationManager.delegate = nil;
    eyesAnimationManager = nil;
    
    selfAnimationManager.delegate = nil;
    selfAnimationManager = nil;
}
@end
