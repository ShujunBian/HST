//
//  Monster.m
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_Monster.h"
#import "P2_MonsterEye.h"
#import "CCBReader.h"
#import "CCBAnimationManager.h"
#import "P2_LittleFlyObjects.h"
#import "P2_FlyGrass.h"
#import "P2_CalculateHelper.h"

#define EVERYDELTATIME 0.016667
#define RATIOTORUNNEWEYEMOVING 0.7
#define RATIOTOCLOSEEYES 0.85

@implementation P2_Monster
@synthesize monsterHead;
@synthesize monsterBody;
@synthesize monsterEye;
@synthesize isFinishJump;
@synthesize currentJumpTime;

- (id)init
{
	if( (self=[super init]))
    {
        jumpTime = 0.0;
        theIdleTimes = 0;
        currentJumpTime = 0.0;
        downSpeed = 0.0;
        isReadyToJump = NO;
        isReadyToDown = NO;
        isFinishJump = YES;
        self.isInMainMap = NO;
        [self scheduleUpdate];
	}
	return self;
}


- (void)didLoadFromCCB
{
    eyesAnimationManager = monsterEye.userObject;
    eyesAnimationManager.delegate = self;
    
    selfAnimationManager = self.userObject;
    selfAnimationManager.delegate = self;
    
}


-(void)update:(ccTime)delta
{
    if (isReadyToJump == YES) {
        jumpTime += EVERYDELTATIME;
        currentJumpTime += EVERYDELTATIME;
        if (jumpTime < 15 * EVERYDELTATIME || (fabsf(jumpTime - 15 * EVERYDELTATIME) < 0.01)) {
            self.position = CGPointMake(self.position.x, EVERYDELTATIME * 781.1 + self.position.y);
        }
        else if (jumpTime > 15 * EVERYDELTATIME && ((jumpTime < 30 * EVERYDELTATIME) || (fabsf(jumpTime - 30 * EVERYDELTATIME) < 0.01)))
        {
            self.position = CGPointMake(self.position.x, EVERYDELTATIME * 641.1 + self.position.y);
        }
        else if (jumpTime > 30 * EVERYDELTATIME && ((jumpTime < 40 * EVERYDELTATIME) || (fabsf(jumpTime - 40 * EVERYDELTATIME) < 0.01)))
        {
            self.position = CGPointMake(self.position.x, EVERYDELTATIME * 266.66 + self.position.y);
        }
        else if (jumpTime > 40 * EVERYDELTATIME) {
            [self letMonsterDown];
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
            currentJumpTime = 0.0;
            jumpTime = 0.0;
            isReadyToDown = NO;
            
            P2_FlyGrass * flyGrass = (P2_FlyGrass *)[CCBReader nodeGraphFromFile:@"P2_FlyGrasses.ccbi"];
            flyGrass.position = CGPointMake(self.position.x , self.position.y + 10);
            [self.parent addChild:flyGrass z:0];
            CCBAnimationManager * flyGrassAnimationManager =flyGrass.userObject;
            int flyGrassType = (arc4random() % 2) + 1;
            NSString * flyGrassFilename = [NSString stringWithFormat:@"GrassDown%d",flyGrassType];
            [flyGrassAnimationManager runAnimationsForSequenceNamed:flyGrassFilename];
            
            [selfAnimationManager runAnimationsForSequenceNamed:@"OverDown"];
        }
    }
    
    if (isToBuffer == YES) {
        jumpTime += EVERYDELTATIME;
        if (jumpTime < bufferTime || fabsf(jumpTime - bufferTime) < 0.01) {
            self.position = CGPointMake(self.position.x, 10 + self.position.y);
        }
        else
        {
            isToBuffer = NO;
            [self letMonsterDown];
        }
    }
}

-(float)getMonsterDownSpeed:(float)height
{
    return ((height / EVERYDELTATIME) / 60);
}

-(void)isReadyToJump
{
    
}

-(void)jump
{
    [self resetScale];
    [self monsterEyeActionWhenJump];
    [self monsterHeadActionWhenJump];
    [self monsterBodyActionWhenJump];
}

- (void)resetScale
{
    [self setScale:1.0];
}

