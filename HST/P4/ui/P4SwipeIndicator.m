//
//  P4SwipeIndicator.m
//  HST
//
//  Created by wxy325 on 10/4/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P4SwipeIndicator.h"

#define ANIMATION_DURATION 0.3f
#define FINGER_MOVE_DURATION 0.6f
#define FINGER_MOVE_X 20.f
@interface P4SwipeIndicator ()
@property (assign, nonatomic) CGPoint fingerPrePosition;

@end

@implementation P4SwipeIndicator

#pragma mark - Life Cycle
- (void)didLoadFromCCB
{
    [self.background retain];
    [self.fingerImage retain];
    [self.label retain];
    self.fingerPrePosition = self.fingerImage.position;
}

- (void)dealloc
{
    self.background = nil;
    self.fingerImage = nil;
    self.label = nil;
    
    [super dealloc];
}

#pragma mark - Animation
- (void)showWithAnimation:(BOOL)fAnimated
{
    [self beginFingerSwipe];
    float duration = fAnimated? ANIMATION_DURATION : 0;
    for (CCNode* node in @[self.background, self.fingerImage, self.label]) {
        [node runAction:[CCFadeTo actionWithDuration:duration opacity:255]];
    }
}

- (void)hideWithAnimation:(BOOL)fAnimated
{
    [self endFingerSwipe];
    float duration = fAnimated? ANIMATION_DURATION : 0;
    
    for (CCNode* node in @[self.background, self.fingerImage, self.label]) {
        [node runAction:[CCFadeTo actionWithDuration:duration opacity:0]];
    }
}

- (void)beginFingerSwipe
{
    CCActionInterval* swipeFinger =
    [CCRepeatForever actionWithAction:
     [CCSequence actions:
      [CCEaseSineOut actionWithAction:[CCMoveBy actionWithDuration:FINGER_MOVE_DURATION position:ccp(FINGER_MOVE_X, 0)]],
      [CCEaseSineInOut actionWithAction:[CCMoveBy actionWithDuration:FINGER_MOVE_DURATION * 2 position:ccp(- 2 * FINGER_MOVE_X, 0)]],
      [CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:FINGER_MOVE_DURATION position:ccp(FINGER_MOVE_X, 0)]],
      nil]];
    [self.fingerImage runAction:swipeFinger];
}
- (void)endFingerSwipe
{
    [self.fingerImage stopAllActions];
    if (ABS(self.fingerPrePosition.x) > 0.001 || ABS(self.fingerPrePosition.y) > 0.001 )
    {
        self.fingerImage.position = self.fingerPrePosition;
    }
}

@end
