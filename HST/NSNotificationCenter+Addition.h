//
//  NSNotificationCenter+Addition.h
//  Dig
//
//  Created by Emerson on 14-2-17.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (Addition)

+ (void)postShouldShowNextPassageNotification;
+ (void)registerShouldShowNextPassageNotificationWithSelector:(SEL)aSelector target:(id)aTarget;

+ (void)postShouldRollToNextHoleNotification;
+ (void)registerShouldRollToNextHoleNotificationWithSelector:(SEL)aSelector target:(id)aTarget;

+ (void)postShouldRotateNextBellNotification;
+ (void)registShouldRotateNextBellNotificationWithSelector:(SEL)aSelector target:(id)aTarget;

+ (void)unregister:(id)target;

@end
