//
//  Mushroom.m
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_Mushroom.h"

#define RESETDISTANCE 80
#define MINDISTANCE 80

#define kMoveDuration1  2.0
#define kMoveDuration2  2.0
#define kMoveDuration3  2.0
#define kMoveDuration4  2.0

@implementation P2_Mushroom

@synthesize mushroomBody1;
@synthesize mushroomBody2;
@synthesize mushroomEyes1;
@synthesize mushroomEyes2;
@synthesize mushroomHead1;
@synthesize mushroomHead2;

- (void) didLoadFromCCB
{
    [super didLoadFromCCB];
}

- (void)idleAnimation
{
    CCSequence * mBRotateSeq = [CCSequence actions:
                                [CCRotateTo actionWithDuration:kMoveDuration1 angle:-5.0],
                                [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                                [CCRotateTo actionWithDuration:kMoveDuration3 angle:8.0],
                                [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                                nil];
    [mushroomBody1 runAction:mBRotateSeq];
    
    CCSequence * mHRotateSeq = [CCSequence actions:
                                [CCRotateTo actionWithDuration:kMoveDuration1 angle:-8.0],
                                [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                                [CCRotateTo actionWithDuration:kMoveDuration3 angle:5.0],
                                [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                                nil];
    
    CCSequence * mHPositionSeq = [CCSequence actions:
                                  [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(-3.0, 0.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(3.0, 0.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration3 position:CGPointMake(5.0, 0.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration4 position:CGPointMake(-5.0, 0.0)],
                                  nil];
    CCSpawn * mHSpawn = [CCSpawn actions:mHRotateSeq,mHPositionSeq, nil];
    [mushroomHead1 runAction:mHSpawn];
    
    
    CCSequence * mEPosition = [CCSequence actions:
                               [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(-2.0, 0.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(2.0, 0.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration3 position:CGPointMake(5.0, 0.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration4 position:CGPointMake(-5.0, 0.0)],
                               nil];
    
    CCSequence * mERotation = [CCSequence actions:
                               [CCRotateTo actionWithDuration:kMoveDuration1 angle:-8.0],
                               [CCRotateTo actionWithDuration:kMoveDuration2 angle:-3.0],
                               [CCRotateTo actionWithDuration:kMoveDuration3 angle:5.0],
                               [CCRotateTo actionWithDuration:kMoveDuration4 angle:-3.0],
                               nil];
    CCSpawn * mESpawn = [CCSpawn actions:mEPosition,mERotation, nil];
    [mushroomEyes1 runAction:mESpawn];
    
    CCSequence * mBRotateSeq2 = [CCSequence actions:
                                [CCRotateTo actionWithDuration:kMoveDuration1 angle:-3.0],
                                [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                                [CCRotateTo actionWithDuration:kMoveDuration3 angle:5.0],
                                [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                                nil];
    [mushroomBody2 runAction:mBRotateSeq2];
    
    CCSequence * mHRotateSeq2 = [CCSequence actions:
                                [CCRotateTo actionWithDuration:kMoveDuration1 angle:-3.0],
                                [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                                [CCRotateTo actionWithDuration:kMoveDuration3 angle:5.0],
                                [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                                nil];
    
    CCSequence * mHPositionSeq2 = [CCSequence actions:
                                  [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(-1.0, 0.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(1.0, 0.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration3 position:CGPointMake(1.0, 0.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration4 position:CGPointMake(-1.0, 0.0)],
                                  nil];
    CCSpawn * mHSpawn2 = [CCSpawn actions:mHRotateSeq2,mHPositionSeq2, nil];
    [mushroomHead2 runAction:mHSpawn2];
    
    
    CCSequence * mEPosition2 = [CCSequence actions:
                               [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(-1.0, 0.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(1.0, 0.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration3 position:CGPointMake(1.0, 0.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration4 position:CGPointMake(-1.0, 0.0)],
                               nil];
    
    CCSequence * mERotation2 = [CCSequence actions:
                               [CCRotateTo actionWithDuration:kMoveDuration1 angle:-3.0],
                               [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                               [CCRotateTo actionWithDuration:kMoveDuration3 angle:5.0],
                               [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                               nil];
    CCSpawn * mESpawn2 = [CCSpawn actions:mEPosition2,mERotation2, nil];
    [mushroomEyes2 runAction:mESpawn2];
}

-(BOOL)isSamePositionWithFlower:(P2_Flower *)flower
{
    float currentDistance = self.position.x - flower.position.x;
    if ( currentDistance < MINDISTANCE && currentDistance > -MINDISTANCE) {
        return YES;
    }
    else
        return false;
}

-(void)resetFlowerPosition:(P2_Flower *)flower
{
    [flower setPosition:(CGPointMake(flower.position.x + RESETDISTANCE, flower.position.y))];
}

- (void)dealloc
{
    [super dealloc];
}

@end
