//
//  P5_Bell.m
//  Dig
//
//  Created by Emerson on 14-1-26.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P5_Bell.h"
#import "P5_UndergroundScene.h"

#define kBellNormalModePerTime   0.5
#define kBellQuickModePerTime    0.1
#define kBellQuickModeTotalTime  1.2
#define ARC4RANDOM_MAX 0x100000000

@implementation P5_Bell
{
    CGPoint bellBodyBeginPosition;
    CGPoint bellMouthBeginPosition;
    CGPoint bellEyeBeginPosition;
    CGPoint bellHeadBeginPosition;
}

@synthesize bellBody;
@synthesize bellEye;
@synthesize bellHead;
@synthesize bellMouth;

static ccColor3B bellColors[] = {
    {0,0,0},            //
    {255,115,115},      //红色
    {43,163,255},       //蓝色
    {43,255,15},        //绿色
    {15,252,255},       //天蓝色
    {253,122,255},      //紫色
    {246,196,20},       //黄色
    {255,255,255}
};

static ccColor3B bellHeadColors[] = {
    //摆锤颜色为渐变，暂时不定色
};

static float bellRotateAngle[] = {
    12.0,    //身体
    12.0,    //眼睛
    12.0,    //嘴巴
    16.0    //头部
};

static float bellRotateAngleQuick[] = {
    12.0,    //身体
    12.0,    //眼睛
    12.0,    //嘴巴
    16.0    //头部
};

- (id)init
{
    if (self = [super init]) {
        self.isChoosen = NO;
        [self scheduleUpdate];
        [self schedule:@selector(randomEyeMove:) interval:5.0 repeat:YES delay:0.0];
    }
    return self;
}

- (void)didLoadFromCCB
{
    bellBodyBeginPosition = bellBody.position;
    bellMouthBeginPosition = bellMouth.position;
    bellEyeBeginPosition = bellEye.position;
    bellHeadBeginPosition = bellHead.position;
}

- (void)update:(ccTime)delta
{
    CGPoint monsterPoint = [((P5_UndergroundScene *)self.parent) monsterCurrentPosition];
    if (fabsf(self.position.x - monsterPoint.x) < 66.5 && fabsf(self.position.y - monsterPoint.y) < 73.0 && !self.isChoosen) {
        [self handleCollision];
    }
}

- (void)randomEyeMove:(ccTime)delta
{
    [self eyeActionRandom];
}

#pragma mark 平时铃铛的缓慢摆动
- (void)bellNormalAction
{
    [self actionWithbellPart:PartBellBody InMode:[NSNumber numberWithInteger:BellNormalMode]];
    [self performSelector:@selector(actionWithBellHeadInMode:) withObject:[NSNumber numberWithInteger:BellNormalMode] afterDelay:0.4];
}

#pragma mark - 怪物碰到铃铛后剧烈摆动
- (void)bellQuickAction
{
    [self actionWithbellPart:PartBellBody InMode:[NSNumber numberWithInteger:BellQuickMode]];
    [self performSelector:@selector(actionWithBellHeadInMode:) withObject:[NSNumber numberWithInteger:BellQuickMode] afterDelay:0.1];
}

#pragma mark - 铃铛各部分动作
- (void)actionWithBellHeadInMode:(NSNumber *)bellNumber
{
    [self actionWithbellPart:PartBellHead InMode:bellNumber];
}

