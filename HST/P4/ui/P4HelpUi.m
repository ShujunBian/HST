//
//  P4HelpUi.m
//  HST
//
//  Created by wxy325 on 10/4/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P4HelpUi.h"
#define ANIMATION_DURATION 0.3f


@implementation P4HelpUi

#pragma mark - Life Cycle
- (void)didLoadFromCCB
{
    [self.shadowLayer retain];
    [self.label1_1 retain];
    [self.label1_2 retain];
    [self.label2_1 retain];
    [self.label2_2 retain];
}

- (void)dealloc
{
    self.shadowLayer = nil;
    self.label1_1 = nil;
    self.label1_2 = nil;
    self.label2_1 = nil;
    self.label2_2 = nil;
    
    [super dealloc];
}

#pragma mark - Animation
- (void)showShadow:(BOOL)fShow withAnimation:(BOOL)fAnimated
{
    float duration = fAnimated? ANIMATION_DURATION : 0;
    GLubyte opacity = fShow? 204 : 0;
    [self.shadowLayer runAction:[CCFadeTo actionWithDuration:duration opacity:opacity]];
}

- (void)showHelpLabel:(BOOL)fShow helpLabelIndex:(int)helpNumber withAnimation:(BOOL)fAnimated
{
    CCLabelTTF* label1 = nil;
    CCLabelTTF* label2 = nil;
    
    if (helpNumber == 1)
    {
        label1 = self.label1_1;
        label2 = self.label1_2;
    }
    else
    {
        label1 = self.label2_1;
        label2 = self.label2_2;
    }
    
    float duration = fAnimated? ANIMATION_DURATION : 0;
    GLubyte opacity = fShow? 255 : 0;

    [label1 runAction:[CCFadeTo actionWithDuration:duration opacity:opacity]];
    [label2 runAction:[CCFadeTo actionWithDuration:duration opacity:opacity]];
}
- (void)hideAllUiWithAnimation:(BOOL)fAnimated
{
    float duration = fAnimated? ANIMATION_DURATION : 0;
    for (CCNode* node in @[self.label1_1, self.label1_2, self.label2_1, self.label2_2, self.shadowLayer]) {
        [node runAction:[CCFadeTo actionWithDuration:duration opacity:0]];
    }
}

@end
