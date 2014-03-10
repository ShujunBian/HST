//
//  P5_Monster.m
//  Dig
//
//  Created by Emerson on 14-1-26.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P5_Monster.h"
#import "P5_CalculateHelper.h"
#import "NSNotificationCenter+Addition.h"
#import "P5_UndergroundScene.h"
#import "P5_GameScene.h"
#import "P5_SoilCloud.h"

#define kHoleCoverTag 1

@implementation P5_Monster
{
    float rotateDegree;     //加速时的角度
    float restDegree;       //小怪物到家后还需要转动的角度
    BOOL isMoveDown;        //检测小怪物到家时 是否完成落地
    BOOL isRotatedDown;     //检测小怪物到家时 是否完成旋转
}

@synthesize monsterEye;
@synthesize leftLeg;
@synthesize rightLeg;
@synthesize body;
@synthesize mouth;
@synthesize bigShadow;
@synthesize littleShadow;

static CGPoint monsterFinalPosition = {161,54.48};

- (id)init
{
    if (self = [super init]) {
        self.isArriveHome = NO;
        self.isReadyStart = NO;
        self.isCreatingPassage = NO;
        isMoveDown = NO;
        isRotatedDown = NO;
        rotateDegree = 0.0;
        [self scheduleUpdate];
    }
    return self;
}

- (void)moveToUnderground
{
    CCMoveBy * moveDown1 = [CCMoveBy actionWithDuration:0.5 position:CGPointMake(0.0, -190.0)];
    CCCallBlock * removeCover = [CCCallBlock actionWithBlock:^{
        [(P5_UndergroundScene *)(self.parent) removeChildByTag:kHoleCoverTag cleanup:YES];
        [(P5_UndergroundScene *)(self.parent) setTouchEnabled:YES];
        
        [self.delegate monsterArriveTheStartHole];
//        P5_SoilCloud * soilCloud = [[[P5_SoilCloud alloc]init]autorelease];
//        [self.parent addChild:soilCloud z:6];
//        soilCloud.position = CGPointMake(900.0, 410.0);
//        [soilCloud createRandomSoilCloud];
        
    }];
    CCSequence * seq = [CCSequence actions:moveDown1,removeCover, nil];
    [self runAction:seq];
    [self performSelector:@selector(moveToUndergroundDownAction) withObject:self afterDelay:0.5];
    [self performSelector:@selector(moveToUndergroundBackAction) withObject:self afterDelay:0.5 + 1 / 6.0];
}



#pragma mark - 跳至地下的缓冲动作
- (void)moveToUndergroundDownAction
{
    [leftLeg runAction:[self createNewLegAction]];
    [rightLeg runAction:[self createNewLegAction]];
    
    [body runAction:[self createNewBodyAction]];

    [mouth runAction:[self createNewOtherAction]];
    [bigShadow runAction:[self createNewOtherAction]];
    [littleShadow runAction:[self createNewOtherAction]];
    [monsterEye runAction:[self createNewOtherAction]];
}

- (void)moveToUndergroundBackAction
{
    [leftLeg runAction:[self createNewLegBackAction]];
    [rightLeg runAction:[self createNewLegBackAction]];
    
    [body runAction:[self createNewBodyBackAction]];
    
    [mouth runAction:[self createNewOtherBackAction]];
    [bigShadow runAction:[self createNewOtherBackAction]];
    [littleShadow runAction:[self createNewOtherBackAction]];
    [monsterEye runAction:[self createNewOtherBackAction]];
}

- (CCSpawn *)createNewLegAction
{
    CCMoveBy * legMoveDown = [CCMoveBy actionWithDuration:1 / 6.0 position:CGPointMake(0.0, -2.0)];
    CCScaleTo * legScale = [CCScaleTo actionWithDuration:1 / 6.0 scaleX:1.0 scaleY:0.9];
    CCSpawn * legspawn = [CCSpawn actions:legMoveDown,legScale, nil];
    return legspawn;
}

- (CCSpawn *)createNewBodyAction
{
    CCMoveBy * allMoveDown = [CCMoveBy actionWithDuration:1 / 6.0 position:CGPointMake(0.0, -4.0)];
    CCScaleTo * bodyScale = [CCScaleTo actionWithDuration:1 / 6.0 scaleX:1.0 scaleY:0.98];
    CCSpawn * bodySpawn = [CCSpawn actions:allMoveDown,bodyScale, nil];
    return bodySpawn;
}