-(void)monsterEyeActionWhenJump
{
    CCScaleTo * eyeScale1 = [CCScaleTo actionWithDuration:(24 * EVERYDELTATIME) scaleX:0.98 scaleY:1.05];
    CCMoveBy * eyeMove1 = [CCMoveBy actionWithDuration:(18 * EVERYDELTATIME) position:CGPointMake(0.0, 0.0)];
    CCMoveBy * eyeMove2 = [CCMoveBy actionWithDuration:(6 * EVERYDELTATIME) position:CGPointMake(0.0, 13.0)];
    CCSequence * eyeMoveSeq = [CCSequence actions:eyeMove1,eyeMove2, nil];
    CCSpawn * eyeScaleAndMove1 = [CCSpawn actions:eyeScale1,eyeMoveSeq, nil];
    
    
    CCScaleTo * eyeScale2 = [CCScaleTo actionWithDuration:(16 * EVERYDELTATIME) scaleX:1.0 scaleY:1.0];
    CCMoveBy * eyeMove3 = [CCMoveBy actionWithDuration:(16 * EVERYDELTATIME) position:CGPointMake(0.0, -13.0)];
    CCSpawn * eyeScaleAndMove2 = [CCSpawn actions:eyeScale2,eyeMove3, nil];
    
    CCSequence * eyeSeq = [CCSequence actions:eyeScaleAndMove1,eyeScaleAndMove2, nil];
    [monsterEye runAction:eyeSeq];
}

-(void)monsterHeadActionWhenJump
{
    CCScaleTo * headScale1 = [CCScaleTo actionWithDuration:(24 * EVERYDELTATIME) scaleX:1.0 scaleY:1.04];
    CCMoveBy * headMove1 = [CCMoveBy actionWithDuration:(24 * EVERYDELTATIME) position:CGPointMake(0, 79.0)];
    CCSpawn * headScaleAndMove1 = [CCSpawn actions:headScale1,headMove1, nil];
    
    CCScaleTo * headScale2 = [CCScaleTo actionWithDuration:(16 * EVERYDELTATIME) scaleX:1.0 scaleY:1.0];
    CCMoveBy * headMove2 = [CCMoveBy actionWithDuration:(16 * EVERYDELTATIME) position:CGPointMake(0, -20.0)];
    CCSpawn * headScaleAndMove2 = [CCSpawn actions:headScale2,headMove2, nil];
    
    CCSequence * headSeq = [CCSequence actions:headScaleAndMove1,headScaleAndMove2, nil];
    
    [monsterHead runAction:headSeq];
}


-(void)monsterBodyActionWhenJump
{
    CCScaleTo * bodyScale1 = [CCScaleTo actionWithDuration:(24 * EVERYDELTATIME) scaleX:0.9 scaleY:1.08];
    CCScaleTo * bodyScale2 = [CCScaleTo actionWithDuration:(16 * EVERYDELTATIME) scaleX:1.0 scaleY:1.0];
    CCSequence * bodySeq = [CCSequence actions:bodyScale1,bodyScale2, nil];
    [monsterBody runAction:bodySeq];
}

