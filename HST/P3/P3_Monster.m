//
//  P3_Monster1.m
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright 2014年 Emerson. All rights reserved.
//

#import "P3_Monster.h"
#import "P3_GameScene.h"
#import "P3_MonsterBody.h"
#import "MonsterEye.h"
#import "MonsterEyeUpdateObject.h"
#import "NSNotificationCenter+Addition.h"
#define kP3zOrderPurpleLayer    32

@implementation P3_Monster

@synthesize monsterMouth;
@synthesize monsterBody;

- (id)init
{
    if (self = [super init]) {
        self.oldTouchPosition = monsterFirstPositions[self.monsterType];
        self.isStartMoving = YES;
        self.movingType = MovingStay;
        self.isNeedAutoMoving = YES;
        self.isBeginAnimationFinished = NO;
        self.monsterBodyCounter = 0;
        self.monsterBodyArray = [NSMutableArray arrayWithCapacity:7];
        
        self.isInMainMap = NO;
        self.isUp = YES;
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)dealloc
{
    self.monsterEye = nil;
    self.monsterBodyArray = nil;
    
    [super dealloc];

}
- (void)createMonsterWithType:(MonsterType)monsterType
{
    self.monsterType = monsterType;
    self.monsterEye = [[[P3_MonsterEye alloc]init] autorelease];
    [self.monsterEye setMonsterEyeCounter:monsterEyeCounters[monsterType]];
    self.monsterEye.updateObj = [[[MonsterEyeUpdateObject alloc] init] autorelease];
    
    NSString * fileNameEyeWhite = [NSString stringWithFormat:@"P3_Monster%d_Eye_background.png",(monsterType + 1)];
    NSString * fileNameEyeBlack = [NSString stringWithFormat:@"P3_Monster%d_Eye_point.png",(monsterType + 1)];
    
    for (int i = 0; i < monsterEyeCounters[monsterType]; ++ i) {
        MonsterEye * eye = [[MonsterEye alloc] initWithEyeWhiteName:fileNameEyeWhite eyeballName:fileNameEyeBlack eyelidColor:monsterFaceColor[self.monsterType][0]];
        
        [self.monsterEye.monsterEyeSprites addObject:
         eye];
        [self.monsterEye.updateObj addMonsterEye:eye];
    }
}

- (void)initMonsterEyes
{
    for (int i = 0; i < self.monsterEye.monsterEyeCounter; ++ i) {

        CGPoint monsterEyePosition = [[self.monsterEye.monsterEyePositions objectAtIndex:i]CGPointValue];
        
        MonsterEye * eye = (MonsterEye *)[self.monsterEye.monsterEyeSprites objectAtIndex:i];
        [eye setPosition:monsterEyePosition];
        [self addChild:eye];
        
        [self.monsterEye.updateObj beginUpdate];
    }
}

- (int)theLatestPointByCenterPoint:(CGPoint)centerPoint
                 monsterBodyHeight:(float)monsterBodyHeight
{
    int latestPointNumber = 0;
    float currentLength = fabsf(centerPoint.y - kMonsterBaselineYPosition);
    for (int i = 1; i < 7 ; ++ i) {
        float newLength = fabsf(i * monsterBodyHeight - centerPoint.y + kMonsterBaselineYPosition);
        if (newLength < currentLength) {
            currentLength = newLength;
            latestPointNumber = i;
        }
    }
    return latestPointNumber;
}

- (void)createMonsterBodyInPosition:(CGPoint)position
                     andMonsterType:(MonsterType)monsterType
{
    
    NSString * fileName;
    switch (self.monsterType) {
        case PurpMonster: {
            fileName = @"P3_PurpMonsterBody.ccbi";
            break;
        }
        case BlueMonster: {
            fileName = @"P3_BlueMonsterBody.ccbi";
            break;
        }
        case RedMonster: {
            fileName = @"P3_RedMonsterBody.ccbi";
            break;
        }
        case CeruleanMonster: {
            fileName = @"P3_CeruleanMonsterBody.ccbi";
            break;
        }
        default: {
            fileName = @"";
            break;
        }
    }

    if ([self.monsterBodyArray count] < 4) {
        P3_MonsterBody * newBody = (P3_MonsterBody *)[CCBReader nodeGraphFromFile:fileName];
        [newBody setAnchorPoint:CGPointMake(0.5, 0.0)];
        [newBody setPosition:position];
        [newBody setScale:0.0];
        
        if (self.monsterType == PurpMonster &&
            [self.parent isKindOfClass:[P3_GameScene class]] &&
            ((P3_GameScene *)self.parent).isInHelpUI) {
            [self.parent addChild:newBody z:kP3zOrderPurpleLayer];
            [self.monsterBodyArray addObject:newBody];
            
            [self.delegate hideHelpUI];
//            [NSNotificationCenter postShouldHideHelpUINotification];
        }
        else {
            [self.parent addChild:newBody z:zOrder[self.monsterType]];
            [self.monsterBodyArray addObject:newBody];
        }
        newBody.body.color = monsterFaceColor[self.monsterType][[self.monsterBodyArray count]];
        newBody.monsterType = self.monsterType;
        [newBody initMonsterBodyEyesAndMouth];
        
        CCScaleTo * scaleBack = [CCScaleTo actionWithDuration:0.05 scale:1.05];
        CCScaleTo * scaleBack2 = [CCScaleTo actionWithDuration:0.05 scale:0.95];
        CCScaleTo * scaleBack3 = [CCScaleTo actionWithDuration:0.05 scale:1.0];
        
        CCSequence * seq = [CCSequence actions:scaleBack,scaleBack2,scaleBack3, nil];
        [newBody runAction:seq];
    }
    
    [self.delegate monsterWithMonsterType:self.monsterType DragginChangedLevel:[self.monsterBodyArray count] + 1];
    
    [self addGrassParticle];
}

#pragma mark - 添加粒子效果
- (void)addGrassParticle
{
    CGPoint position;
    float rate;
    if (self.isInMainMap) {
        position = CGPointMake(monsterMainMapPositions[self.monsterType].x,kMonsterMainMapBaselineYPosition);
        rate = 0.35;
    }
    else {
        position = CGPointMake(monsterFirstPositions[self.monsterType].x,kMonsterBaselineYPosition);
        rate = 1.0;
    }
    CCParticleSystem * grassOut = [CCParticleSystemQuad particleWithFile:@"P3_GrassPSQ.plist"];
    grassOut.position = position;
    grassOut.autoRemoveOnFinish = YES;
    [grassOut setScale:rate];
    [self.parent addChild:grassOut];
}

- (void)addBubbleBoomParticleInPosition:(CGPoint)position
                               andColor:(ccColor3B)color
{
    CCParticleSystem * boom = [CCParticleSystemQuad particleWithFile:@"P3_BubblePSQ.plist"];
    boom.position = position;
    boom.startColor = ccc4FFromccc3B(color);
    boom.endColor = ccc4FFromccc3B(color);
    boom.autoRemoveOnFinish = YES;
    [self.parent addChild:boom];
}

#pragma mark - 开场动画
- (void)beginningAnimationInDelayTime:(float)delayTime
{
    CCMoveTo *moveTo =  [CCMoveTo actionWithDuration:delayTime position:CGPointMake(self.position.x, kMonsterBaselineYPosition)];
    CCEaseExponentialIn *easeIn = [CCEaseExponentialIn actionWithAction:moveTo];
    CCScaleTo *action1 = [CCScaleTo actionWithDuration:0.1f scaleX:1 - 0.1 scaleY:1+0.1];
    CCScaleTo *action2 = [CCScaleTo actionWithDuration:0.1f scale:1];
    CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
        self.isBeginAnimationFinished = YES;
        if (self.monsterType == CeruleanMonster) {
            [self.delegate afterBeginAnimationFinished];
        }
    }];
    CCSequence *seq = [CCSequence actions:easeIn,action1,action2,callBack, nil];
    
    [self runAction:seq];
    
    [self performSelector:@selector(addGrassParticle) withObject:self afterDelay:delayTime - 0.4];
}

