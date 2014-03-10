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

@property (nonatomic,retain) CCSprite *teeth;
@property (nonatomic,retain) CCSprite *mouthMask;
@property (nonatomic,retain) CCSprite *body;
@property (nonatomic,retain) CCSprite *lefthand;
@property (nonatomic,retain) P1_MonsterEye *eye;

- (void)smallMouth;
- (void)bigMouth;

@end
