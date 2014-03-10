//
//  P5_UndergroundPassage.h
//  Dig
//
//  Created by Emerson on 2/2/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"

@interface P5_UndergroundPassage : CCNode

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic, strong) CCSprite * passage;

- (void)calculateForPassage;
- (void)showPassages;

@end
