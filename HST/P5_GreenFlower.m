//
//  P5_GreenFlower.m
//  HST
//
//  Created by Emerson on 14-12-5.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P5_GreenFlower.h"
#define kMoveDuration1  2.0
#define kMoveDuration2  2.0
#define kMoveDuration3  2.0
#define kMoveDuration4  2.0

@implementation P5_GreenFlower
{
    CCBAnimationManager * selfAnimationManager;
}

@synthesize flowerBody;
@synthesize flowerHead;
@synthesize flowerEyes;

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
    CCSequence * fBSeq = [CCSequence actions:
                          [CCRotateTo actionWithDuration:kMoveDuration1 angle:-8.0],
                          [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                          [CCRotateTo actionWithDuration:kMoveDuration3 angle:8.0],
                          [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                          nil];
    [flowerBody runAction:fBSeq];
    
    
    CCSequence * fHSeqPosition = [CCSequence actions:
                                  [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(2.0, 0.0)],
                                  [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(-2.0, 0.0)],
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

- (void)dealloc
{
    selfAnimationManager.delegate = nil;
    selfAnimationManager = nil;
    
    [super dealloc];
}

@end
