//
//  P3_MushroomRight.m
//  HST
//
//  Created by Emerson on 14-12-5.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P3_MushroomRight.h"

#define kMoveDuration1  2.0
#define kMoveDuration2  2.0
#define kMoveDuration3  2.0
#define kMoveDuration4  2.0

@implementation P3_MushroomRight
{
    CCBAnimationManager * selfAnimationManager;
}

@synthesize mushroomBody;
@synthesize mushroomEye;

- (void) didLoadFromCCB
{
    selfAnimationManager = self.userObject;
    selfAnimationManager.delegate = self;
    
    [self idleAnimation];
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    if ([name isEqualToString:@"idle"]) {
        [selfAnimationManager runAnimationsForSequenceNamed:@"idle"];
        [self idleAnimation];
    }
}

- (void)idleAnimation
{
    CCSequence * mBRotateSeq = [CCSequence actions:
                                [CCRotateTo actionWithDuration:kMoveDuration1 angle:-8.0],
                                [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                                [CCRotateTo actionWithDuration:kMoveDuration3 angle:8.0],
                                [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                                nil];
    
    CCSequence * mBPositionSeq = [CCSequence actions:
                                  [CCMoveTo actionWithDuration:kMoveDuration1 position:CGPointMake(2.0, -1.0)],
                                  [CCMoveTo actionWithDuration:kMoveDuration2 position:CGPointMake(0.0, 2.0)],
                                  [CCMoveTo actionWithDuration:kMoveDuration3 position:CGPointMake(-2.0, 0.0)],
                                  [CCMoveTo actionWithDuration:kMoveDuration4 position:CGPointMake(0.0, 0.0)],
                                  nil];
    CCSpawn * mBSpawn = [CCSpawn actions:mBPositionSeq,mBRotateSeq, nil];
    [mushroomBody runAction:mBSpawn];
    
    
    CCSequence * mEPosition = [CCSequence actions:
                               [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(-5.0, -1.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(4.0, 2.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration3 position:CGPointMake(6.0, 0.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration4 position:CGPointMake(-5.0, -1.0)],
                               nil];
    
    CCSequence * mERotation = [CCSequence actions:
                               [CCRotateTo actionWithDuration:kMoveDuration1 angle:10.0],
                               [CCRotateTo actionWithDuration:kMoveDuration2 angle:15.0],
                               [CCRotateTo actionWithDuration:kMoveDuration3 angle:20.0],
                               [CCRotateTo actionWithDuration:kMoveDuration4 angle:10.0],
                               nil];
    CCSpawn * mESpawn = [CCSpawn actions:mEPosition,mERotation, nil];
    [mushroomEye runAction:mESpawn];
}

- (void)dealloc
{
    selfAnimationManager.delegate = nil;
    selfAnimationManager = nil;
    
    [super dealloc];
}

@end
