//
//  WorldP5Layer.m
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WorldP5Layer.h"
#import "P5_Monster.h"

@implementation WorldP5Layer

@synthesize monster;

- (id)init
{
    if (self = [super init]) {
        [self schedule:@selector(monsterJump) interval:3.0];
    }
    return self;
}

- (void)didLoadFromCCB
{
    monster.isUpground = YES;
    monster.isInMainMap = YES;
}

- (void)monsterJump
{
    if (CCRANDOM_0_1() > 0.5) {
        [monster jumpInMainMap];
//        [self performSelector:@selector(addGrassParticle) withObject:nil afterDelay:5.0 / 6.0 + 0.5];
    }
}

- (void)addGrassParticle
{
    CCParticleSystem * grassOut = [CCParticleSystemQuad particleWithFile:@"P3_GrassPSQ.plist"];
    grassOut.position = CGPointMake(819.0, 448.0);
    grassOut.autoRemoveOnFinish = YES;
    [grassOut setScale:0.35];
    [self addChild:grassOut z:-1];
}

@end
