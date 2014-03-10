//
//  LittleMonster.h
//  jump
//
//  Created by Emerson on 13-9-2.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@class P2_MonsterEye;

@interface P2_LittleMonster : CCNode<CCBAnimationManagerDelegate>
{
    BOOL isReadyToJump;
    BOOL isReadyToDown;
    BOOL isRunningEyeMoving;
    float theIdleTimes;
    float jumpTime;
    float downSpeed;
    CCBAnimationManager * selfAnimationManager;
    CCBAnimationManager * eyesAnimationManager;
}

@property (nonatomic, strong) P2_MonsterEye * littleMonsterEye;
@property (nonatomic) BOOL isFinishJump;

@end
