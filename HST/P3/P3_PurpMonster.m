//
//  purpMonster.m
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright 2014年 Emerson. All rights reserved.
//

#import "P3_PurpMonster.h"

@implementation P3_PurpMonster

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
         [NSValue valueWithCGPoint:monsterPurpEyePos[i]]];
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

//- (void)createMonsterBodyInPosition:(CGPoint)position
//               ByMonsterBodyCounter:(int)monsterBodyCounter
//                     andMonsterType:(MonsterType)monsterType
//{
//    [super createMonsterBodyInPosition:position
//                  ByMonsterBodyCounter:monsterBodyCounter
//                        andMonsterType:monsterType];
//}

@end
