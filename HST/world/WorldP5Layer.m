//
//  WorldP5Layer.m
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WorldP5Layer.h"
#import "P5_Monster.h"
#import "CCBReader.h"

@implementation WorldP5Layer

- (id)init
{
    if (self = [super init]) {
        self.monster = (P5_Monster *)[CCBReader nodeGraphFromFile:@"P5_Monster.ccbi"];
        [self.monster setPosition:CGPointMake(817.0, 504.0)];
        [self.monster setScale:0.8];
        self.monster.isUpground = YES;
        self.monster.isInMainMap = YES;
        [self addChild:self.monster z:-1];
        
        CCSprite * holl = [CCSprite spriteWithFile:@"world_p5_holl.png"];
        [holl setPosition:CGPointMake(904.0, 515.0)];
        [self addChild:holl z:-2];
        [self schedule:@selector(monsterJump) interval:3.0];
    }
    return self;
}

- (void)didLoadFromCCB
{

    [self.dialogIcon retain];
    [self shakeDialogIcon];
}

- (void)dealloc
{
    self.monster = nil;
    self.dialogIcon = nil;
    [super dealloc];
}

- (void)monsterJump
{
    
    if (CCRANDOM_0_1() > 0.5) {
//        [self removeChild:self.monster];
//        self.monster = nil;
//        
//        self.monster = (P5_Monster *)[CCBReader nodeGraphFromFile:@"P5_Monster.ccbi"];
//        [self.monster setPosition:CGPointMake(817.0, 504.0)];
//        [self.monster setScale:0.8];
//        self.monster.isUpground = YES;
//        self.monster.isInMainMap = YES;
//        [self addChild:self.monster z:-1];
        
        [self.monster jumpInMainMap];
    }
}

- (void)shakeDialogIcon
{
    float moveLength = 2.f;
    float moveDuration = 0.5f;
    CCMoveBy* moveBy1 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCMoveBy* moveBy2 = [CCMoveBy actionWithDuration:moveDuration * 2 position:ccp(0, moveLength * 2)];
    CCMoveBy* moveBy3 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCSequence* moveSequence =
    [CCSequence actions:
     [CCDelayTime actionWithDuration:CCRANDOM_0_1() * 0.5],
     [CCEaseSineOut actionWithAction:moveBy1],
     [CCEaseSineInOut actionWithAction:moveBy2],
     [CCEaseSineIn actionWithAction:moveBy3],
     nil];
    CCRepeatForever* moveRepeat = [CCRepeatForever actionWithAction:moveSequence];
    [self.dialogIcon runAction:moveRepeat];
}
@end
