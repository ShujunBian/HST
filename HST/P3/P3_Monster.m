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

@implementation P3_Monster
{
    float unChoosenDistance;
    
    //    BOOL isFirstAutoDistance;
    float autoDistance;
}
@synthesize monsterMouth;
@synthesize monsterBody;

- (id)init
{
    if (self = [super init]) {
        self.oldTouchPosition = monsterFirstPositions[self.monsterType];
        self.isStartMoving = YES;
        //        self.isJumping = NO;
        self.isNeedAutoMoving = YES;
        self.isNeedAutoScale = YES;
        self.monsterBodyCounter = 0;
        self.monsterBodyArray = [NSMutableArray arrayWithCapacity:7];
        [self scheduleUpdate];
    }
    return self;
}

- (void)createMonsterWithType:(MonsterType)monsterType
{
    self.monsterType = monsterType;
    self.monsterEye = [[P3_MonsterEye alloc]init];
    [self.monsterEye setMonsterEyeCounter:monsterEyeCounters[monsterType]];
    NSString * fileNameEyeWhite = [NSString stringWithFormat:@"P3_Monster%d_Eye_background.png",(monsterType + 1)];
    NSString * fileNameEyeBlack = [NSString stringWithFormat:@"P3_Monster%d_Eye_point.png",(monsterType + 1)];
    
    for (int i = 0; i < monsterEyeCounters[monsterType]; ++ i) {
        [self.monsterEye.monsterEyeSprites addObject:
         [CCSprite spriteWithFile:fileNameEyeWhite]];
        [self.monsterEye.monsterEyeBlackSprites addObject:
         [CCSprite spriteWithFile:fileNameEyeBlack]];
    }
}

- (void)initMonsterEyes
{
    for (int i = 0; i < self.monsterEye.monsterEyeCounter; ++ i) {
        CGPoint monsterEyePosition = [[self.monsterEye.monsterEyePositions objectAtIndex:i]CGPointValue];
        
        CCSprite * monsterEyeSprite = (CCSprite *)[self.monsterEye.monsterEyeSprites objectAtIndex:i];
        CCSprite * monsterEyeBlackSprite = (CCSprite *)[self.monsterEye.monsterEyeBlackSprites objectAtIndex:i];
        
        [monsterEyeSprite setPosition:monsterEyePosition];
        [monsterEyeBlackSprite setPosition:monsterEyePosition];
        [self addChild:monsterEyeSprite];
        [self addChild:monsterEyeBlackSprite];
    }
}

- (int)theLatestPointByCenterPoint:(CGPoint)centerPoint
                 monsterBodyHeight:(float)monsterBodyHeight
{
    int latestPointNumber = 0;
    float currentLength = fabsf(centerPoint.y - 46.0);
    for (int i = 1; i < 7 ; ++ i) {
        float newLength = fabsf(i * monsterBodyHeight - centerPoint.y + 46.0);
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
        [self.parent addChild:newBody];
        [self.monsterBodyArray addObject:newBody];
        
        newBody.body.color = monsterFaceColor[self.monsterType][[self.monsterBodyArray count]];
        
        
        CCScaleTo * scaleBack = [CCScaleTo actionWithDuration:0.05 scale:1.05];
        CCScaleTo * scaleBack2 = [CCScaleTo actionWithDuration:0.05 scale:0.95];
        CCScaleTo * scaleBack3 = [CCScaleTo actionWithDuration:0.05 scale:1.0];
        
        CCSequence * seq = [CCSequence actions:scaleBack,scaleBack2,scaleBack3, nil];
        [newBody runAction:seq];
    }
}

