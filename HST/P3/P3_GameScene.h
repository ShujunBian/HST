//
//  MyCocos2DClass.m
//  sing
//
//  Created by Pursue_finky on 13-12-9.
//  Copyright 2013年 mhc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBReader.h"
#import "P3_Monster_1.h"
#import "P3_Monster_2.h"
#import "P3_Monster_3.h"
#import "P3_Monster_4.h"
#import "P3_Monster_5.h"

@class P3_grass;


@interface P3_Main_Scene : CCLayer {
    
    int touchId;
    int canTouch;
    
    CGPoint oldTouchRecord;
    
}

@property (strong,nonatomic) P3_grass *grass;

@property (strong,nonatomic) P3_Monster_1 *monster_1;
@property (strong,nonatomic) P3_Monster_2 *monster_2;
@property (strong,nonatomic) P3_Monster_3 *monster_3;
@property (strong,nonatomic) P3_Monster_4 *monster_4;
@property (strong,nonatomic) P3_Monster_5 *monster_5;

@property(nonatomic,strong) P3_RemoveEffects *effects;


@end
