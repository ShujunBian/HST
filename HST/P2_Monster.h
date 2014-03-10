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
    CCBAnimationManager* eyesAnimationManager;
    CCBAnimationManager* selfAnimationManager;
}

@property (nonatomic, strong) P2_MonsterEye * monsterEye;
@property (nonatomic, strong) CCSprite * monsterHead;
@property (nonatomic, strong) CCSprite * monsterBody;
@property (nonatomic) BOOL isFinishJump;
@property (nonatomic) float currentJumpTime;

-(void)monsterCloseEyesWhenReadyToJump;
-(void)handleCollision;

@end