- (CCSpawn *)createNewOtherAction
{
    CCMoveBy * allMoveDown = [CCMoveBy actionWithDuration:1 / 6.0 position:CGPointMake(0.0, -4.0)];
    CCScaleTo * otherScale = [CCScaleTo actionWithDuration:1 / 6.0 scaleX:1.0 scaleY:0.99];
    CCSpawn * otherSpawn = [CCSpawn actions:allMoveDown,otherScale, nil];
    return otherSpawn;
}

- (CCSpawn *)createNewLegBackAction
{
    CCMoveBy * legMoveUp = [CCMoveBy actionWithDuration:1 / 6.0 position:CGPointMake(0.0, 2.0)];
    CCScaleTo * legScaleBack = [CCScaleTo actionWithDuration:1 / 6.0 scaleX:1.0 scaleY:1.0];
    CCSpawn * legspawn = [CCSpawn actions:legMoveUp,legScaleBack, nil];
    return legspawn;
}

- (CCSpawn *)createNewBodyBackAction
{
    CCMoveBy * allMoveUp = [CCMoveBy actionWithDuration:1 / 6.0 position:CGPointMake(0.0, 4.0)];
    CCScaleTo * bodyScaleBack = [CCScaleTo actionWithDuration:1 / 6.0 scaleX:1.0 scaleY:1.0];
    CCSpawn * bodySpawn = [CCSpawn actions:allMoveUp,bodyScaleBack, nil];
    return bodySpawn;
}

- (CCSpawn *)createNewOtherBackAction
{
    CCMoveBy * allMoveUp = [CCMoveBy actionWithDuration:1 / 6.0 position:CGPointMake(0.0, 4.0)];
    CCScaleTo * otherScaleBack = [CCScaleTo actionWithDuration:1 / 6.0 scaleX:1.0 scaleY:1.0];
    CCSpawn * otherSpawn = [CCSpawn actions:allMoveUp,otherScaleBack, nil];
    return otherSpawn;
}

#pragma mark - 收脚
- (void)coverTheLeg
{
    CCMoveBy * moveUp = [CCMoveBy actionWithDuration:1 / 6.0 position:CGPointMake(0.0, 25.0)];
    CCCallBlock * changeMonsterToStart = [CCCallBlock actionWithBlock:^{
        _isReadyStart = YES;
    }];
    CCSequence * seq = [CCSequence actions:moveUp,changeMonsterToStart, nil];
    [self runAction:seq];
    [leftLeg runAction:[self createCoverLegAction]];
    [rightLeg runAction:[self createCoverLegAction]];
}

- (CCSpawn *)createCoverLegAction
{
    CCMoveBy * legMoveUp = [CCMoveBy actionWithDuration:1 / 6.0 position:CGPointMake(0.0, 20.0)];
    CCRotateBy * legRotate = [CCRotateBy actionWithDuration:1 / 6.0 angle:-90.0];
    return [CCSpawn actions:legMoveUp,legRotate, nil];
}

#pragma mark - 出脚
- (void)showTheLeg
{
    [leftLeg runAction:[self createShowLegAction]];
    [rightLeg runAction:[self createShowLegAction]];
}

- (CCSpawn *)createShowLegAction
{
    CCMoveBy * legMoveDown = [CCMoveBy actionWithDuration:1 / 6.0 position:CGPointMake(0.0, -20.0)];
    CCRotateBy * legRotate = [CCRotateBy actionWithDuration:1 / 6.0 angle:90.0];
    return [CCSpawn actions:legMoveDown,legRotate, nil];
}

#pragma mark - 出发前的动作
- (void)startRoll
{
    [self moveToUndergroundDownAction];
    [self performSelector:@selector(jumpBeforeStart) withObject:self afterDelay:1.0 / 6.0];

    if ([[((P5_UndergroundScene *)self.parent).drawOrderArray objectAtIndex:1]integerValue] != 6) {
        [self performSelector:@selector(startMoveFrontBeforeRoll) withObject:self afterDelay:1.0];
    }
    else {
        [self performSelector:@selector(changeMonsterToStart) withObject:self afterDelay:1.0];
    }
}

