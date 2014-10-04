//
//  P2_TapIndicator.h
//  HST
//
//  Created by wxy325 on 10/4/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCNode.h"

@interface P2_TapIndicator : CCNode

@property (strong, nonatomic) CCLabelTTF* label;
@property (strong, nonatomic) CCSprite* background;
@property (readonly, nonatomic) BOOL isShowed;

- (void)showWithAnimation:(BOOL)fAnimated;
- (void)hideWithAnimation:(BOOL)fAnimated;

@end
