//
//  blueMonster.m
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P3_BlueMonster.h"

@implementation P3_BlueMonster

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
         [NSValue valueWithCGPoint:monsterBlueEyePos[i]]];
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
