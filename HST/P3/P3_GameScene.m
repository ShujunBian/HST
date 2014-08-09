//
//  P3_GameScene.m
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright 2013年 Emerson. All rights reserved.
//

#import "P3_GameScene.h"
#import "CCBAnimationManager.h"
#import "MainMapHelper.h"
#import "HelloWorldLayer.h"

#import "P3_Monster.h"
#import "P3_MonsterBody.h"
#import "P3_BlueMonster.h"
#import "P3_PurpMonster.h"
#import "P3_GreenMonster.h"
#import "P3_RedMonster.h"
#import "P3_CeruleanMonster.h"
#import "CircleTransition.h"
#import "CCLayer+CircleTransitionExtension.h"

@interface P3_GameScene ()

@property (nonatomic, strong) MainMapHelper * mainMapHelper;
@property (nonatomic, strong) NSMutableArray * monsterArray;

@end

@implementation P3_GameScene

@synthesize monsterLayer;

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)didLoadFromCCB
{
    self.mainMapHelper = [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 727.0)];
    
    self.monsterArray = [NSMutableArray arrayWithCapacity:5];
    [self initMonsters];
    [self setTouchEnabled:NO];
    [self performSelector:@selector(resetTouchEnable) withObject:self
               afterDelay:1.2];
}
- (void)onExit
{
    [self.monsterArray removeAllObjects];
    self.monsterArray = nil;
    self.mainMapHelper = nil;
    
    [super onExit];
}

#pragma mark - 初始化Monsters
- (void)initMonsters
{
    P3_PurpMonster * purpMonster = (P3_PurpMonster *)[CCBReader nodeGraphFromFile:@"P3_PurpMonster.ccbi"];
    [monsterLayer addChild:purpMonster z:0];
    [purpMonster setPosition:monsterFirstPositions[0]];
    [purpMonster createMonsterWithType:PurpMonster];
    [purpMonster initMonsterEyes];
    [_monsterArray addObject:purpMonster];
    
    P3_BlueMonster * blueMonster = (P3_BlueMonster *)[CCBReader nodeGraphFromFile:@"P3_BlueMonster.ccbi"];
    [monsterLayer addChild:blueMonster z:-1];
    [blueMonster setPosition:monsterFirstPositions[1]];
    [blueMonster createMonsterWithType:BlueMonster];
    [blueMonster initMonsterEyes];
    [_monsterArray addObject:blueMonster];
    
    P3_GreenMonster * greenMonster = (P3_GreenMonster *)[CCBReader nodeGraphFromFile:@"P3_GreenMonster.ccbi"];
    [monsterLayer addChild:greenMonster z:-2];
    [greenMonster setPosition:monsterFirstPositions[2]];
    [greenMonster createMonsterWithType:GreenMonster];
    [greenMonster initMonsterEyes];
    [_monsterArray addObject:greenMonster];
    
    P3_RedMonster * redMonster = (P3_RedMonster *)[CCBReader nodeGraphFromFile:@"P3_RedMonster.ccbi"];
    [monsterLayer addChild:redMonster z:-1];
    [redMonster setPosition:monsterFirstPositions[3]];
    [redMonster createMonsterWithType:RedMonster];
    [redMonster initMonsterEyes];
    [_monsterArray addObject:redMonster];
    
    P3_CeruleanMonster * ceruleanMonster = (P3_CeruleanMonster *)[CCBReader nodeGraphFromFile:@"P3_CeruleanMonster.ccbi"];
    [monsterLayer addChild:ceruleanMonster z:0];
    [ceruleanMonster setPosition:monsterFirstPositions[4]];
    [ceruleanMonster createMonsterWithType:CeruleanMonster];
    [ceruleanMonster initMonsterEyes];
    [_monsterArray addObject:ceruleanMonster];
}

- (void)onEnter
{
    [super onEnter];
    [self showScene];
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    for (int i = 0; i < [_monsterArray count]; ++ i) {
        P3_Monster * monster = (P3_Monster *)[_monsterArray objectAtIndex:i];
        [monster beginningAnimationInDelayTime:0.4 + 0.2 * i];
    }
    
}

#pragma mark - 恢复触摸
- (void)resetTouchEnable
{
    [self setTouchEnabled:YES];
}

