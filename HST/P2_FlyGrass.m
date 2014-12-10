//
//  FlyGrass.m
//  jump
//
//  Created by Emerson on 13-9-3.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_FlyGrass.h"

#define EVERYDELTATIME 0.016667

@implementation P2_FlyGrass
@synthesize grassLeft;
@synthesize grassMiddle;
@synthesize grassRight;

- (void) didLoadFromCCB
{
//    CCBAnimationManager* animationManager = self.userObject;
//    animationManager.delegate = self;
    [self scheduleUpdate];
}

- (void)update:(ccTime)delta
{
    self.position = CGPointMake(self.position.x - 1024.0 / 8.0 * EVERYDELTATIME, self.position.y);
}

- (void)grassAnimationOne
{
    CCSequence * grassLPSeq = [CCSequence actions:[CCEaseOut actionWithAction:
                                                   [CCMoveTo actionWithDuration:1.0 position:CGPointMake(-70.0, 80.0)] rate:2.0],
                               [CCEaseIn actionWithAction:
                                [CCMoveTo actionWithDuration:1.0 position:CGPointMake(-75.0, 76.0)] rate:2.0],
                               [CCMoveTo actionWithDuration:21.0/30.0 position:CGPointMake(-65.0, 54.0)],
                               [CCEaseIn actionWithAction:
                                [CCMoveTo actionWithDuration:39.0/30.0 position:CGPointMake(-70.0, -11.0)] rate:2.0],
                               nil];
    
    CCSequence * grassLRSeq = [CCSequence actions:[CCRotateBy actionWithDuration:1.0 angle:0.0],
                               [CCRotateTo actionWithDuration:0.5 angle:-60.0],
                               [CCRotateTo actionWithDuration:0.5 angle:-120.0],
                               [CCRotateTo actionWithDuration:0.5 angle:-180.0],
                               [CCRotateTo actionWithDuration:0.5 angle:-210.0],
                               [CCRotateTo actionWithDuration:0.5 angle:-240.0],
                               [CCRotateTo actionWithDuration:0.5 angle:-20.0],
                               nil];
    
    CCSpawn * grassLSpa = [CCSpawn actions:grassLPSeq,grassLRSeq, nil];

    CCSequence * grassMPSeq = [CCSequence actions:
                               [CCEaseOut actionWithAction:
                                [CCMoveTo actionWithDuration:1.0 position:CGPointMake(42.0 , 100.0)] rate:2.0],
                               [CCEaseIn actionWithAction:
                                [CCMoveTo actionWithDuration:1.0 position:CGPointMake(52.0, 89.0)] rate:2.0],
                               [CCMoveTo actionWithDuration:1.0 position:CGPointMake(37.0, 44.0)],
                                [CCMoveTo actionWithDuration:1.0 position:CGPointMake(45.0, 0.0)],
                               nil];
    
    CCSequence * grassMRSeq = [CCSequence actions:[CCRotateBy actionWithDuration:1.0 angle:0.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-60.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-120.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-160.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-130.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-110.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-100.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-105.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-110.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-113.0],
                               nil];
    
    CCSpawn * grassMSpa = [CCSpawn actions:grassMPSeq,grassMRSeq, nil];

    CCSequence * grassRPSeq = [CCSequence actions:
                               [CCEaseOut actionWithAction:
                                [CCMoveTo actionWithDuration:1.0 position:CGPointMake(110.0, 50.0)] rate:2.0],
                               [CCEaseIn actionWithAction:
                                [CCMoveTo actionWithDuration:3.0 position:CGPointMake(125.0, 0.0)] rate:2.0],
                               nil];
    
    CCSequence * grassRRSeq = [CCSequence actions:[CCRotateBy actionWithDuration:1.0 angle:0.0],
                               [CCRotateTo actionWithDuration:25.0/30.0 angle:-40.0],
                               [CCRotateTo actionWithDuration:25.0/30.0 angle:-80.0],
                               [CCRotateTo actionWithDuration:20.0/30.0 angle:-115.0],
                               [CCRotateTo actionWithDuration:20.0/30.0 angle:-150.0],
                               nil];
    
    CCSpawn * grassRSpa = [CCSpawn actions:grassRPSeq,grassRRSeq, nil];

    [grassLeft runAction:grassLSpa];
    [grassMiddle runAction:grassMSpa];
    [grassRight runAction:grassRSpa];
    
    CCSequence * seq = [CCSequence actions: [CCDelayTime actionWithDuration:4.2],[CCCallBlock actionWithBlock:^{
        [self removeFromParentAndCleanup:YES];
    }], nil];
    [self runAction:seq];
}

