//
//  Flower.m
//  Jump
//
//  Created by Emerson on 13-8-29.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_Flower.h"

#define kMoveDuration1  2.0
#define kMoveDuration2  2.0
#define kMoveDuration3  2.0
#define kMoveDuration4  2.0

@implementation P2_Flower

@synthesize flowerBody;
@synthesize flowerHead;
@synthesize flowerEyes;

- (void) didLoadFromCCB
{
    [super didLoadFromCCB];
    
    CCSequence * fBSeq = [CCSequence actions:
                          [CCRotateTo actionWithDuration:kMoveDuration1 angle:-8.0],
                          [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                          [CCRotateTo actionWithDuration:kMoveDuration3 angle:8.0],
                          [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                          nil];
    CCRepeatForever * rotateForevr = [CCRepeatForever actionWithAction:fBSeq];
    [self runAction:rotateForevr];
}

- (void)idleAnimation
{
    CCSequence * fBSeq = [CCSequence actions:
                          [CCRotateTo actionWithDuration:kMoveDuration1 angle:-8.0],
                          [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                          [CCRotateTo actionWithDuration:kMoveDuration3 angle:8.0],
                          [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                          nil];
    [flowerBody runAction:fBSeq];
    
    
    CCSequence * fHSeqPosition = [CCSequence actions:
                                  [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(2.0, -1.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(-2.0, 1.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration3 position:CGPointMake(-2.0, 0.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration4 position:CGPointMake(2.0, 0.0)],
                                  nil];
    
    CCSequence * fHSeqRotation = [CCSequence actions:
                                  [CCRotateTo actionWithDuration:kMoveDuration1 angle:-8.0],
                                  [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                                  [CCRotateTo actionWithDuration:kMoveDuration3 angle:8.0],
                                  [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                                  nil];
    
    CCSpawn * fHSpawn = [CCSpawn actions:fHSeqPosition,fHSeqRotation, nil];
    [flowerHead runAction:fHSpawn];
    
    CCSequence * fEPosition = [CCSequence actions:
                               [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(-3.0, -1.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(3.0, 1.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration3 position:CGPointMake(4.0, 1.0)],
                               [CCMoveBy actionWithDuration:kMoveDuration4 position:CGPointMake(-4.0, -1.0)],
                               nil];
    
    CCSequence * fERotation = [CCSequence actions:
                               [CCRotateTo actionWithDuration:kMoveDuration1 angle:0.0],
                               [CCRotateTo actionWithDuration:kMoveDuration2 angle:8.0],
                               [CCRotateTo actionWithDuration:kMoveDuration3 angle:16.0],
                               [CCRotateTo actionWithDuration:kMoveDuration4 angle:8.0],
                               nil];
    CCSpawn * fESpawn = [CCSpawn actions:fEPosition,fERotation, nil];
    [flowerEyes runAction:fESpawn];
}

- (void)setObjectFirstPosition:(float)offsetX
{
    objectPostionX = CCRANDOM_0_1() * 1024.0;
    self.position = CGPointMake(objectPostionX + offsetX , 0.0);
}

- (void)actionWhenOutOfScreen
{
    objectPostionX = 1024.0 + CCRANDOM_0_1() * 1024.0;
    self.position = CGPointMake(objectPostionX, 0.0);
}


- (void)dealloc
{
    [super dealloc];
}

@end
