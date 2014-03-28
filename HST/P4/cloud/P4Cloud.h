//
//  P4CloudTop.h
//  hst_p4
//
//  Created by wxy325 on 1/17/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "CCNode.h"
#import "CCSprite.h"

@interface P4Cloud : CCNode

@property (strong, nonatomic) CCSprite* leftCloudSprite;
@property (strong, nonatomic) CCSprite* rightCloudSprite;

- (void)startAnimationWithDuration:(float)duration;

@end