#pragma mark - 触摸事件

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch* touch in touches)
    {
        CGPoint touchPosition = [self locationFromTouch:touch];
        for (P3_Monster * monster in _monsterArray) {
            if ([self isInAreaByPoint:touchPosition
                      areaCenterPoint:monster.position
                             andWidth:monster.contentSize.width
                            andHeight:monster.contentSize.height]) {
                monster.isChoosen = YES;
                
                if (monster.position.y == kMonsterBaselineYPosition) {
                    if (monster.monsterType != GreenMonster) {
                        [monster setPosition:CGPointMake(monster.position.x, monster.position.y + 20.0)];
                        CCScaleTo * scaleTo = [CCScaleTo actionWithDuration:0.05 scale:1.1];
                        CCScaleTo * scaleBack = [CCScaleTo actionWithDuration:0.05 scale:1.0];
                        CCSequence * seq = [CCSequence actions:scaleTo, scaleBack, nil];
                        [monster runAction:seq];
                    }
                    else {

                        CCScaleTo * scaleTo = [CCScaleTo actionWithDuration:0.1 scale:1.02];
                        CCScaleTo * scaleBack = [CCScaleTo actionWithDuration:0.1 scale:1.0];
                        CCSequence * seq = [CCSequence actions:scaleTo, scaleBack, nil];
                        [monster runAction:seq];
                    }

                }
                
                monster.oldTouchPosition = touchPosition;
            }
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches)
    {
        
        CGPoint touchPosition = [self locationFromTouch:touch];
        for (P3_Monster * monster in _monsterArray) {
            if ([self isInWidthByPoint:touchPosition
                       areaCenterPoint:monster.position
                              andWidth:monster.contentSize.width]
                && monster.isChoosen)
            {
                if (monster.isStartMoving) {
                    if (touchPosition.y > monster.oldTouchPosition.y) {
                        monster.movingType = MovingUp;
                    }
                    else if (touchPosition.y < monster.oldTouchPosition.y) {
                        monster.movingType = MovingDown;
                    }
                    monster.isStartMoving = NO;
                }
                
                if ((touchPosition.y > monster.oldTouchPosition.y &&
                     monster.movingType == MovingUp) ||
                    (touchPosition.y < monster.oldTouchPosition.y &&
                     monster.movingType == MovingDown)) {
                        if (monster.isChoosen) {
                            
                            float moveDistance = touchPosition.y - monster.oldTouchPosition.y;
                            BOOL isSpeedFast;
                            
                            if (monster.movingType == MovingUp) {
                                if (moveDistance > 15.0) {
                                    moveDistance = 15.0;
                                    isSpeedFast = YES;
                                }
                                else {
                                    isSpeedFast = NO;
                                }
                                
                                //对monster高度拖动的限制 不能高于4.4倍身体高度 + 46.0基础高度
                                if (monster.position.y + moveDistance > 4.4 * monsterBodyHeight[monster.monsterType] + kMonsterBaselineYPosition) {
                                    moveDistance = 4.4 * monsterBodyHeight[monster.monsterType] + kMonsterBaselineYPosition - monster.position.y;
                                }
                                
                                CGPoint newPosition = CGPointMake(monster.position.x,
                                                                  monster.position.y + moveDistance);
                                //绿色怪物不能拖动
                                if (monster.monsterType != GreenMonster) {
                                    [monster setPosition:newPosition];
                                }
                                
                                for (int i = 0; i < [monster.monsterBodyArray count]; ++ i) {
                                    P3_MonsterBody * body = (P3_MonsterBody *)[monster.monsterBodyArray objectAtIndex:i];
                                    CGPoint newMonsterBodyPosition = CGPointMake(body.position.x,body.position.y + moveDistance * (0.9 - i * 0.1));
                                    [body setPosition:newMonsterBodyPosition];
                                }
                                
                                //                                if (!isSpeedFast) {
                                monster.oldTouchPosition = touchPosition;
                                //                                }
                                //                                else {
                                //                                    monster.oldTouchPosition = newPosition;
                                //                                }
                            }
                            else if (monster.movingType == MovingDown){
                                if (moveDistance < -15.0) {
                                    moveDistance = -15.0;
                                    isSpeedFast = YES;
                                }
                                else {
                                    isSpeedFast = NO;
                                }
                                
                                //对monster高度拖动的限制 不能低于46.0基础高度
                                if (monster.position.y + moveDistance < kMonsterBaselineYPosition) {
                                    moveDistance = kMonsterBaselineYPosition - monster.position.y;
                                }
                                
                                CGPoint newPosition = CGPointMake(monster.position.x,
                                                                  monster.position.y + moveDistance);
                                [monster setPosition:newPosition];
                                
                                //                                if (!isSpeedFast) {
                                monster.oldTouchPosition = touchPosition;
                                //                                }
                                //                                else {
                                //                                    monster.oldTouchPosition = newPosition;
                                //                                }
                                
                            }
                            
                        }
                    }
            }
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for (UITouch * touch in touches)
    {
        CGPoint touchPosition = [self locationFromTouch:touch];
        for (P3_Monster * monster in _monsterArray) {
            if (monster.isChoosen) {
                [self setTouchEnabled:NO];
                
                if (monster.monsterType != GreenMonster) {
                    CCScaleTo * scaleAfterJump1 = [CCScaleTo actionWithDuration:0.05 scaleX:1.05 scaleY:0.95];
                    CCScaleTo * scaleAfterJump2 = [CCScaleTo actionWithDuration:0.05 scaleX:0.95 scaleY:1.05];
                    CCScaleTo * scaleAfterJump3 = [CCScaleTo actionWithDuration:0.05 scaleX:1.0 scaleY:1.0];
                    
                    CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
                        [self setTouchEnabled:YES];
                    }];
                    
                    CCSequence * seq = [CCSequence actions:
                                        scaleAfterJump1,
                                        scaleAfterJump2,
                                        scaleAfterJump3,
                                        callBack,
                                        nil];
                    
                    [monster runAction:seq];
                }
                else {
                        CCScaleTo * scaleAfterJump1 = [CCScaleTo actionWithDuration:0.1 scaleX:1.02 scaleY:0.98];
                        CCScaleTo * scaleAfterJump2 = [CCScaleTo actionWithDuration:0.1 scaleX:0.98 scaleY:1.02];
                        CCScaleTo * scaleAfterJump3 = [CCScaleTo actionWithDuration:0.1 scaleX:1.0 scaleY:1.0];
                        
                        CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
                            [self setTouchEnabled:YES];
                        }];
                        
                        CCSequence * seq = [CCSequence actions:
                                            scaleAfterJump1,
                                            scaleAfterJump2,
                                            scaleAfterJump3,
                                            callBack,
                                            nil];
                        
                        [monster runAction:seq];
                }

                
                
                monster.isChoosen = NO;
            }
        }
    }
}

