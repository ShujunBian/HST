//
//  P5_Monster.h
//  Dig
//
//  Created by Emerson on 14-1-26.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import "CCBAnimationManager.h"

@class P5_MonsterEye;

@protocol P5_MonsterDelegate <NSObject>

@optional

- (void)monsterArriveTheStartHole;

- (void)monsterArriveTheFinalHole;

@end


@interface P5_Monster : CCNode<CCBAnimationManagerDelegate>

@property (nonatomic, strong) P5_MonsterEye * monsterEye;
@property (nonatomic, strong) CCSprite * leftLeg;
@property (nonatomic, strong) CCSprite * rightLeg;
@property (nonatomic, strong) CCSprite * body;
@property (nonatomic, strong) CCSprite * mouth;
@property (nonatomic, strong) CCSprite * bigShadow;
@property (nonatomic, strong) CCSprite * littleShadow;
@property (nonatomic) BOOL isArriveHome;
@property (nonatomic) BOOL isReadyStart;
@property (nonatomic) BOOL isCreatingPassage;
@property (nonatomic) BOOL isUpground;

@property (nonatomic, assign) id<P5_MonsterDelegate> delegate;

- (void)rollUpground;
- (void)moveToUnderground;
- (void)startRoll;
- (void)rollfromPoint1:(CGPoint)point1 toPoint2:(CGPoint)point2;
- (void)arriveHome;

@end
