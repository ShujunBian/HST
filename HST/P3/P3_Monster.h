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

#define kMonsterBaselineYPosition        46.0
#define kMonsterMainMapBaselineYPosition 191.0

typedef enum {
    PurpMonster = 0,
    BlueMonster,
    GreenMonster,
    RedMonster,
    CeruleanMonster
} MonsterType;

typedef enum {
    MovingStay = 0,
    MovingUp,
    MovingDown
} MonsterMovingType;

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
    {157.0,46.0 - 190.0},          //最左边小怪物初始位置
    {324.0,46.0 - 173.0},          //从左边开始计算第二个
    {530.0,46.0 - 226.0},          //第三个
    {733.0,46.0 - 189.0},          //第四个
    {858.0,46.0 - 156.0}           //第五个
    //小怪物第一个和第五个Z轴最浅
    //第二个和第四个次之     第三个最Z轴最深
};

//小怪物大地图初始位置
static CGPoint monsterMainMapPositions[] = {
    {408.0,191.0},          //最左边小怪物初始位置
    {467.0,191.0},          //从左边开始计算第二个
    {542.0,191.0},          //第三个
    {613.0,191.0},          //第四个
    {658.0,191.0}           //第五个
};

static ccColor3B monsterFaceColor[5][5] = {
    {{255,145,248},{255,126,247},
        {255,111,246},{255,94,245},{246,81,236}},  //紫色
    {{76,211,255},{52,205,255},
        {20,197,255},{0,192,255},{23,182,234}},//蓝色
    {{84,249,46},{255,255,255},
        {255,255,255},{255,255,255},{255,255,255}},    //绿色
    {{255,70,100},{255,54,87},
        {255,31,68},{255,9,50},{255,0,43}},   //红色
    {{29,255,247},{0,246,237},
        {45,238,231},{23,233,226},{26,227,220}}   //天蓝色
};

static float monsterBodyHeight [] = {
    100.0,
    106.5,
    1.0,//任意值
    107.0,
    94.0
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

static int zOrder[]= {
    0,
    -1,
    -2,
    -1,
    0
};

@protocol P3_MonsterDelegate <NSObject>

@optional

- (void)monsterWithMonsterType:(MonsterType) monsterType
           DragginChangedLevel:(int)draggingLevel;

@end

@interface P3_Monster : CCNode

@property (nonatomic) MonsterType monsterType;
@property (nonatomic) BOOL isChoosen;                   //用于记录是否正在拖动
@property (nonatomic) MonsterMovingType movingType;
@property (nonatomic) BOOL isStartMoving;               //记录是否第一次移动 以确定方向
@property (nonatomic) CGPoint oldTouchPosition;         //用来记录上一次touch之后的位置和新的touch位置计算差之后移动小怪物
@property (nonatomic) int monsterBodyCounter;           //记录现有monsterbody的个数
@property (nonatomic) int isBeginAnimationFinished;     

@property (nonatomic) BOOL isNeedAutoMoving;

@property (nonatomic, assign) CCSprite * monsterBody;
@property (nonatomic, assign) CCSprite * monsterMouth;

@property (nonatomic, strong) P3_MonsterEye * monsterEye;
@property (nonatomic, strong) NSMutableArray * monsterBodyArray;

@property (nonatomic, assign) id<P3_MonsterDelegate> delegate;
//大地图中所用参数
@property (nonatomic) BOOL isInMainMap;
@property (nonatomic) BOOL isUp;

- (void)createMonsterWithType:(MonsterType)monsterType;
- (void)initMonsterEyes;
- (void)createMonsterBodyInPosition:(CGPoint)position
                     andMonsterType:(MonsterType)monsterType;
- (void)beginningAnimationInDelayTime:(float)delayTime;

- (void)jumpUpAnimationInMainMap;
- (void)jumpDownAnimationInMainMap;
@end
