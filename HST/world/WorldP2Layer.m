//
//  WorldP2Layer.m
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WorldP2Layer.h"
#import "P2_Monster.h"
#import "P2_LittleMonster.h"
#import "P2_Mushroom.h"
#import "P2_GameObjects.h"

@implementation WorldP2Layer

static ccColor3B littleFlyColors[] = {
    {255,229,55},//黄色
    {255,188,248},//紫色
    {91,222,255},//蓝色
    {111,255,141},//绿色
    {135,246,203},
    {151,255,28},
    {255,169,175},
    {255,200,33},
    {213,176,255}
};

@synthesize blueLittleFly;
@synthesize greenLittleFly;
@synthesize monster;
@synthesize purpLittleMonster;
@synthesize organeLittleMonster;
@synthesize rightTwoMushroom;

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void) didLoadFromCCB
{
    [blueLittleFly.body setColor:littleFlyColors[2]];
    [blueLittleFly.wing setColor:littleFlyColors[2]];
    blueLittleFly.isInMainMap = YES;
    
    [greenLittleFly.body setColor:littleFlyColors[3]];
    [greenLittleFly.wing setColor:littleFlyColors[3]];
    greenLittleFly.isInMainMap = YES;
    
    rightTwoMushroom.isInMainMap = YES;
    monster.isInMainMap = YES;
    
    CCBAnimationManager* animationManager = monster.userObject;
    [animationManager runAnimationsForSequenceNamed:@"LittleJump"];
    
    [self letFirstLittleMonsterJump];
    [self letSecondLittleMonsterJump];
}

- (void)letFirstLittleMonsterJump
{
    CCBAnimationManager* firanimationManager = purpLittleMonster.userObject;
    firanimationManager.delegate = purpLittleMonster;
    [firanimationManager runAnimationsForSequenceNamed:@"LittleJump"];
}

- (void)letSecondLittleMonsterJump
{
    CCBAnimationManager* secanimationManager = organeLittleMonster.userObject;
    secanimationManager.delegate = organeLittleMonster;
    [secanimationManager runAnimationsForSequenceNamed:@"LittleJump"];
}

@end
