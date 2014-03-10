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

- (void) didLoadFromCCB
{
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    [self scheduleUpdate];
}

- (void)update:(ccTime)delta
{
    self.position = CGPointMake(self.position.x - 1024.0 / 8.0 * EVERYDELTATIME, self.position.y);
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    [self removeFromParentAndCleanup:YES];
    [self release];
}

@end
