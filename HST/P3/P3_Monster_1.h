//
//  P3_Monster_1.h
//  sing
//
//  Created by Pursue_finky on 13-12-17.
//  Copyright 2013年 mhc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "P3_Monster_1_Body.h"
#import "P3_RemoveEffects.h"

enum status
{
    normalStatus = 0,
    compressStatus,
    strechStatus,
};


@interface P3_Monster_1 : NSObject {
    
    CCSprite *monsterEye;
    
    CCSprite *monsterEyePoint;
    
    CCSprite *monsterAnotherEye;
    
    CCSprite *monsterAnotherEyePoint;
    
    CCSprite *monsterSingMouth;
    
    int cHeight[6];
    
    int currentHeight;
    
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



@property CGPoint originPos;

@property float nextHeight;

-(id)initWithNode:(CCNode *)node;

-(BOOL)createAMonsterBodyWithTranslation:(CGPoint)translation;

-(int)removeMonsterBodyWithTranslation:(CGPoint)translation;

-(void)performActionForSing;

-(void)revertToPrim;



@end