#pragma mark - 大地图中的跳出动画和下降动画
- (void)jumpUpAnimationInMainMap
{
    CCMoveTo * moveTo =  [CCMoveTo actionWithDuration:0.5 position:CGPointMake(self.position.x, kMonsterMainMapBaselineYPosition)];
    CCEaseExponentialIn *easeIn = [CCEaseExponentialIn actionWithAction:moveTo];
    CCScaleTo *action1 = [CCScaleTo actionWithDuration:0.1f scaleX:(1 - 0.1) * 0.35 scaleY:(1 + 0.1) * 0.35];
    CCScaleTo *action2 = [CCScaleTo actionWithDuration:0.1f scale:0.35];
    CCSequence *seq = [CCSequence actions:easeIn,action1,action2, nil];
    self.isUp = YES;
    
    [self runAction:seq];
    [self performSelector:@selector(addGrassParticle) withObject:self afterDelay:0.3];
}

- (void)jumpDownAnimationInMainMap
{
    CCMoveTo * moveTo =  [CCMoveTo actionWithDuration:0.5 position:CGPointMake(self.position.x, kMonsterMainMapBaselineYPosition - monsterFaceHeight[self.monsterType] * 0.35)];
    CCEaseExponentialIn *easeIn = [CCEaseExponentialIn actionWithAction:moveTo];
    CCSequence *seq = [CCSequence actions:easeIn, nil];
    self.isUp = NO;
    
    [self runAction:seq];
    [self addGrassParticle];
}