- (void)startMoveFrontBeforeRoll
{
    //除了垂直向下出发，向其他地方出发需要先向左移动一段（同时向上移动一小段）
    CCMoveBy * moveFront = [CCMoveBy actionWithDuration:1 / 5.0 position:CGPointMake(-45.0, 5.0)];
    CCCallFunc * postMessage = [CCCallFunc actionWithTarget:self selector:@selector(changeMonsterToStart)];
    CCSequence * seq = [CCSequence actions:moveFront,postMessage, nil];
    [self runAction:seq];
}

- (void)changeMonsterToStart
{
    [NSNotificationCenter postShouldRollToNextHoleNotification];
    [NSNotificationCenter postShouldShowNextPassageNotification];
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

#pragma mark - 从一个洞穴到达另一个的滚动动作
- (void)rollfromPoint1:(CGPoint)point1 toPoint2:(CGPoint)point2
{
    _isCreatingPassage = YES;
    float moveDistance = [P5_CalculateHelper distanceBetweenEndPoint:point2 andStartPoint:point1];
    float duration = moveDistance / 250.0;
    
    CCMoveTo * move = [CCMoveTo actionWithDuration:duration position:point2];
    CCCallFunc * callBackToPost = [CCCallFunc actionWithTarget:self selector:@selector(arriveHole)];
    CCSequence * seq = [CCSequence actions:move,callBackToPost, nil];
    [self runAction:seq];
}

#pragma mark - 到达一个洞穴动作
- (void)arriveHole
{
    _isCreatingPassage = NO;
    [NSNotificationCenter postShouldShowNextPassageNotification];
    [NSNotificationCenter postShouldRollToNextHoleNotification];
}

#pragma mark - 到家之后动作
- (void)arriveHome
{
    _isCreatingPassage = NO;
    [self stopAllActions];
    restDegree = (NSInteger)(self.rotation / 360 - 1) * 360.0 - self.rotation;
    restDegree -= 360.0;
    
    float restDuration = [P5_CalculateHelper distanceBetweenEndPoint:monsterFinalPosition andStartPoint:self.position] / 200.0;
    CCMoveTo * moveToHome = [CCMoveTo actionWithDuration:restDuration position:monsterFinalPosition];
    CCCallBlock * block = [CCCallBlock actionWithBlock:^{
        isMoveDown = YES;
        [self moveDownHome];
    }];
    CCSequence * seq = [CCSequence actions:moveToHome,block, nil];
    [self runAction:seq];

    [self performSelector:@selector(postStartRotateBellNotification) withObject:nil afterDelay:2.0];
}

- (void)postStartRotateBellNotification
{
    [NSNotificationCenter postShouldRotateNextBellNotification];
}

- (void)moveDownHome
{
    if (isMoveDown && isRotatedDown) {
        [self performSelector:@selector(moveToUndergroundDownAction) withObject:self afterDelay:0.0];
        [self performSelector:@selector(moveToUndergroundBackAction) withObject:self afterDelay:0.0 + 1 / 6.0];
        
        [self.delegate monsterArriveTheFinalHole];
    }
}

- (void)update:(ccTime)delta
{
    if (!_isArriveHome && _isReadyStart) {
        if (rotateDegree < 24.0) {
            rotateDegree += 0.5;
        }
        self.rotation -=  rotateDegree;
    }
    if (_isArriveHome && !_isReadyStart) {
        if (fabsf(restDegree - 0.0) > 0.5) {
            if (rotateDegree <= 24.0 && rotateDegree > 4.0) {
                rotateDegree -= 0.3;
            }
            restDegree += rotateDegree;
            if (restDegree > 0.0) {
                restDegree -= rotateDegree;
                self.rotation -= (-restDegree);
                restDegree = 0.0;
                isRotatedDown = YES;
                [self showTheLeg];
                [self moveDownHome];
            }
            else
                self.rotation -= rotateDegree;
        }
    }
}

- (void)completedAnimationSequenceNamed:(NSString *)name
{
    if ([name isEqualToString:@"Jump"]) {

    }
}

@end