#pragma mark - 转换touch坐标
-(CGPoint) locationFromTouch:(UITouch*)touch
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

#pragma mark - 检测是否在某一区域之中
//锚点为(0.5,0.0) 所以检测高度时不需要减 只需要加
- (BOOL) isInAreaByPoint:(CGPoint)point
         areaCenterPoint:(CGPoint)centerPoint
                andWidth:(float)width
               andHeight:(float)height
{
    if (point.x <= centerPoint.x + width / 2.0 &&
        point.x >= centerPoint.x - width / 2.0) {
        if (point.y <= centerPoint.y + height &&
            point.y >= centerPoint.y) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) isInWidthByPoint:(CGPoint)point
          areaCenterPoint:(CGPoint)centerPoint
                 andWidth:(float)width
{
    if (point.x <= centerPoint.x + width / 2.0 &&
        point.x >= centerPoint.x - width / 2.0) {
        return YES;
    }
    return NO;
}

#pragma mark - 菜单键调用函数
- (void)restartGameScene
{
}

- (void)returnToMainMap
{
//    [_mainMapHelper release];
    [self unscheduleAllSelectors];
    for (CCNode * child in [self children]) {
        [child stopAllActions];
        [child unscheduleAllSelectors];
    }
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"world.ccbi"];
    [self changeToScene:scene];
//    [[CCDirector sharedDirector] replaceScene:
//     [CircleTransition transitionWithDuration:1.0
//                                        scene:scene]];
}

@end