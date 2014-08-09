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
    [self setBodyColor:littleFlyColors[2] withSprite:blueLittleFly];
    blueLittleFly.isInMainMap = YES;
    
    [self setBodyColor:littleFlyColors[3] withSprite:greenLittleFly];
    greenLittleFly.isInMainMap = YES;
    
    rightTwoMushroom.isInMainMap = YES;
    monster.isInMainMap = YES;
    
    CCBAnimationManager* animationManager = monster.userObject;
    [animationManager runAnimationsForSequenceNamed:@"LittleJump"];
    
    [self letFirstLittleMonsterJump];
    [self letSecondLittleMonsterJump];
    
    [self.dialogIcon retain];
    [self shakeDialogIcon];
}

- (void)onExit
{
    [super onExit];
    CCBAnimationManager* firanimationManager = purpLittleMonster.userObject;
    firanimationManager.delegate = nil;
    CCBAnimationManager* secanimationManager = organeLittleMonster.userObject;
    secanimationManager.delegate = nil;
    self.dialogIcon = nil;
}

- (void)dealloc
{

    
    [super dealloc];
}


- (void)setBodyColor:(ccColor3B)color
          withSprite:(P2_LittleFlyObjects *)sprite
{
    sprite.body.color = color;
    ccColor3B wingColor;
    wingColor.r = color.r + 30 > 255 ? 255 : color.r + 30;
    wingColor.g = color.g + 30 > 255 ? 255 : color.g + 30;
    wingColor.b = color.b + 30 > 255 ? 255 : color.b + 30;
    sprite.wing.color = wingColor;
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
