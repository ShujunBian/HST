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
        
    }
    return self;
}

- (void)didLoadFromCCB
{
    
}

- (void)jumpBeforeStart
{
    [self moveToUndergroundBackAction];
    [self coverTheLeg];
    CCMoveBy * moveUp = [CCMoveBy actionWithDuration:2.0 / 6.0 position:CGPointMake(0.0, 25)];
    CCMoveBy * moveDown = [CCMoveBy actionWithDuration:3.0 / 6.0 position:CGPointMake(0.0, -63.0)];
    CCSequence * seq = [CCSequence actions:moveUp,moveDown, nil];
    [self runAction:seq];
}

@end