#pragma mark - update函数
- (void)update:(ccTime)delta
{
    if (self.isBeginAnimationFinished) {
        if (!self.isChoosen) {
            
            //放手是小怪物脸不在应该在的位置 则需要回弹
            if (self.position.y - [self.monsterBodyArray count] * monsterBodyHeight[self.monsterType] != kMonsterBaselineYPosition) {
                
                float distance = [self.monsterBodyArray count] * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition - self.position.y;
                
                [self changePositionInDistance:distance andSprite:self];
                
                self.oldTouchPosition = monsterFirstPositions[self.monsterType];
            }
            
            //放手是小怪物身体不在应该在的位置 则需要回弹
            for (int i = 0; i < [self.monsterBodyArray count]; ++ i) {
                P3_MonsterBody * body = (P3_MonsterBody *)[self.monsterBodyArray objectAtIndex:i];
                
                if (!CGPointEqualToPoint(body.anchorPoint, CGPointMake(0.5, 0.0))) {
                    
                    float rateYDistance = (1.0 - body.scaleY);
                    float rateXDistance = body.scaleX - 1.0;
                    
                    [self changeYScaleInScaleDistance:rateYDistance andSprite:body];
                    [self changeXScaleInScaleDistance:rateXDistance andSprite:body];
                    
                    if (body.position.y != monsterBodyHeight[self.monsterType] *
                        ([self.monsterBodyArray count] - i) + kMonsterBaselineYPosition ) {
                        
                        float distance = monsterBodyHeight[self.monsterType] *
                        ([self.monsterBodyArray count] - i) + kMonsterBaselineYPosition - body.position.y;
                        
                        if (fabsf(distance) >= 6.0) {
                            [body setPosition:CGPointMake(body.position.x,
                                                          body.position.y + (distance / 3.0))];
                        }
                        else if (fabsf(distance) < 6.0 && fabsf(distance) >= 2.0) {
                            [body setPosition:CGPointMake(body.position.x,
                                                          body.position.y + 2.0 * distance / fabsf(distance))];
                        }
                        else {
                            [body setPosition:CGPointMake(body.position.x,
                                                          body.position.y + distance)];
                        }
                    }
                    else {
                        if (rateYDistance == 0.0 && rateXDistance == 0.0) {
#pragma mark 放手修改锚点
                            [body setAnchorPoint:CGPointMake(0.5, 0.0)];
                            [body setPosition:CGPointMake(body.position.x,body.position.y - 1.0 * monsterBodyHeight[self.monsterType])];
                        }
                    }
                }
                else {
                    if (body.position.y != monsterBodyHeight[self.monsterType] *
                        ([self.monsterBodyArray count] - i - 1) + kMonsterBaselineYPosition ) {
                        
                        float distance = monsterBodyHeight[self.monsterType] *
                        ([self.monsterBodyArray count] - i - 1) + kMonsterBaselineYPosition - body.position.y;
                        
                        if (fabsf(distance) >= 6.0) {
                            [body setPosition:CGPointMake(body.position.x,
                                                          body.position.y + (distance / 3.0))];
                        }
                        else if (fabsf(distance) < 6.0 && fabsf(distance) >= 2.0) {
                            [body setPosition:CGPointMake(body.position.x,
                                                          body.position.y + 2.0 * distance / fabsf(distance))];
                        }
                        else {
                            [body setPosition:CGPointMake(body.position.x,
                                                          body.position.y + distance)];
#pragma mark 根据小怪物身体个数决定压缩比例
                            [(P3_GameScene *)self.parent setTouchEnabled:NO];
                            CCScaleTo * scaleAfterJump1 = [CCScaleTo actionWithDuration:0.05 scaleX:1.05 - (i + 1) * 0.01 scaleY:0.96 + 0.01 * (i + 1)];
                            //                            CCScaleTo * scaleAfterJump2 = [CCScaleTo actionWithDuration:0.05 scaleX:0.95 + 0.01 * (i + 1)  scaleY:1.06 - (i + 1) * 0.01];
                            CCScaleTo * scaleAfterJump3 = [CCScaleTo actionWithDuration:0.05 scaleX:1.0 scaleY:1.0];
                            
                            CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
                                [(P3_GameScene *)self.parent setTouchEnabled:YES];
                            }];
                            
                            CCSequence * seq = [CCSequence actions:
                                                scaleAfterJump1,
                                                //                                                scaleAfterJump2,
                                                scaleAfterJump3,
                                                callBack,
                                                nil];
                            
                            [body runAction:seq];
                        }
                    }
                }
            }
            
            self.isStartMoving = YES;
            self.movingType = MovingStay;
            self.monsterBodyCounter = (int)[self.monsterBodyArray count];
        }
        else {
            if (self.position.y == kMonsterBaselineYPosition &&
                self.movingType == MovingUp) {
                if (self.monsterType == GreenMonster) {
                    if (self.oldTouchPosition.y > monsterFaceHeight[self.monsterType] + kMonsterBaselineYPosition) {
                        float rateDistance = (self.oldTouchPosition.y - monsterFaceHeight[self.monsterType] - kMonsterBaselineYPosition) / monsterFaceHeight[self.monsterType];
                        
                        if (rateDistance > 1.0) {
                            rateDistance = 1.0;
                        }
                        float scaleYRate = 1 + rateDistance * 0.1;
                        float scaleXRate = 1 - rateDistance * 0.05;
                        
                        [self setScaleX:scaleXRate];
                        [self setScaleY:scaleYRate];
                    }
                }
            }
            else if (self.position.y >= (self.monsterBodyCounter + 0.5) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition &&
                     self.position.y < (self.monsterBodyCounter + 1) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition &&
                     self.movingType == MovingUp) {

                if (self.isNeedAutoMoving) {
                    
                    [self createMonsterBodyInPosition:CGPointMake(self.position.x,kMonsterBaselineYPosition)
                                       andMonsterType:self.monsterType];
                    
                    self.isNeedAutoMoving = NO;
                }
                
                float distance = (self.monsterBodyCounter + 1) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition - self.position.y;
                
                [self changePositionInDistance:distance andSprite:self];
                
#pragma mark 拖动到临界值时移动MonsterBody
                for (int i = 0; i < [self.monsterBodyArray count]; ++ i) {
                    P3_MonsterBody * body = (P3_MonsterBody *)[self.monsterBodyArray objectAtIndex:i];
                    float distance = (self.monsterBodyCounter - i) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition - body.position.y;
                    
                    [self changePositionInDistance:distance andSprite:body];
                }
            }
#pragma mark 已过新一个MonsterBody底线
            else if ((fabsf(self.position.y - (self.monsterBodyCounter + 1) * monsterBodyHeight[self.monsterType] - kMonsterBaselineYPosition) < 1.0 ||
                      self.position.y > (self.monsterBodyCounter + 1) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition) &&
                     self.movingType == MovingUp)
            {
                if (self.monsterBodyCounter < 4) {
                    ++ self.monsterBodyCounter;
                }
                self.isNeedAutoMoving = YES;
            }
#pragma mark 向下拖动到基础线46.0
            else if (self.position.y == kMonsterBaselineYPosition) {
                if (self.movingType == MovingDown) {
                    if (self.oldTouchPosition.y <= monsterFaceHeight[self.monsterType] + kMonsterBaselineYPosition) {
                        float distanceRate = 1.0 -  fabsf(self.oldTouchPosition.y) / (monsterFaceHeight[self.monsterType] + kMonsterBaselineYPosition);
                        
                        float scaleYRate = 1 - distanceRate * 0.1;
                        float scaleXRate = 1 + distanceRate * 0.05;
                        
                        [self setScaleX:scaleXRate];
                        [self setScaleY:scaleYRate];
                    }
                }
                
                self.monsterBodyCounter = 0;
            }
#pragma mark 向下压缩
            else if (self.position.y < (self.monsterBodyCounter) *
                     monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition &&
                     self.position.y > (self.monsterBodyCounter - 0.5) *
                     monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition &&
                     self.movingType == MovingDown) {
                
                float movingDistance = ([self.monsterBodyArray count]) *
                monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition - self.position.y;
                
                float sum = (1 - powf(0.95, [self.monsterBodyArray count])) / (1 - 0.95);
                float groundMonsterDistance = movingDistance / sum;
                
                float scaleRate = (monsterBodyHeight[self.monsterType] - fabsf(groundMonsterDistance)) / monsterBodyHeight[self.monsterType];
                
                
                for (int i = 0; i < [self.monsterBodyArray count]; ++ i) {
                    P3_MonsterBody * body = (P3_MonsterBody *)[self.monsterBodyArray objectAtIndex:i];
#pragma mark 向下压缩修改锚点
                    if (!CGPointEqualToPoint(body.anchorPoint, CGPointMake(0.5, 1.0))) {
                        [body setAnchorPoint:CGPointMake(0.5, 1.0)];
                        [body setPosition:CGPointMake(body.position.x,body.position.y + body.scaleY * monsterBodyHeight[self.monsterType])];
                    }
                    
                    float rate = powf(0.95,[self.monsterBodyArray count] - i - 1);
                    
                    [body setScaleY:1 - (1 - scaleRate) * rate];
                    float bodyDistance = (1 - powf(0.95,[self.monsterBodyArray count] - i))/(1- 0.95) * groundMonsterDistance;
                    
                    float originalYPosition = ([self.monsterBodyArray count] - i) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition + 3.0;
                    
                    [body setPosition:CGPointMake(body.position.x, originalYPosition - bodyDistance)];
                }
            }
            else if (self.position.y <= (self.monsterBodyCounter - 0.5) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition &&
                     self.position.y > (self.monsterBodyCounter - 1.0) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition &&
                     self.movingType == MovingDown){
                
                float distance = (self.monsterBodyCounter - 1) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition - self.position.y;
                
                [self changePositionInDistance:distance andSprite:self];
                
#pragma mark 压缩到一定程度 删除monster body
                if ([self.monsterBodyArray count] >= self.monsterBodyCounter &&
                    [self.monsterBodyArray count] > 0) {
                    [self.delegate hideHelpUI];
                    P3_MonsterBody * body = (P3_MonsterBody *)[self.monsterBodyArray objectAtIndex:self.monsterBodyCounter - 1];
                    [self addBubbleBoomParticleInPosition:CGPointMake(body.position.x, kMonsterBaselineYPosition + 1 / 2.0 * body.contentSize.height) andColor:body.body.color];
                    [body removeFromParentAndCleanup:YES];
                    [self.monsterBodyArray removeObjectAtIndex:self.monsterBodyCounter - 1];
                    
                    [self.delegate monsterWithMonsterType:self.monsterType DragginChangedLevel:(int)[self.monsterBodyArray count] + 1];
                }
                
                for (int i = 0; i < [self.monsterBodyArray count]; ++ i) {
                    P3_MonsterBody * body = (P3_MonsterBody *)[self.monsterBodyArray objectAtIndex:i];
                    float distance = ([self.monsterBodyArray count] - i) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition - body.position.y;
                    
                    [self changePositionInDistance:distance andSprite:body];
                    
                    float rateYDistance = (1.0 - body.scaleY);
                    if (rateYDistance <= 0.0) {
                        rateYDistance = 0.0;
                    }
                    float rateXDistance = body.scaleX - 1.0;
                    if (rateXDistance <= 0.0) {
                        rateXDistance = 0.0;
                    }
                    
                    [self changeYScaleInScaleDistance:rateYDistance andSprite:body];
                    [self changeXScaleInScaleDistance:rateXDistance andSprite:body];
                }
            }
            else if (self.position.y <= (self.monsterBodyCounter - 1.0) * monsterBodyHeight[self.monsterType] + kMonsterBaselineYPosition &&
                     self.movingType == MovingDown) {
                if (self.monsterBodyCounter > 0) {
                    -- self.monsterBodyCounter;
                }
            }
        }
    }
}

