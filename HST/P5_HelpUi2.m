//
//  P5_HelpUi2.m
//  HST
//
//  Created by wxy325 on 10/26/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P5_HelpUi2.h"

@interface P5_HelpUi2 ()

@property (strong, nonatomic) CCLabelTTF* label2_3;
@property (strong, nonatomic) CCLabelTTF* label2_4;
@property (strong, nonatomic) CCSprite* finger;
@property (strong, nonatomic) CCSprite* home1;
@property (strong, nonatomic) CCSprite* home2;
@property (strong, nonatomic) CCNode* home3;
@property (strong, nonatomic) CCSprite* home4;
@property (strong, nonatomic) CCSprite* home5;

@end

@implementation P5_HelpUi2
@synthesize label2_3 = _label2_3;
@synthesize label2_4 = _label2_4;
@synthesize finger = _finger;

- (void)didLoadFromCCB
{
    [self.label2_3 retain];
    [self.label2_4 retain];
    [self.finger retain];
    NSArray* nodeArray = @[self.home1,
                           self.home2,
                           self.home3,
                           self.home4,
                           self.home5];
    for (CCNodeRGBA* node in nodeArray) {
        node.visible = NO;
    }
    nodeArray = @[self.finger,
                  self.label2_3,
                  self.label2_4
                  ];
    for (CCNodeRGBA* node in nodeArray) {
        node.opacity = 0;
    }
}

- (void)dealloc
{
    self.label2_3 = nil;
    self.label2_4 = nil;
    self.finger = nil;
    [super dealloc];
}


- (void)showUi2
{
    NSArray* nodeArray = @[self.home1,
                           self.home2,
                           self.home3,
                           self.home4,
                           self.home5];
    for (CCNodeRGBA* node in nodeArray) {
        node.visible = YES;
    }
    nodeArray = @[self.label2_3,
                  self.label2_4,
                  self.finger];
    for (CCNodeRGBA* node in nodeArray) {
        [node runAction:[CCFadeTo actionWithDuration:0.3 opacity:255]];
    }
}
- (void)hideUi2
{

    [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.3] two:[CCCallBlock actionWithBlock:^{
        NSArray* nodeArray = @[self.home1,
                               self.home2,
                               self.home3,
                               self.home4,
                               self.home5];
        for (CCNodeRGBA* node in nodeArray) {
            node.visible = NO;
        }
    }]]];
    
    NSArray* nodeArray = @[self.label2_3,
                  self.label2_4,
                  self.finger];
    for (CCNodeRGBA* node in nodeArray) {
        [node runAction:[CCFadeTo actionWithDuration:0.3 opacity:0]];
    }
}
@end
