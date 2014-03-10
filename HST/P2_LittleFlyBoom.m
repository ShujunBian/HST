//
//  LittleFlyBoom.m
//  jump
//
//  Created by Emerson on 13-9-3.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_LittleFlyBoom.h"

@implementation P2_LittleFlyBoom
@synthesize boom;
@synthesize tintColor;

- (void) didLoadFromCCB
{
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    boom.autoRemoveOnFinish = YES;
}

- (void)setTintColor:(ccColor3B)color
{
    tintColor = color;
    boom.startColor = ccc4f(tintColor.r / 255.0, tintColor.g / 255.0, tintColor.b / 255.0, 1);
    boom.endColor = ccc4f(tintColor.r / 255.0, tintColor.g / 255.0, tintColor.b / 255.0, 0.5);
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    [self removeFromParentAndCleanup:YES];
    [self release];
}



@end
