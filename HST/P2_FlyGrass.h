//
//  FlyGrass.h
//  jump
//
//  Created by Emerson on 13-9-3.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"

@interface P2_FlyGrass : CCNode

@property (nonatomic, assign) CCSprite *grassLeft;
@property (nonatomic, assign) CCSprite *grassMiddle;
@property (nonatomic, assign) CCSprite *grassRight;

- (void)grassAnimationOne;
- (void)grassAnimationTwo;

@end
