//
//  P4Monster.h
//  hst_p4
//
//  Created by wxy325 on 1/18/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "CCNode.h"

@class CCSprite;

@interface P4Monster : CCNode

@property (assign, nonatomic) float waterPercentage;

@property (strong, nonatomic) CCSprite* eye1;
@property (strong, nonatomic) CCSprite* eye2;
@property (strong, nonatomic) CCSprite* body;

@property (strong, nonatomic) CCSprite* mask;

@property (assign, nonatomic) CGPoint prePosition;
@property (assign, nonatomic) ccColor3B waterColor;

@property (nonatomic) BOOL isEmpty;

- (void)prePositionInit;
- (CGRect)getRect;

- (void)beginUpdateWater;
- (void)endUpdateWater;

- (void)startWaterDecrease;
- (void)startWaterFull;
@end
