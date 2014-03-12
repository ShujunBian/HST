//
//  Monster.h
//  town
//
//  Created by Song on 13-7-28.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "P1_MonsterEye.h"

@class P1_Monster;
@protocol P1_MonsterDelegate <NSObject>

-(void)monsterMouthStartBlow:(P1_Monster*)monster;
-(void)monsterMouthEndBlow:(P1_Monster*)monster;

@end

@interface P1_Monster : CCNode
{
    CCSprite *maskedMouth;
    CCSprite *mouthBlack;
    CCSprite *mouthSmall;
    
    CCSprite *leftHandReal;
    
    
    ccTime totalBlinkTime;
}


@property (nonatomic,assign) id<P1_MonsterDelegate> delegate;

@property (nonatomic, assign) CCSprite *teeth;
@property (nonatomic, assign) CCSprite *mouthMask;
@property (nonatomic, assign) CCSprite *body;
@property (nonatomic, assign) CCSprite *lefthand;
@property (nonatomic, assign) P1_MonsterEye *eye;

- (void)smallMouth;
- (void)bigMouth;

@end
