//
//  redMonster.m
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P3_RedMonster.h"

@implementation P3_RedMonster

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)createMonsterWithType:(MonsterType)monsterType
{
    [super createMonsterWithType:monsterType];
    
    for (int i = 0; i < monsterEyeCounters[monsterType]; ++ i) {
        [self.monsterEye.monsterEyePositions addObject:
         [NSValue valueWithCGPoint:monsterRedEyePos[i]]];
    }
}

- (void)initMonsterEyes
{
    [super initMonsterEyes];
}

- (void)jumpBackToPointByMonsterType:(MonsterType)monsterType
{
    [super jumpBackToPointByMonsterType:monsterType];
}

@end
