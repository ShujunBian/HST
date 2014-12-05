//
//  P3_Bell.m
//  HST
//
//  Created by Emerson on 14-12-5.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P3_Bell.h"

@implementation P3_Bell

@synthesize bellBody;
@synthesize bellHead;

- (void) didLoadFromCCB
{
    [bellBody setRotation:8.0];
    [bellHead setRotation:10.0];
    
    [self bellBodyAnimation];
    [self bellHeadAnimation];
}

- (void)bellBodyAnimation
{
    CCSequence * bBRotationSeq = [CCSequence actions:
                                  [CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:1.0 angle:-8.0] rate:2.0],
                                  [CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:1.0 angle:8.0] rate:2.0],
                                  nil];
    CCRepeatForever * bBRotationForever = [CCRepeatForever actionWithAction:bBRotationSeq];
    [bellBody runAction:bBRotationForever];
}

- (void)bellHeadAnimation
{
    CCSequence * bHRotationSeq = [CCSequence actions:
                                  [CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:1.0 angle:-30.0] rate:2.0],
                                  [CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:1.0 angle:10.0] rate:2.0],
                                  nil];
    CCSequence * bHPositionSeq = [CCSequence actions:
                                  [CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:1.0 position:CGPointMake(20.0, -2.0)] rate:2.0],
                                  [CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:1.0 position:CGPointMake(-20.0, 2.0)] rate:2.0],
                                  nil];
    CCSpawn * bHAnimation = [CCSpawn actions:bHRotationSeq,bHPositionSeq, nil];
    CCRepeatForever * bHAnimationForever = [CCRepeatForever actionWithAction:bHAnimation];
    CCSequence * seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.1],
                        [CCCallBlock actionWithBlock:^{
        [bellHead runAction:bHAnimationForever];
    }],
                        nil];
    [self runAction:seq];
    
}

@end