- (void)update:(ccTime)delta
{
    if (!self.isChoosen) {
        
        //放手是小怪物脸不在应该在的位置 则需要回弹
        if (self.position.y - [self.monsterBodyArray count] * monsterBodyHeight[self.monsterType] != 46.0) {
            
            float distance = [self.monsterBodyArray count] * monsterBodyHeight[self.monsterType] + 46.0 - self.position.y;
            
            [self changePositionInDistance:distance andSprite:self];
            
            self.oldTouchPosition = monsterFirstPositions[self.monsterType];
        }
        
        //放手是小怪物身体不在应该在的位置 则需要回弹
        for (int i = 0; i < [self.monsterBodyArray count]; ++ i) {
            P3_MonsterBody * body = (P3_MonsterBody *)[self.monsterBodyArray objectAtIndex:i];
            
#pragma mark 放手修改锚点
            if (!CGPointEqualToPoint(body.anchorPoint, CGPointMake(0.5, 0.0))) {
                [body setAnchorPoint:CGPointMake(0.5, 0.0)];
                [body setPosition:CGPointMake(body.position.x,body.position.y - body.scaleY * monsterBodyHeight[self.monsterType])];
            }
            
            if (body.position.y != monsterBodyHeight[self.monsterType] *
                ([self.monsterBodyArray count] - i - 1) + 46.0 ) {
                
                float distance = monsterBodyHeight[self.monsterType] *
                ([self.monsterBodyArray count] - i - 1) + 46.0 - body.position.y;
                
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
                    if (distance < 0) {
#pragma mark 根据小怪物身体个数决定压缩比例
                        [(P3_GameScene *)self.parent setTouchEnabled:NO];
                        CCScaleTo * scaleAfterJump1 = [CCScaleTo actionWithDuration:0.05 scaleX:1.05 - (i + 1) * 0.01 scaleY:0.95 + 0.01 * (i + 1)];
                        CCScaleTo * scaleAfterJump2 = [CCScaleTo actionWithDuration:0.05 scaleX:0.95 + 0.01 * (i + 1)  scaleY:1.05 - (i + 1) * 0.01];
                        CCScaleTo * scaleAfterJump3 = [CCScaleTo actionWithDuration:0.05 scaleX:1.0 scaleY:1.0];
                        
                        CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
                            [(P3_GameScene *)self.parent setTouchEnabled:YES];
                        }];
                        
                        CCSequence * seq = [CCSequence actions:
                                            scaleAfterJump1,
                                            scaleAfterJump2,
                                            scaleAfterJump3,
                                            callBack,
                                            nil];
                        
                        [body runAction:seq];
                    }
                }
            }
            float rateYDistance = (1.0 - body.scaleY);
            float rateXDistance = body.scaleX - 1.0;
            if (rateYDistance > 0.3) {
                [body setScaleY:body.scaleY + rateYDistance / 3.0];
            }
            else if (rateYDistance < 0.3 && rateYDistance > 0.05) {
                [body setScaleY:body.scaleY + 0.05];
            }
            else {
                [body setScaleY:body.scaleY + rateYDistance];
            }
            
            [self changeXScaleInScaleDistance:rateXDistance andSprite:body];
        }
        self.isStartMoving = YES;
        
    }
    
    if (self.isChoosen ) {
        
        if (self.isMovingUp
            && !self.isStartMoving) {
            float scaleRate = ((self.position.y - self.monsterBodyCounter * monsterBodyHeight[self.monsterType] - 46.0) / monsterBodyHeight[self.monsterType]) * 0.2 + 1.0;
            if (scaleRate < 1.0) {
                scaleRate = 1.0;
            }
            [self setScaleY:1.1];
        }
        
        if (self.position.y >= (self.monsterBodyCounter + 0.5) * monsterBodyHeight[self.monsterType] + 46.0
            && self.position.y < (self.monsterBodyCounter + 1) * monsterBodyHeight[self.monsterType] + 46.0                && self.isMovingUp) {
            
            if (self.isNeedAutoMoving) {
                
                [self createMonsterBodyInPosition:CGPointMake(self.position.x,46.0)
                                   andMonsterType:self.monsterType];
                
                self.isNeedAutoMoving = NO;
            }
            
            float distance = (self.monsterBodyCounter + 1) * monsterBodyHeight[self.monsterType] + 46.0 - self.position.y;
            
            [self changePositionInDistance:distance andSprite:self];
            
#pragma mark 拖动到临界值时移动MonsterBody
            for (int i = 0; i < [self.monsterBodyArray count]; ++ i) {
                P3_MonsterBody * body = (P3_MonsterBody *)[self.monsterBodyArray objectAtIndex:i];
                float distance = (self.monsterBodyCounter - i) * monsterBodyHeight[self.monsterType] + 46.0 - body.position.y;
                
                [self changePositionInDistance:distance andSprite:body];
            }
        }
#pragma mark 已过新一个MonsterBody底线
        else if ((fabsf(self.position.y - (self.monsterBodyCounter + 1) * monsterBodyHeight[self.monsterType] - 46.0) < 1.0 ||
                  self.position.y > (self.monsterBodyCounter + 1) * monsterBodyHeight[self.monsterType] + 46.0) &&
                 self.isMovingUp)
        {
            ++ self.monsterBodyCounter;
            self.isNeedAutoMoving = YES;
        }
#pragma mark 向下压缩
        else if (self.position.y < (self.monsterBodyCounter) *
                 monsterBodyHeight[self.monsterType] + 46.0 &&
                 self.position.y > (self.monsterBodyCounter - 0.5) *
                 monsterBodyHeight[self.monsterType] + 46.0 &&
                 !self.isMovingUp) {
            
            float movingDistance = (self.monsterBodyCounter) *
            monsterBodyHeight[self.monsterType] + 46.0 - self.position.y;
            
            float sum = (1 - powf(0.95, [self.monsterBodyArray count])) / (1 - 0.95);
            float groundMonsterDistance = movingDistance / sum;
            
            float scaleRate = (monsterBodyHeight[self.monsterType] - groundMonsterDistance) / monsterBodyHeight[self.monsterType];
            
            
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
                
                
                float originalYPosition = ([self.monsterBodyArray count] - i) * monsterBodyHeight[self.monsterType] + 46.0;
                
                [body setPosition:CGPointMake(body.position.x, originalYPosition - bodyDistance)];
            }
        }
        else if (self.position.y <= (self.monsterBodyCounter - 0.5) * monsterBodyHeight[self.monsterType] + 46.0 &&
                 self.position.y > (self.monsterBodyCounter - 1.0) * monsterBodyHeight[self.monsterType] + 46.0 &&
                 !self.isMovingUp){
            
            float distance = (self.monsterBodyCounter - 1) * monsterBodyHeight[self.monsterType] + 46.0 - self.position.y;
            
            [self changePositionInDistance:distance andSprite:self];
            
            if ([self.monsterBodyArray count] >= self.monsterBodyCounter &&
                [self.monsterBodyArray count] > 0) {
                P3_MonsterBody * body = (P3_MonsterBody *)[self.monsterBodyArray objectAtIndex:self.monsterBodyCounter - 1];
                [body removeFromParentAndCleanup:YES];
                [self.monsterBodyArray removeObjectAtIndex:self.monsterBodyCounter - 1];
            }
            
            for (int i = 0; i < [self.monsterBodyArray count]; ++ i) {
                P3_MonsterBody * body = (P3_MonsterBody *)[self.monsterBodyArray objectAtIndex:i];
                float distance = ([self.monsterBodyArray count] - i) * monsterBodyHeight[self.monsterType] + 46.0 - body.position.y;
                
                [self changePositionInDistance:distance andSprite:body];
                
                float rateYDistance = (1.0 - body.scaleY);
                if (rateYDistance <= 0.0) {
                    rateYDistance = 0.0;
                }
                float rateXDistance = body.scaleX - 1.0;
                if (rateXDistance <= 0.0) {
                    rateXDistance = 0.0;
                }
                
                [self changeYScaleInScaleDistance:rateYDistance andSprite:body andIsAnchorPointZero:NO];
                [self changeXScaleInScaleDistance:rateXDistance andSprite:body];
            }
        }
        else if (self.position.y <= (self.monsterBodyCounter - 1.0) * monsterBodyHeight[self.monsterType] + 46.0 &&
                 !self.isMovingUp) {
            if (self.monsterBodyCounter > 0) {
                -- self.monsterBodyCounter;
            }
            
        }
    }
}

- (void)changeYScaleInScaleDistance:(float)distance
                          andSprite:(CCNode *)sprite
               andIsAnchorPointZero:(BOOL)isAPZero
{
    //锚点的位置影响位移 向下或向上
    if (fabsf(distance) > 0.15) {
        [sprite setScaleY:sprite.scaleY + distance / 6.0];
        [sprite setPosition:CGPointMake(sprite.position.x, sprite.position.y - monsterBodyHeight[self.monsterType] * distance / 6.0)];
    }
    else if (fabsf(distance) < 0.15 && fabsf(distance) > 0.025) {
        [sprite setScaleY:sprite.scaleY + 0.025];
        if (!isAPZero) {
            [sprite setPosition:CGPointMake(sprite.position.x, sprite.position.y - monsterBodyHeight[self.monsterType] * 0.025)];
        }
        else {
            [sprite setPosition:CGPointMake(sprite.position.x, sprite.position.y + monsterBodyHeight[self.monsterType] * 0.025)];
        }
        
    }
    else {
        [sprite setScaleY:sprite.scaleY + distance];
        [sprite setPosition:CGPointMake(sprite.position.x, sprite.position.y - monsterBodyHeight[self.monsterType] * distance)];
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
