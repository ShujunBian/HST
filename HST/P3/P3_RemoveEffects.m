//
//  P3_RemoveEffects.m
//  sing
//
//  Created by pursue_finky on 14-3-15.
//  Copyright (c) 2014年 mhc. All rights reserved.
//

#import "P3_RemoveEffects.h"

@implementation P3_RemoveEffects

- (void) didLoadFromCCB
{
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

- (void)setTintColor:(ccColor3B)tintColor
{
    _tintColor = tintColor;
    self.startColor = ccc4f(self.tintColor.r / 255.0, self.tintColor.g / 255.0, self.tintColor.b / 255.0, 1);
    self.endColor = ccc4f(self.tintColor.r / 255.0, self.tintColor.g / 255.0, self.tintColor.b / 255.0, 0.0);
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    [self removeFromParentAndCleanup:YES];
}

@end
