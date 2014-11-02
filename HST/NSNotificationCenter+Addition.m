//
//  NSNotificationCenter+Addition.m
//  Dig
//
//  Created by Emerson on 14-2-17.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "NSNotificationCenter+Addition.h"

#define kShouldReleaseRestBubble   @"ShouldReleaseRestBubble"
#define kBeginAnimationFinished    @"BeginAnimationFinished"
#define kShouldHideHelpUI          @"ShouldHideHelpUI"
#define kShouldShowNextPassage     @"ShowNextPassage"
#define kShouldRollToNextHole      @"ShouldRollToNextHole"
#define kShouldRotateNextBell      @"ShouldRotateNextBell"
@implementation NSNotificationCenter (Addition)

+ (void)postShouldReleseRestBubbleNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldReleaseRestBubble object:nil userInfo:nil];
}
+ (void)registerShouldReleseRestBubbleNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kShouldReleaseRestBubble
                 object:nil];
}

+ (void)postShouldShowNextPassageNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowNextPassage object:nil userInfo:nil];
}

+ (void)registerShouldShowNextPassageNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kShouldShowNextPassage
                 object:nil];
}

+ (void)postShouldRollToNextHoleNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldRollToNextHole object:nil userInfo:nil];
}

+ (void)registerShouldRollToNextHoleNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kShouldRollToNextHole
                 object:nil];
}

+ (void)postShouldRotateNextBellNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldRotateNextBell object:nil userInfo:nil];
}

+ (void)registShouldRotateNextBellNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kShouldRotateNextBell
                 object:nil];
}

+ (void)unregister:(id)target
{
    [[NSNotificationCenter defaultCenter] removeObserver:target];
}


@end
