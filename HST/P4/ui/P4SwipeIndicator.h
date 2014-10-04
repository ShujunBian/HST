//
//  P4SwipeIndicator.h
//  HST
//
//  Created by wxy325 on 10/4/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCNode.h"

@interface P4SwipeIndicator : CCNode

@property (strong, nonatomic) CCSprite* background;
@property (strong, nonatomic) CCSprite* fingerImage;
@property (strong, nonatomic) CCLabelTTF* label;

- (void)showWithAnimation:(BOOL)fAnimated;
- (void)hideWithAnimation:(BOOL)fAnimated;
@end
