//
//  P1_BlowUI.h
//  HST
//
//  Created by wxy325 on 8/26/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"

@interface P1_BlowUI : CCNode

@property (assign, nonatomic) CCSprite* background;
@property (assign, nonatomic) CCLabelTTF* label1;
@property (assign, nonatomic) CCLabelTTF* label2;

- (GLubyte)opacity;
- (void) setOpacity:(GLubyte)opacity;
- (void)updateOrientation:(UIInterfaceOrientation)orientation;
@end
