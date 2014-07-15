//
//  P3_Monster1.m
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright 2014年 Emerson. All rights reserved.
//

#import "P3_Monster.h"

@implementation P3_Monster

@synthesize monsterMouth;
@synthesize monsterBody;

- (id)init
{
    if (self = [super init]) {
        self.oldTouchPosition = monsterFirstPositions[self.monsterType];
        self.isStartMoving = YES;
        self.isJumping = NO;
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

- (void)jumpBackToPointByMonsterType:(MonsterType)monsterType
{
    int latestPointNumber = [self theLatestPointByCenterPoint:self.position
                                            monsterBodyHeight:monsterBodyHeight[monsterType]];

    [self jumpAnimationWithMonsterBodyCounter:latestPointNumber monsterType:monsterType];
    
}

- (void)jumpAnimationWithMonsterBodyCounter:(int)monsterBodyCounter
                                monsterType:(MonsterType)monsterType
{
    CGPoint destinationPoint = CGPointMake(self.position.x,  monsterBodyCounter * monsterBodyHeight[monsterType] + 46.0);
    //46.0为小怪物统一的初始高度
    float moveDistance = fabsf(destinationPoint.y - self.position.y);
    float maxDistance = monsterBodyHeight[monsterType];
    float movingTime = moveDistance / maxDistance * 0.2;
    
    CCMoveTo * moveBackToPoint = [CCMoveTo actionWithDuration:(movingTime)  position:destinationPoint];
    CCScaleTo * scaleAfterJump1 = [CCScaleTo actionWithDuration:0.1 scaleX:1.05 scaleY:0.95];
    CCScaleTo * scaleAfterJump2 = [CCScaleTo actionWithDuration:0.1 scaleX:0.95 scaleY:1.05];
    CCScaleTo * scaleAfterJump3 = [CCScaleTo actionWithDuration:0.1 scaleX:1.0 scaleY:1.0];
//    CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
//        self.isJumping = NO;
//    }];
//    
    CCSequence * seq = [CCSequence actions:moveBackToPoint,
                        scaleAfterJump1,
                        scaleAfterJump2,
                        scaleAfterJump3,
//                        callBack,
                        nil];
    
    [self runAction:seq];
}

- (void)monsterBodyJumpAnimation:(CCSprite *)body
                     BodyCounter:(int)monsterBodyCounter
                     monsterType:(MonsterType)monsterType
{
    CGPoint destinationPoint = CGPointMake(self.position.x,  monsterBodyCounter * monsterBodyHeight[monsterType] + 46.0);
    //46.0为小怪物统一的初始高度

    float movingTime = 0.1;
    
    CCMoveTo * moveBackToPoint = [CCMoveTo actionWithDuration:(movingTime)  position:destinationPoint];
    CCScaleTo * scaleAfterJump1 = [CCScaleTo actionWithDuration:0.1 scaleX:1.05 scaleY:0.95];
    CCScaleTo * scaleAfterJump2 = [CCScaleTo actionWithDuration:0.1 scaleX:0.95 scaleY:1.05];
    CCScaleTo * scaleAfterJump3 = [CCScaleTo actionWithDuration:0.1 scaleX:1.0 scaleY:1.0];
    CCSequence * seq = [CCSequence actions:moveBackToPoint,
                        scaleAfterJump1,
                        scaleAfterJump2,
                        scaleAfterJump3,
                        nil];
    
    [body runAction:seq];
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
               ByMonsterBodyCounter:(int)monsterBodyCounter
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
    
    CCSprite * newMonsterBody = (CCSprite *)[CCBReader nodeGraphFromFile:fileName];
    [newMonsterBody setAnchorPoint:CGPointMake(0.5, 0.0)];
    [newMonsterBody setPosition:position];
    [newMonsterBody setScale:0.0];
    [self.parent addChild:newMonsterBody];
    [self.monsterBodyArray addObject:newMonsterBody];
    
    CCScaleTo * scaleBack = [CCScaleTo actionWithDuration:0.2 scale:1.0];
    [newMonsterBody runAction:scaleBack];
}

- (void)update:(ccTime)delta
{
    if (self.isChoosen) {
        
        if ([self.monsterBodyArray count] == 0) {
            NSLog(@"THe posi is %f",self.position.y);
            if (self.position.y >= (self.monsterBodyCounter + 0.5) * monsterBodyHeight[self.monsterType] + 46.0
                && self.isMovingUp) {
                
                [self createMonsterBodyInPosition:CGPointMake(self.position.x,46.0)
                             ByMonsterBodyCounter:self.monsterBodyCounter
                                   andMonsterType:self.monsterType];
            }
            
            if (self.position.y >= (self.monsterBodyCounter + 0.5) * monsterBodyHeight[self.monsterType] + 46.0
                && self.isMovingUp) {
                
                ++ self.monsterBodyCounter;
                [self jumpAnimationWithMonsterBodyCounter:self.monsterBodyCounter monsterType:self.monsterType];
                
                self.oldTouchPosition = CGPointMake(self.position.x,self.monsterBodyCounter * monsterBodyHeight[self.monsterType] + 46.0);
                
            }
            else if (self.position.y < (self.monsterBodyCounter - 0.5) * monsterBodyHeight[self.monsterType] + 46.0 &&
                     !self.isMovingUp){
                if (self.monsterBodyCounter > 0) {
                    -- self.monsterBodyCounter;
                }
                
            }
        }
        else {
            CCSprite * body = (CCSprite *)[self.monsterBodyArray objectAtIndex:([self.monsterBodyArray count] - 1)];
            if (body.position.y >= 1.0/3.0 * monsterBodyHeight[self.monsterType] + 46.0
                && self.isMovingUp) {
                ++ self.monsterBodyCounter;
                [self jumpAnimationWithMonsterBodyCounter:self.monsterBodyCounter monsterType:self.monsterType];
                
                for (int i = 0 ; i < [self.monsterBodyArray count]; ++ i) {
                    CCSprite * body = (CCSprite *)[self.monsterBodyArray objectAtIndex:i];
                    [self monsterBodyJumpAnimation:body
                                       BodyCounter:(self.monsterBodyCounter - i - 1)
                                       monsterType:self.monsterType];
                }
                
                [self createMonsterBodyInPosition:CGPointMake(self.position.x,46.0)
                             ByMonsterBodyCounter:self.monsterBodyCounter
                                   andMonsterType:self.monsterType];
                
                self.oldTouchPosition = CGPointMake(self.position.x,self.monsterBodyCounter * monsterBodyHeight[self.monsterType] + 46.0);
                
            }
            else if (body.position.y < 0.5 * monsterBodyHeight[self.monsterType] + 46.0 &&
                     !self.isMovingUp){
                if (self.monsterBodyCounter > 0) {
                    -- self.monsterBodyCounter;
                }
            }
        }
    }
}
@end
