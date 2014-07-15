//
//  P3_MonsterEye.m
//  HST
//
//  Created by Emerson on 14-7-11.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P3_MonsterEye.h"

@implementation P3_MonsterEye

- (instancetype)init
{
    if (self = [super init]) {
        self.monsterEyeSprites = [NSMutableArray arrayWithCapacity:4];
        self.monsterEyePositions = [NSMutableArray arrayWithCapacity:4];
        self.monsterEyeBlackSprites = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

@end