- (void)actionWithbellPart:(BellPart)bellPart InMode:(NSNumber *)bellNumber
{
    BellMode bellMode = [bellNumber integerValue];
    float angle = bellMode == BellNormalMode ? bellRotateAngle[bellPart] : bellRotateAngleQuick[bellPart];
    if (bellPart == PartBellBody) {
        float duration = bellMode == BellNormalMode ? kBellNormalModePerTime : kBellQuickModePerTime;
        CCRotateTo * bodyRotate1 = [CCRotateTo actionWithDuration:2 * duration angle:angle];
        CCEaseInOut * bodyRotateEase1 = [CCEaseInOut actionWithAction:bodyRotate1 rate:2.0];
        CCRotateTo * bodyRotate2 = [CCRotateTo actionWithDuration:2 * duration angle:- angle];
        CCEaseInOut * bodyRotateEase2 = [CCEaseInOut actionWithAction:bodyRotate2 rate:2.0];
        
        CCSequence * bodyRotateSeq = [CCSequence actions:bodyRotateEase1,bodyRotateEase2, nil];
        CCRepeatForever * rotateForever = [CCRepeatForever actionWithAction:bodyRotateSeq];
        [self runAction:rotateForever];
    }
    else {
        float duration,x_distance1,x_distance2;
        CGPoint bellPartPoint;
        CCSprite * bellPartSprite;
        duration = bellMode == BellNormalMode ? kBellNormalModePerTime : kBellQuickModePerTime;
        x_distance1 = bellMode == BellNormalMode ? 3.0 : 3.0 * 1.5;
        x_distance2 = x_distance1;
        bellPartSprite = bellHead;
        bellPartPoint = bellHeadBeginPosition;
        
        CCRotateTo * rotate1 = [CCRotateTo actionWithDuration:duration * 2 angle:angle];
        CCMoveTo * move1 = [CCMoveTo actionWithDuration:duration * 2 position:CGPointMake(bellPartPoint.x - x_distance1,
                                                                                          bellPartPoint.y)];
        CCEaseInOut * rotateEase1 = [CCEaseInOut actionWithAction:rotate1 rate:2.0];
        CCEaseInOut * moveEase1 = [CCEaseInOut actionWithAction:move1 rate:2.0];
        
        CCRotateTo * rotate2 = [CCRotateTo actionWithDuration:duration * 2 angle:- angle];
        CCMoveTo * move2 = [CCMoveTo actionWithDuration:duration * 2 position:CGPointMake(bellPartPoint.x + x_distance2,
                                                                                          bellPartPoint.y)];
        CCEaseInOut * rotateEase2 = [CCEaseInOut actionWithAction:rotate2 rate:2.0];
        CCEaseInOut * moveEase2 = [CCEaseInOut actionWithAction:move2 rate:2.0];
        
        CCSpawn * act1 = [CCSpawn actions:rotateEase1,moveEase1, nil];
        CCSpawn * act2 = [CCSpawn actions:rotateEase2,moveEase2, nil];
        CCSequence * actionSeq = [CCSequence actions:act1,act2, nil];
        CCRepeatForever * actionForever = [CCRepeatForever actionWithAction:actionSeq];
        
        [bellPartSprite runAction:actionForever];
    }
}

#pragma mark - 所有部分停下动作
- (void)allpartStopAction
{
    [bellBody stopAllActions];
    [bellMouth stopAllActions];
    [bellHead stopAllActions];
    [bellEye stopAllActions];
    [self stopAllActions];
}

#pragma mark - 碰撞处理
- (void)handleCollision
{
    self.isChoosen = YES;
    
    [self addBellBoomAfterCollision];
    [self addBellLightAfterCollision];
    
    [self restartBellToMode:[NSNumber numberWithInteger:BellQuickMode]];
    [self performSelector:@selector(restartBellToMode:) withObject:[NSNumber numberWithInteger:BellNormalMode] afterDelay:kBellQuickModeTotalTime];
}

#pragma mark - 碰撞之后的例子效果和辉光效果
- (void)addBellLightAfterCollision
{
    CCSprite * bellLight = [CCSprite spriteWithFile:@"P5_BellLight.png"];
    bellLight.position = CGPointMake(self.position.x, self.position.y - 33.0);//因为Bell的锚点设置为(0.5,1),所以辉光减去Bell本身高度66.0的一半33.0
    bellLight.opacity = 0.0;
    [self.parent addChild:bellLight];
    CCFadeIn * fadeIn = [CCFadeIn actionWithDuration:0.4];
    CCFadeOut * fadeOut = [CCFadeOut actionWithDuration:0.4];
    CCCallBlock * remove = [CCCallBlock actionWithBlock:^{
        [bellLight removeFromParentAndCleanup:YES];
    }];
    CCSequence * seq = [CCSequence actions:fadeIn,fadeOut,fadeIn,fadeOut,remove, nil];
    [bellLight runAction:seq];
}

