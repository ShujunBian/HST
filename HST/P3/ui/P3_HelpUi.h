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
@interface P3_HelpUi : CCLayer

@property (strong, nonatomic) CCSprite* fingerIcon;
//@property (strong, nonatomic) CCLayerColor* shadowLayer;
@property (strong, nonatomic) CCLabelTTF* label1;
@property (strong, nonatomic) CCLabelTTF* label2;



- (void)startAnimation;
- (void)endAnimation;
@end
