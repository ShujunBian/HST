//
//  WorldP3Layer.m
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WorldP3Layer.h"

#import "P3_Monster.h"
#import "P3_MonsterBody.h"
#import "P3_BlueMonster.h"
#import "P3_PurpMonster.h"
#import "P3_GreenMonster.h"
#import "P3_RedMonster.h"
#import "P3_CeruleanMonster.h"

@interface WorldP3Layer ()

@property (nonatomic, strong) NSMutableArray * monsterArray;

@end

@implementation WorldP3Layer

@synthesize monsterLayer;

- (id)init
{
    if (self = [super init]) {
        [self schedule:@selector(monsterJumpDownAnimation) interval:1.75];
    }
    return self;
}

- (void)didLoadFromCCB
{
    self.monsterArray = [NSMutableArray arrayWithCapacity:5];
    [self initMonsters];
    [self.dialogIcon retain];
    [self shakeDialogIcon];
}
- (void)dealloc
{
    self.dialogIcon = nil;
    self.monsterArray = nil;
    [super dealloc];
}

#pragma mark - 初始化Monsters
- (void)initMonsters
{
    P3_PurpMonster * purpMonster = (P3_PurpMonster *)[CCBReader nodeGraphFromFile:@"P3_PurpMonster.ccbi"];
    [monsterLayer addChild:purpMonster z:0];
    [purpMonster createMonsterWithType:PurpMonster];
    [_monsterArray addObject:purpMonster];
    
    P3_BlueMonster * blueMonster = (P3_BlueMonster *)[CCBReader nodeGraphFromFile:@"P3_BlueMonster.ccbi"];
    [monsterLayer addChild:blueMonster z:-1];
    [blueMonster createMonsterWithType:BlueMonster];
    [_monsterArray addObject:blueMonster];
    
    P3_GreenMonster * greenMonster = (P3_GreenMonster *)[CCBReader nodeGraphFromFile:@"P3_GreenMonster.ccbi"];
    [monsterLayer addChild:greenMonster z:-2];
    [greenMonster createMonsterWithType:GreenMonster];
    [_monsterArray addObject:greenMonster];
    
    P3_RedMonster * redMonster = (P3_RedMonster *)[CCBReader nodeGraphFromFile:@"P3_RedMonster.ccbi"];
    [monsterLayer addChild:redMonster z:-1];
    [redMonster createMonsterWithType:RedMonster];
    [_monsterArray addObject:redMonster];
    
    P3_CeruleanMonster * ceruleanMonster = (P3_CeruleanMonster *)[CCBReader nodeGraphFromFile:@"P3_CeruleanMonster.ccbi"];
    [monsterLayer addChild:ceruleanMonster z:0];
    [ceruleanMonster createMonsterWithType:CeruleanMonster];
    [_monsterArray addObject:ceruleanMonster];
    
    for (int i = 0; i < [_monsterArray count]; ++ i) {
        P3_Monster * monster = (P3_Monster *)[_monsterArray objectAtIndex:i];
        [monster setPosition:monsterMainMapPositions[i]];
        monster.isInMainMap = YES;
        [monster initMonsterEyes];
        [monster setScale:0.35];
    }
}

- (void)monsterJumpDownAnimation
{
    for (P3_Monster * monster in _monsterArray) {
        if (CCRANDOM_0_1() > 0.5) {
            if (monster.isUp) {
                [monster jumpDownAnimationInMainMap];
            }
            else {
                [monster jumpUpAnimationInMainMap];
            }
        }

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