- (void)addBellBoomAfterCollision
{
    CCParticleSystem * bellBoom = [CCParticleSystemQuad particleWithFile:@"P5_BellBoom.plist"];
    bellBoom.position = CGPointMake(self.position.x, self.position.y - 33.0);
    bellBoom.autoRemoveOnFinish = YES;
    ccColor3B bellColor = bellBody.color;
    bellBoom.startColor = ccc4f(bellColor.r / 255.0, bellColor.g / 255.0, bellColor.b / 255.0, 1);
    bellBoom.startColor = ccc4f(bellColor.r / 255.0, bellColor.g / 255.0, bellColor.b / 255.0, 0.5);
    [self.parent addChild:bellBoom];
}

#pragma mark - 重置铃铛

- (void)restartBellToMode:(NSNumber *)bellNumber
{
    BellMode bellMode = [bellNumber integerValue];
    [self allpartStopAction];
    
    float bellBodyDuration = bellMode == BellNormalMode ?
    (fabsf(self.rotation) / bellRotateAngle[PartBellBody]) * kBellQuickModePerTime :
    (fabsf(self.rotation) / bellRotateAngleQuick[PartBellBody]) * kBellQuickModePerTime;
    
    float bellHeadDuration = bellMode == BellNormalMode ?
    (fabsf(bellHead.rotation) / bellRotateAngle[PartBellHead]) * kBellQuickModePerTime :
    (fabsf(bellHead.rotation) / bellRotateAngleQuick[PartBellHead]) * kBellQuickModePerTime;
    
    float maxDuration = max(bellHeadDuration, bellBodyDuration);
    [self restartBellPart:PartBellBody InDuration:maxDuration];
    [self restartBellPart:PartBellHead InDuration:maxDuration];
    
    if (bellMode == BellNormalMode) {
        [self performSelector:@selector(bellNormalAction) withObject:nil afterDelay:maxDuration];
    }
    else {
        [self performSelector:@selector(bellQuickAction) withObject:nil afterDelay:maxDuration];
        [self performSelector:@selector(addBellLightAfterCollision) withObject:nil afterDelay:maxDuration];
        [self performSelector:@selector(addBellBoomAfterCollision) withObject:nil afterDelay:maxDuration];
    }
}


/*! 重置铃铛某部分
 * \param bellPart 哪一部分身体
 * \param duration 动作的时间
 */
- (void)restartBellPart:(BellPart)bellPart InDuration:(float)duration
{
    CCSprite * bellPartSprite;
    CGPoint beginPoint;
    if (bellPart == PartBellBody) {
        CCRotateTo * bellBodyRotate = [CCRotateTo actionWithDuration:duration angle:0.0];
        [self runAction:bellBodyRotate];
    }
    else {
        switch (bellPart) {
            case PartBellHead:
            {
                bellPartSprite = bellHead;
                beginPoint = bellHeadBeginPosition;
                break;
            }
            default:
            {
                bellPartSprite = nil;
                beginPoint = CGPointZero;
                NSLog(@"RestartBellPart WithOut BellPart set!");
                break;
            }
        }
        CCRotateTo * rotate = [CCRotateTo actionWithDuration:duration angle:0.0];
        CCMoveTo * move = [CCMoveTo actionWithDuration:duration position:beginPoint];
        CCSpawn * action = [CCSpawn actions:rotate,move, nil];
        [bellPartSprite runAction:action];
    }
}

#pragma mark - 铃铛眼睛随机动画
- (void)eyeActionRandom
{
    if ((float)arc4random() / ARC4RANDOM_MAX < 0.2) {
        CCMoveBy * move = [CCMoveBy actionWithDuration:0.2 position:CGPointMake(1.0, 0.0)];
        CCMoveBy * moveBack = [CCMoveBy actionWithDuration:0.2 position:CGPointMake(-2.0, 0.0)];
        CCSequence * seq = [CCSequence actions:move,moveBack, nil];
        [bellEye runAction:seq];
    }
}

#pragma mark - 设置铃铛颜色
- (ccColor3B)colorAtIndex:(NSUInteger)index
{
    return bellColors[index];
}

- (void)setBodyColor:(ccColor3B)color
{
    bellBody.color = color;
    ccColor3B bellColor;
    bellColor.r = color.r - 20 < 0 ? 0 : color.r - 20;
    bellColor.g = color.g - 20 < 0 ? 0 : color.g - 20;
    bellColor.b = color.b - 20 < 0 ? 0 : color.b - 20;
    bellHead.color = bellColor;
}
@end
