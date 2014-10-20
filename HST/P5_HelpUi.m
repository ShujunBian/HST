//
//  P5_HelpUi.m
//  HST
//
//  Created by wxy325 on 10/21/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P5_HelpUi.h"

@interface P5_HelpUi ()
@property (strong, nonatomic) CCLayerColor* shadowLayer;
@property (strong, nonatomic) CCSprite* arrow;
@property (strong, nonatomic) CCLabelTTF* label1;
@property (strong, nonatomic) CCLabelTTF* label2_1;
@property (strong, nonatomic) CCLabelTTF* label2_2;

@end

@implementation P5_HelpUi
- (void)didLoadFromCCB
{
    [self.shadowLayer retain];
    [self.arrow retain];
    [self.label1 retain];
    [self.label2_1 retain];
    [self.label2_2 retain];
}

- (void)dealloc
{
    self.shadowLayer = nil;
    self.arrow = nil;
    self.label1 = nil;
    self.label2_1 = nil;
    self.label2_2 = nil;
    [super dealloc];
}


@end
