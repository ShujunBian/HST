//
//  P4Monster.h
//  hst_p4
//
//  Created by wxy325 on 1/18/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "CCNode.h"

@class MonsterEye;

typedef NS_ENUM(NSUInteger, P4MonsterType)
{
    P4MonsterTypeGreen = 0,
    P4MonsterTypeYellow,
    P4MonsterTypePurple,
    P4MonsterTypeBlue,
    P4MonsterTypeRed
};


@class CCSprite;

@interface P4Monster : CCNode

@property (assign, nonatomic) float waterPercentage;

@property (strong, nonatomic) MonsterEye* eye1;
@property (strong, nonatomic) MonsterEye* eye2;
@property (strong, nonatomic) CCSprite* body;

@property (strong, nonatomic) CCSprite* mask;

@property (assign, nonatomic) CGPoint prePosition;
@property (assign, nonatomic) ccColor3B waterColor;

@property (assign, nonatomic) BOOL isEmpty;
@property (assign, nonatomic) P4MonsterType type;

- (void)prePositionInit;
- (CGRect)getRect;

- (void)beginUpdateWater;
- (void)endUpdateWater;

- (void)startWaterDecrease;
- (void)startWaterFull;

- (void)configureMonsterEye;
@end
