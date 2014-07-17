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

@interface P3_GameScene ()

@property (nonatomic, assign) MainMapHelper * mainMapHelper;

@property (nonatomic, strong) NSMutableArray * monsterArray;
//@property (nonatomic) CGPoint oldTouchPosition; //用来记录上一次touch之后的位置和新的touch位置计算差之后移动小怪物
//@property (nonatomic) BOOL isMovingUp;//记录小怪物是向上移动还是向下移动 一次只能一个方向
//@property (nonatomic) BOOL isFirstMoving;//记录是否第一次移动 以确定方向

@end

@implementation P3_GameScene
{
    CCSprite * aa;
}
@synthesize monsterLayer;
- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)didLoadFromCCB
{
    _mainMapHelper = [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 727.0)];
    
    self.monsterArray = [NSMutableArray arrayWithCapacity:5];
    [self initMonsters];
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
                        monster.isMovingUp = YES;
                    }
                    else if (touchPosition.y < monster.oldTouchPosition.y) {
                        monster.isMovingUp = NO;
                    }
                    monster.isStartMoving = NO;
                }
                
                if ((touchPosition.y > monster.oldTouchPosition.y &&
                     monster.isMovingUp) ||
                    (touchPosition.y < monster.oldTouchPosition.y &&
                     !monster.isMovingUp)) {
                        if (monster.isChoosen && monster.monsterType != GreenMonster) {

                            float moveDistance = touchPosition.y - monster.oldTouchPosition.y;
                            BOOL isSpeedFast;
                            
                            if (monster.isMovingUp) {
                                if (moveDistance > 15.0) {
                                    moveDistance = 15.0;
                                    isSpeedFast = YES;
                                }
                                else {
                                    isSpeedFast = NO;
                                }
                                CGPoint newPosition = CGPointMake(monster.position.x,
                                                                  monster.position.y + moveDistance);
                                [monster setPosition:newPosition];
                                
                                for (int i = 0; i < [monster.monsterBodyArray count]; ++ i) {
                                    P3_MonsterBody * body = (P3_MonsterBody *)[monster.monsterBodyArray objectAtIndex:i];
                                    CGPoint newMonsterBodyPosition = CGPointMake(body.position.x,body.position.y + moveDistance * powf(0.8, i + 1));
                                    [body setPosition:newMonsterBodyPosition];
                                }
                                
                                if (!isSpeedFast) {
                                    monster.oldTouchPosition = touchPosition;
                                }
                                else {
                                    monster.oldTouchPosition = newPosition;
                                }
                            }
                            else {
                                if (moveDistance < -15.0) {
                                    moveDistance = -15.0;
                                    isSpeedFast = YES;
                                }
                                else {
                                    isSpeedFast = NO;
                                }
                                CGPoint newPosition = CGPointMake(monster.position.x,
                                                                  monster.position.y + moveDistance);
                                [monster setPosition:newPosition];
                                
                                if (!isSpeedFast) {
                                    monster.oldTouchPosition = touchPosition;
                                }
                                else {
                                    monster.oldTouchPosition = newPosition;
                                }
                                
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
        //CGPoint touchPosition = [self locationFromTouch:touch];
        for (P3_Monster * monster in _monsterArray) {
            if (monster.isChoosen) {
                [self setTouchEnabled:NO];
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

                
//                [monster jumpBackToPointByMonsterType:monster.monsterType];
//                NSLog(@"The backs afre positon");
//                NSLog(@"yhe mobnster position is %f",monster.position.y);
                
//                for (int i = 0 ; i < [monster.monsterBodyArray count]; ++ i) {
//                    CCSprite * body = (CCSprite *)[monster.monsterBodyArray objectAtIndex:i];
//                    [monster monsterBodyJumpAnimation:body
//                                       BodyCounter:(monster.monsterBodyCounter - i - 1)
//                                       monsterType:monster.monsterType];
//                }
                
                monster.isChoosen = NO;
//                monster.oldTouchPosition = monsterFirstPositions[monster.monsterType];
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
    [_mainMapHelper release];
    [self unscheduleAllSelectors];
    for (CCNode * child in [self children]) {
        [child stopAllActions];
        [child unscheduleAllSelectors];
    }
    
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFade transitionWithDuration:1.0
                                        scene:[HelloWorldLayer scene]]];
}

@end