- (void)grassAnimationTwo
{
    CCSequence * grassLPSeq = [CCSequence actions:[CCEaseOut actionWithAction:
                                                   [CCMoveTo actionWithDuration:20.0/30.0 position:CGPointMake(-90.0, 60.0)] rate:2.0],
                               [CCEaseIn actionWithAction:
                                [CCMoveTo actionWithDuration:45.0/30.0 position:CGPointMake(-102, 21.0)] rate:2.0],
                               [CCMoveTo actionWithDuration:12.0/30.0 position:CGPointMake(-96.0, 12.0)],
                                [CCMoveTo actionWithDuration:13.0/30.0 position:CGPointMake(-98.0, 0.0)],
                               nil];
    
    CCSequence * grassLRSeq = [CCSequence actions:[CCRotateTo actionWithDuration:20.0/30.0 angle:0.0],
                               [CCRotateTo actionWithDuration:15.0/30.0 angle:60.0],
                               [CCRotateTo actionWithDuration:15.0/30.0 angle:120.0],
                               [CCRotateTo actionWithDuration:15.0/30.0 angle:150.0],
                               [CCRotateTo actionWithDuration:12.0/30.0 angle:110.0],
                               [CCRotateTo actionWithDuration:13.0/30.0 angle:130.0],
                               nil];
    
    CCSpawn * grassLSpa = [CCSpawn actions:grassLPSeq,grassLRSeq, nil];
    
    CCSequence * grassMPSeq = [CCSequence actions:
                               [CCEaseOut actionWithAction:
                                [CCMoveTo actionWithDuration:20.0/30.0 position:CGPointMake(52.0 , 80.0)] rate:2.0],
                               [CCEaseIn actionWithAction:
                                [CCMoveTo actionWithDuration:70.0/30.0 position:CGPointMake(48.0, 0.0)] rate:2.0],
                               nil];
    
    CCSequence * grassMRSeq = [CCSequence actions:[CCRotateTo actionWithDuration:20.0/30.0 angle:0.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-60.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-120.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-180.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-240.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-300.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-380.0],
                               [CCRotateTo actionWithDuration:10.0/30.0 angle:-460.0],
                               nil];
    
    CCSpawn * grassMSpa = [CCSpawn actions:grassMPSeq,grassMRSeq, nil];
    
    CCSequence * grassRPSeq = [CCSequence actions:[CCEaseOut actionWithAction:
                                                   [CCMoveTo actionWithDuration:20.0/30.0 position:CGPointMake(120.0, 30.0)] rate:2.0],
                               [CCEaseIn actionWithAction:
                                [CCMoveTo actionWithDuration:30.0/30.0 position:CGPointMake(100.0, 12.9)] rate:2.0],
                               [CCMoveTo actionWithDuration:25.0/30.0 position:CGPointMake(107.0, -1.4)],
                               [CCMoveTo actionWithDuration:15.0/30.0 position:CGPointMake(105.0, -10.0)],
                               nil];
    
    CCSequence * grassRRSeq = [CCSequence actions:[CCRotateBy actionWithDuration:20.0/30.0 angle:30.0],
                               nil];
    
    CCSpawn * grassRSpa = [CCSpawn actions:grassRPSeq,grassRRSeq, nil];
    
    [grassLeft runAction:grassLSpa];
    [grassMiddle runAction:grassMSpa];
    [grassRight runAction:grassRSpa];
    
    CCSequence * seq = [CCSequence actions: [CCDelayTime actionWithDuration:4.2],[CCCallBlock actionWithBlock:^{
        [self removeFromParentAndCleanup:YES];
    }], nil];
    [self runAction:seq];
}

@end
