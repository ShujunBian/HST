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
@property (strong, nonatomic) CCSprite* arrow2;
@property (strong, nonatomic) CCLabelTTF* label3;
@property (strong, nonatomic) CCSprite* hole;
@property (strong, nonatomic) CCNode* monster;


@end

@implementation P5_HelpUi
- (void)didLoadFromCCB
{
    [self.shadowLayer retain];
    [self.arrow retain];
    [self.label1 retain];
    [self.label2_1 retain];
    [self.label2_2 retain];
    [self.hole retain];
    
    NSArray* nodeArray = @[self.shadowLayer,
                           self.arrow,
                           self.label1,
                           self.label2_1,
                           self.label2_2,
                           self.hole,
//                           self.monster,
                           self.label3,
                           self.arrow2];
    for (CCNodeRGBA* node in nodeArray) {
        node.opacity = 0;
    }
    self.monster.visible = NO;
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

- (void)showShadowLayer
{
    [self.shadowLayer runAction:[CCFadeTo actionWithDuration:0.3f opacity:191]];
}
- (void)hideShadowLayer
{
    [self.shadowLayer runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];
}
- (void)showUi1
{

    NSArray* nodeArray = @[self.arrow,
                           self.label1];
    for (CCNodeRGBA* node in nodeArray) {
        [node runAction:[CCFadeTo actionWithDuration:0.3 opacity:255]];
    }

}
- (void)hideUi1
{
    NSArray* nodeArray = @[self.arrow,
                           self.label1];
    for (CCNodeRGBA* node in nodeArray) {
        [node runAction:[CCFadeTo actionWithDuration:0.3 opacity:0]];
    }

}
- (void)showUi2
{
    self.hole.opacity = 255;
    self.monster.visible = YES;
    
    NSArray* nodeArray = @[self.label2_1,
                           self.label2_2];
    for (CCNodeRGBA* node in nodeArray) {
        [node runAction:[CCFadeTo actionWithDuration:0.3 opacity:255]];
    }
}
- (void)hideUi2
{
    [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.3] two:[CCCallBlock actionWithBlock:^{
        self.hole.opacity = 0;
        self.monster.visible = NO;
    }]]];

    NSArray* nodeArray = @[self.label2_1,
                           self.label2_2];
    for (CCNodeRGBA* node in nodeArray) {
        [node runAction:[CCFadeTo actionWithDuration:0.3 opacity:0]];
    }
}

- (void)showUi3
{
    NSArray* nodeArray = @[self.label3,
                           self.arrow2];
    for (CCNodeRGBA* node in nodeArray) {
        [node runAction:[CCFadeTo actionWithDuration:0.3 opacity:255]];
    }
}

- (void)hideUi3
{
    NSArray* nodeArray = @[self.label3,
                           self.arrow2];
    for (CCNodeRGBA* node in nodeArray) {
        [node runAction:[CCFadeTo actionWithDuration:0.3 opacity:0]];
    }
}
@end
