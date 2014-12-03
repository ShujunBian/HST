//
//  P3_MonsterBody.h
//  HST
//
//  Created by Emerson on 14-7-17.
//  Copyright 2014年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "P3_Monster.h"

@interface P3_MonsterBody : CCNode {
    
}

@property (nonatomic, assign) CCSprite *body;

@property (nonatomic, strong) CCSprite *leftEye;
@property (nonatomic, strong) CCSprite *rightEye;
@property (nonatomic, strong) CCSprite *mouth;

@property (nonatomic) MonsterType monsterType;

- (void)initMonsterBodyEyesAndMouth;
- (void)startMouthAnimation;
- (void)stopMouthAnimation;
@end