#pragma mark - update过程Helper函数
- (void)changeYScaleInScaleDistance:(float)distance
                          andSprite:(CCNode *)sprite
{
    if (fabsf(distance) > 0.2) {
        [sprite setScaleY:sprite.scaleY + distance / 5.0];
    }
    else if (fabsf(distance) < 0.2 && fabsf(distance) > 0.04) {
        [sprite setScaleY:sprite.scaleY + 0.04 * fabsf(distance) / distance];
    }
    else {
        [sprite setScaleY:sprite.scaleY + distance];
    }
}

- (void)changeXScaleInScaleDistance:(float)distance
                          andSprite:(CCNode*)sprite
{
    if (fabsf(distance) > 0.3) {
        [sprite setScaleX:sprite.scaleX + distance / 3.0];
    }
    else if (fabsf(distance) < 0.3 && fabsf(distance) > 0.05) {
        [sprite setScaleX:sprite.scaleX + 0.05 * fabsf(distance) / distance];
    }
    else {
        [sprite setScaleX:sprite.scaleX + distance];
    }
}

- (void)changePositionInDistance:(float)distance
                       andSprite:(CCNode *)sprite
{
    if (fabsf(distance) >= 6.0) {
        [sprite setPosition:CGPointMake(sprite.position.x,
                                        sprite.position.y + (distance / 3.0))];
    }
    else if (fabsf(distance) < 6.0 && fabsf(distance) >= 2.0) {
        [sprite setPosition:CGPointMake(sprite.position.x,
                                        sprite.position.y + 2.0 * distance / fabsf(distance))];
    }
    else {
        [sprite setPosition:CGPointMake(sprite.position.x,
                                        sprite.position.y + distance)];
    }
}


@end
