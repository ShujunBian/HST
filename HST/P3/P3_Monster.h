//
//  P3_Monster1.h
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright 2014年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBReader.h"
#import "CCBAnimationManager.h"
#import "P3_MonsterEye.h"

typedef enum {
    PurpMonster = 0,
    BlueMonster,
    GreenMonster,
    RedMonster,
    CeruleanMonster
} MonsterType;

static int monsterEyeCounters[] = {
    2,
    3,
    1,
    2,
    2
};

static float monsterFaceHeight[] = {
    190.0,
    173.0,
    226.0,
    189.0,
    156.0
};

//小怪物初始位置
static CGPoint monsterFirstPositions[] = {
    {157.0,46.0},          //最左边小怪物初始位置
    {324.0,46.0},          //从左边开始计算第二个
    {526.0,46.0},          //第三个
    {733.0,46.0},          //第四个
    {858.0,46.0}           //第五个
    //小怪物第一个和第五个Z轴最浅
    //第二个和第四个次之     第三个最Z轴最深
};

static float monsterBodyHeight [] = {
    103.0,
    109.5,
    1.0,//任意值
    110.0,
    97.0
};

static CGPoint monsterPurpEyePos[] = {
    {72.0,96.0},            //最左边小怪物两个眼睛的位置
    {72.0,58.0}             //分别上下各一个眼睛
};

static CGPoint monsterBlueEyePos[] = {
    {65.0,66.0},
    {100.0,66.0},
    {134.0,66.0}
};

static CGPoint monsterGreenEyePos[] = {
    {149.0,117.0}
};

static CGPoint monsterRedEyePos[] = {
    {55.0,53.0},
    {123.0,53.}
};

static CGPoint monsterCeruleanEyePos[] = {
    {51.0,46.0},
    {107.0,46.0}
};

@interface P3_Monster : CCNode

@property (nonatomic) MonsterType monsterType;
@property (nonatomic) BOOL isChoosen;                   //用于记录是否正在拖动
@property (nonatomic) BOOL isMovingUp;                  //记录小怪物是向上移动还是向下移动 一次只能一个方向
@property (nonatomic) BOOL isStartMoving;               //记录是否第一次移动 以确定方向
@property (nonatomic) CGPoint oldTouchPosition;         //用来记录上一次touch之后的位置和新的touch位置计算差之后移动小怪物
@property (nonatomic) int monsterBodyCounter;           //记录现有monsterbody的个数
@property (nonatomic) BOOL isJumping;                   //正在弹跳动画中

@property (nonatomic, assign) CCSprite * monsterBody;
@property (nonatomic, assign) CCSprite * monsterMouth;

@property (nonatomic, strong) P3_MonsterEye * monsterEye;
@property (nonatomic, strong) NSMutableArray * monsterBodyArray;

- (void)createMonsterWithType:(MonsterType)monsterType;
- (void)initMonsterEyes;
- (void)jumpBackToPointByMonsterType:(MonsterType)monsterType;
- (void)createMonsterBodyInPosition:(CGPoint)position
               ByMonsterBodyCounter:(int)monsterBodyCounter
                     andMonsterType:(MonsterType)monsterType;

- (void)monsterBodyJumpAnimation:(CCSprite *)body
                     BodyCounter:(int)monsterBodyCounter
                     monsterType:(MonsterType)monsterType;
@end
