//
//  Monster.h
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@class P2_MonsterEye;
@class P2_LittleFlyObjects;

@interface P2_Monster : CCNode <CCBAnimationManagerDelegate>
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

@property (nonatomic, assign) P2_MonsterEye * monsterEye;
@property (nonatomic, assign) CCSprite * monsterHead;
@property (nonatomic, assign) CCSprite * monsterBody;
@property (nonatomic) BOOL isFinishJump;
@property (nonatomic) float currentJumpTime;
@property (nonatomic) BOOL isInMainMap;
@property (strong, nonatomic) CCBAnimationManager* eyesAnimationManager;
@property (strong, nonatomic) CCBAnimationManager* selfAnimationManager;

- (void)littleJump;

- (void)monsterReadyToJump;
-(void)monsterCloseEyesWhenReadyToJump;
-(void)handleCollision;
- (void)releaseAnimationDelegate;

@end
