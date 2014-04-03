//
//  P3_Monster_2.h
//  sing
//
//  Created by pursue_finky on 14-1-27.
//  Copyright (c) 2014年 mhc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "P3_Monster_2_Body.h"
#import "P3_Calculator.h"



@interface P3_Monster_2 : NSObject {
    
    CCSprite *monsterEye;
    
    CCSprite *monsterEyePoint;
    
    CCSprite *monsterAnotherEye;
    
    CCSprite *monsterAnotherEyePoint;
    
    CCSprite *monsterThirdEye;
    
    CCSprite *monsterThirdEyePoint;
    
    CCSprite *monsterSingMouth;
    
    
    enum status currentStatus;
    
    int times;
    
    float curHeight;
    
}

@property(strong,nonatomic) CCNode * node;

@property(strong,nonatomic) CCSprite * monsterMouth;

@property(strong,nonatomic) NSMutableArray * monsterEyeArray;

@property(strong,nonatomic) CCSprite * monsterFace;

@property(strong,nonatomic) NSMutableArray *monsterBody;

@property(strong ,nonatomic) CCSprite * monster;




-(id)initWithNode:(CCNode *)node;

-(BOOL)createAMonsterBodyWithTranslation:(CGPoint)translation;

-(BOOL)removeMonsterBodyWithTranslation:(CGPoint)translation;

-(void)performActionForSing;

-(void)revertToPrim;


@end
