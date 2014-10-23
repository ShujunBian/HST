//
//  P3_HelpUi.m
//  HST
//
//  Created by wxy325 on 10/23/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P3_HelpUi.h"
#import "cocos2d.h"

#define ANIMATION_DURATION 0.3f
#define FINGER_MOVE_DURATION 0.6f
#define FINGER_MOVE_Y 20.f

@interface P3_HelpUi ()

@property (assign, nonatomic) CGPoint fingerPrePosition;

@end

@implementation P3_HelpUi
- (void)didLoadFromCCB
{
    [self.fingerIcon retain];
//    [self.shadowLayer retain];
    [self.label1 retain];
    [self.label2 retain];
    self.fingerPrePosition = self.fingerIcon.position;
}

- (void)startAnimation
{
    CCActionInterval* swipeFinger =
    [CCRepeatForever actionWithAction:
     [CCSequence actions:
      [CCEaseSineOut actionWithAction:[CCMoveBy actionWithDuration:FINGER_MOVE_DURATION position:ccp(0, FINGER_MOVE_Y)]],
      [CCEaseSineInOut actionWithAction:[CCMoveBy actionWithDuration:FINGER_MOVE_DURATION * 2 position:ccp(0, - 2 * FINGER_MOVE_Y)]],
      [CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:FINGER_MOVE_DURATION position:ccp(0, FINGER_MOVE_Y)]],
      nil]];
    [self.fingerIcon runAction:swipeFinger];
}

- (void)endAnimation
{
    [self.fingerIcon stopAllActions];
    if (ABS(self.fingerPrePosition.x) > 0.001 || ABS(self.fingerPrePosition.y) > 0.001 )
    {
        self.fingerIcon.position = self.fingerPrePosition;
    }
}

- (void)dealloc
{
    self.fingerIcon = nil;
//    self.shadowLayer = nil;
    self.label1 = nil;
    self.label2 = nil;
    [super dealloc];
}
@end
