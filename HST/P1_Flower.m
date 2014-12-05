//
//  P1_Flower.m
//  HST
//
//  Created by Emerson on 14-12-4.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P1_Flower.h"

#define kMoveDuration1  36.0 / 30.0
#define kMoveDuration2  59.0 / 30.0
#define kMoveDuration3  69.0 / 30.0
#define kMoveDuration4  76.0 / 30.0

@implementation P1_Flower
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
    if ([name isEqualToString:@"blink"]) {
        [selfAnimationManager runAnimationsForSequenceNamed:@"blink"];
        [self idleAnimation];
    }
}

- (void)idleAnimation
{
    CCSequence * fBSeq = [CCSequence actions:
                          [CCRotateTo actionWithDuration:kMoveDuration1 angle:-3.2],
                          [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                          [CCRotateTo actionWithDuration:kMoveDuration3 angle:4.3],
                          [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                          nil];
    [flowerBody runAction:fBSeq];
    
    
    CCSequence * fHSeqPosition = [CCSequence actions:
                                  [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(-2.7, 1.5)],
                                  [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(2.7, -1.5)],
                                  [CCMoveBy actionWithDuration:kMoveDuration3 position:CGPointMake(4.2, 1.7)],
                                  [CCMoveBy actionWithDuration:kMoveDuration4 position:CGPointMake(-4.2, -1.7)],
                                  nil];
    
    CCSequence * fHSeqScale = [CCSequence actions:
                               [CCScaleTo actionWithDuration:kMoveDuration1 scale:1.0],
                               [CCScaleTo actionWithDuration:kMoveDuration2 scale:1.0],
                               [CCScaleTo actionWithDuration:kMoveDuration3 scaleX:1.01 scaleY:0.941],
                               [CCScaleTo actionWithDuration:kMoveDuration4 scale:1.0],
                               nil];
    
    CCSequence * fHSeqRotation = [CCSequence actions:
                                  [CCRotateTo actionWithDuration:kMoveDuration1 angle:-5.0],
                                  [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                                  [CCRotateTo actionWithDuration:kMoveDuration3 angle:8.0],
                                  [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
                                  nil];
    
    CCSpawn * fHSpawn = [CCSpawn actions:fHSeqPosition,fHSeqScale,fHSeqRotation, nil];
    [flowerHead runAction:fHSpawn];
    
    CCSequence * fEPosition = [CCSequence actions:
                               [CCMoveBy actionWithDuration:kMoveDuration1 position:CGPointMake(-2.3, 1.8)],
                               [CCMoveBy actionWithDuration:kMoveDuration2 position:CGPointMake(2.5, -1.1)],
                               [CCMoveBy actionWithDuration:kMoveDuration3 position:CGPointMake(4.9, 2.1)],
                               [CCMoveBy actionWithDuration:kMoveDuration4 position:CGPointMake(-5.1, -2.8)],
                               nil];
    
    CCSequence * fERotation = [CCSequence actions:
                               [CCRotateTo actionWithDuration:kMoveDuration1 angle:-5.0],
                               [CCRotateTo actionWithDuration:kMoveDuration2 angle:0.0],
                               [CCRotateTo actionWithDuration:kMoveDuration3 angle:8.0],
                               [CCRotateTo actionWithDuration:kMoveDuration4 angle:0.0],
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