-(void)monsterCloseEyesWhenReadyToJump
{
    [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeJumpClose"];
}

- (void) handleCollision
{
    if (isReadyToDown == NO)
    {
        isToBuffer = YES;
        isReadyToJump = NO;
        jumpTime = 0.0;
        bufferTime = [P2_CalculateHelper getTheRestFrameForMonsterMoveWith:self.position.y] * EVERYDELTATIME;
        
        //        [self monsterBodyActionWhenCollisidein:bufferTime];
        //        [self monsterHeadActionWhenCollisidein:bufferTime];
        //        [self monsterEyeActionWhenCollisidein:bufferTime];
    }
}

-(void)monsterBodyActionWhenCollisidein:(ccTime)time
{
    [monsterBody stopAllActions];
    CCScaleTo * bodyScale = [CCScaleTo actionWithDuration:time scaleX:2 scaleY:0.5];
    [monsterBody runAction:bodyScale];
}

-(void)monsterHeadActionWhenCollisidein:(ccTime)time
{
    [monsterHead stopAllActions];
    CCScaleTo * headScale = [CCScaleTo actionWithDuration:time scaleX:1.02 scaleY:0.98];
    [monsterHead runAction:headScale];
}

-(void)monsterEyeActionWhenCollisidein:(ccTime)time
{
    [monsterEye stopAllActions];
    CCScaleTo * eyeScale = [CCScaleTo actionWithDuration:time scaleX:1.05 scaleY:0.95];
    [monsterEye runAction:eyeScale];
}

-(void)letMonsterDown
{
    currentJumpTime = 0.0;
    jumpTime = 0.0;
    isReadyToJump = NO;
    isReadyToDown = YES;
}

#pragma mark - AnimationManagerDelegate

- (void) completedAnimationSequenceNamed:(NSString *)name
{
//    NSLog(@"name is %@",name);
    //    if ([name isEqualToString:@"Idle"]) {
    //        float isLittleJump = (float)arc4random() / ARC4RANDOM_MAX;
    //        if (isLittleJump > 0.1) {
    //
    //
    //
    //        }
    //        else {
    //            ++ theIdleTimes;
    //            float isRunNewMoving = (float)arc4random() / ARC4RANDOM_MAX;
    //            float isRunClosingEyes = (float)arc4random() / ARC4RANDOM_MAX;
    //            if (isRunNewMoving > RATIOTORUNNEWEYEMOVING || theIdleTimes == 4) {
    //                [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeMoving"];
    //                theIdleTimes = 0;
    //            }
    //            else if (isRunClosingEyes > RATIOTOCLOSEEYES)
    //            {
    //                [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeClose"];
    //                [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeOpen"];
    //            }
    //        }
    //    }
    //    else
    if ([name isEqualToString:@"ReadyToJump"])
    {
        isReadyToJump = YES;
        [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeJumpOpen"];
        [self jump];
        //[selfAnimationManager runAnimationsForSequenceNamed:@"Jump"];
    }
    else if ([name isEqualToString:@"OverDown"])
    {
        isFinishJump = YES;
        [selfAnimationManager runAnimationsForSequenceNamed:@"LittleJump"];
    }
    else if ([name isEqualToString:@"LittleJump"])
    {
        float rate = 1.0;
        float changeScaleRate = 0.1;
        if (self.isInMainMap) {
            rate = 0.45;
            changeScaleRate = 0.02;
        }
        theIdleTimes ++ ;
        CCScaleTo * monsterScale = [CCScaleTo actionWithDuration:0.20 scaleX:1.0 * rate + changeScaleRate scaleY:1.0 * rate - changeScaleRate];
        CCEaseOut * easeOutLittleJumpUp = [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0.0, 20.0 * rate)] rate:1.5];
        CCScaleTo * monsterScaleBack = [CCScaleTo actionWithDuration:0.25 scaleX:1.0 * rate scaleY:1.0 * rate];
        CCSpawn * littleJump = [CCSpawn actions:easeOutLittleJumpUp,monsterScaleBack, nil];
        CCMoveBy * moveBy = [CCMoveBy actionWithDuration:0.2 position:ccp(0.0, -20.0 * rate)];
        CCCallFunc * callFunc = [CCCallFunc actionWithTarget:self selector:@selector(monsterOverLittleJump:)];
        
        CCSequence * monseterLittleJump = [CCSequence actions:monsterScale,
                                           //                                           monsterScaleTest,
                                           littleJump,
                                           moveBy,
                                           callFunc,
                                           nil];
        [self runAction:monseterLittleJump];
        
        if (CCRANDOM_0_1() > RATIOTORUNNEWEYEMOVING && theIdleTimes > 12) {
            [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeMoving"];
            theIdleTimes = 0;
        }
        else if (CCRANDOM_0_1() > RATIOTOCLOSEEYES )
        {
            [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeClose"];
            [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeOpen"];
        }
        
        
    }
    else if ([name isEqualToString:@"OverLittleJump"])
    {
        isFinishJump = YES;
        [selfAnimationManager runAnimationsForSequenceNamed:@"LittleJump"];
    }
    
    
}

#pragma mark - MonseterOverLittleJump
- (void)monsterReadyToLittleJump:(id)sender
{
    [selfAnimationManager runAnimationsForSequenceNamed:@"LittleJump"];
}

- (void)monsterOverLittleJump:(id)sender
{
    [selfAnimationManager runAnimationsForSequenceNamed:@"LittleJump"];
}

- (void)runningEyeMoving
{
    //    if (!isMovingEyes) {
    //        [eyesAnimationManager runAnimationsForSequenceNamed:@"EyeMoving"];
    //        isMovingEyes = YES;
    //    }
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
