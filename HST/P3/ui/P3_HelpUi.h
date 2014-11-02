//
//  P3_HelpUi.h
//  HST
//
//  Created by wxy325 on 10/23/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"
@class CCSprite;
@class CCLayerColor;
@class CCLabelTTF;

static CGPoint helpUIIconPosition[] = {
    {130.0,125.0},
    {130.0,225.0},
    {130.0,325.0},
    {130.0,425.0},
    {130.0,525.0}
};

static CGPoint helpUILabel1Position[] = {
    {292.0,176.0},
    {292.0,276.0},
    {292.0,376.0},
    {292.0,476.0},
    {292.0,576.0}

};

static CGPoint helpUILabel2Position[] = {
    {540.0,176.0},
    {540.0,276.0},
    {540.0,376.0},
    {540.0,476.0},
    {540.0,576.0}
};

@interface P3_HelpUi : CCLayer

@property (strong, nonatomic) CCSprite* fingerIcon;
//@property (strong, nonatomic) CCLayerColor* shadowLayer;
@property (strong, nonatomic) CCLabelTTF* label1;
@property (strong, nonatomic) CCLabelTTF* label2;

- (void)startAnimation;
- (void)endAnimation;
- (void)fadeOut:(BOOL)fAnimate;
- (void)fadeIn:(BOOL)fAnimate;
- (void)resetHelpUIPosition:(int)monsterBodyCount;

@end
