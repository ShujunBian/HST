//
//  BubbleBomb.m
//  town
//
//  Created by Song on 13-8-4.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P1_BubbleBomb.h"


@implementation P1_BubbleBomb

- (void) didLoadFromCCB
{
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

- (void)setTintColor:(ccColor3B)tintColor
{
    _tintColor = tintColor;
    self.ps.startColor = ccc4f(self.tintColor.r / 255.0, self.tintColor.g / 255.0, self.tintColor.b / 255.0, 1);
    self.ps.endColor = ccc4f(self.tintColor.r / 255.0, self.tintColor.g / 255.0, self.tintColor.b / 255.0, 0.0);
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
    [self.delegate removeBubbleFromParent];
    
    [self removeFromParentAndCleanup:YES];
    [self release];
}

@end
