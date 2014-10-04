//
//  P2_TapIndicator.m
//  HST
//
//  Created by wxy325 on 10/4/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P2_TapIndicator.h"

@implementation P2_TapIndicator
- (void) didLoadFromCCB
{
    [self.label retain];
    [self.background retain];
}

- (void)hideWithAnimation:(BOOL)fAnimated
{
    _isShowed = NO;
    float duration = fAnimated? 0.3f : 0.f;
    [self.label runAction:[CCFadeOut actionWithDuration:duration]];
    [self.background runAction:[CCFadeOut actionWithDuration:duration]];
}
- (void)showWithAnimation:(BOOL)fAnimated
{
    _isShowed = YES;
    float duration = fAnimated? 0.3f : 0.f;
    [self.label runAction:[CCFadeIn actionWithDuration:duration]];
    [self.background runAction:[CCFadeIn actionWithDuration:duration]];
}

- (void)dealloc
{
    self.label = nil;
    self.background = nil;
    
    [super dealloc];
}
@end
