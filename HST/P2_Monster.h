//
//  Monster.h
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@class MonsterEye;
@class P2_LittleFlyObjects;

@interface P2_Monster : CCNode
{
    BOOL isReadyToJump;
    BOOL isReadyToDown;
    BOOL isMovingEyes;
    BOOL isToBuffer;
    float jumpTime;
    float bufferTime;
    float downSpeed;
    int theIdleTimes;
//    CCBAnimationManager* eyesAnimationManager;
//    CCBAnimationManager* selfAnimationManager;
}

@property (nonatomic, assign) CCSprite * monsterHead;
@property (nonatomic, assign) CCSprite * monsterBody;
@property (nonatomic, strong) MonsterEye * monsterEye;
@property (nonatomic) BOOL isFinishJump;
@property (nonatomic) float currentJumpTime;
@property (nonatomic) BOOL isInMainMap;

//@property (strong, nonatomic) CCBAnimationManager* selfAnimationManager;

- (void)littleJump;

- (void)monsterReadyToJump;
-(void)handleCollision;

@end
