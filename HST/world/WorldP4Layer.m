//
//  WorldP4Layer.m
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WorldP4Layer.h"
#import "P4Monster.h"
#import "P4Bottle.h"

@interface WorldP4Layer ()

@property (strong, nonatomic) CCArray* monstersArray;

@end

@implementation WorldP4Layer

- (void)didLoadFromCCB
{
    [self.dialogIcon retain];
    [self.greenMonster retain];
    [self.yellowMonster retain];
    [self.purpleMonster retain];
    [self.blueMonster retain];
    [self.redMonster retain];
    [self.bottle retain];
    
    
    //Monster Init
    self.monstersArray = [[[CCArray alloc] init] autorelease];
    
    //设置monsters数组
    [self.monstersArray addObject:self.greenMonster];
    [self.monstersArray addObject:self.yellowMonster];
    [self.monstersArray addObject:self.purpleMonster];
    [self.monstersArray addObject:self.blueMonster];
    [self.monstersArray addObject:self.redMonster];
    
    //设置monster type
    for (int i = 0; i < self.monstersArray.count; i++)
    {
        P4Monster* monster = [self.monstersArray objectAtIndex:i];
        monster.type = (P4MonsterType)i;
    }
    
    for (P4Monster* monster in self.monstersArray)
    {
        [monster prePositionInit];
    }
    self.greenMonster.waterColor = ccc3(68.f, 255.f, 25.f);
    self.yellowMonster.waterColor = ccc3(255.f, 252.f, 62.f);
    self.purpleMonster.waterColor = ccc3(255.f, 97.f, 242.f);
    self.blueMonster.waterColor = ccc3(50.f, 248.f, 255.f);
    self.redMonster.waterColor = ccc3(254.f, 70.f, 100.f);
    
    //罐子浮动
    float moveLength = 2.f;
    float moveDuration = 0.5f;
    CCMoveBy* moveBy1 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCMoveBy* moveBy2 = [CCMoveBy actionWithDuration:moveDuration * 2 position:ccp(0, moveLength * 2)];
    CCMoveBy* moveBy3 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCSequence* moveSequence =
    [CCSequence actions:
     [CCEaseSineOut actionWithAction:moveBy1],
     [CCEaseSineInOut actionWithAction:moveBy2],
     [CCEaseSineIn actionWithAction:moveBy3],
     nil];
    CCRepeatForever* moveRepeat = [CCRepeatForever actionWithAction:moveSequence];
    [self.bottle runAction:moveRepeat];

    
    [self shakeDialogIcon];
}
- (void)onEnter
{
    [super onEnter];
    [self.bottle worldSceneConfigure];
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

- (void)dealloc
{
    self.dialogIcon = nil;
    self.greenMonster = nil;
    self.yellowMonster = nil;
    self.purpleMonster = nil;
    self.blueMonster = nil;
    self.redMonster = nil;
    [self.monstersArray removeAllObjects];
    self.monstersArray = nil;
    self.bottle = nil;
    [super dealloc];
}
@end
