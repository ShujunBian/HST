//
//  P3_Calculator.h
//  sing
//
//  Created by Pursue_finky on 13-12-12.
//  Copyright (c) 2013年 mhc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


enum status
{
    normalStatus = 0,
    compressStatus,
    strechStatus,
};


@interface P3_Calculator : NSObject

#define MONSTER_1_COLOR [P3_Calculator getMonsterColor:1]
#define MONSTER_2_COLOR [P3_Calculator getMonsterColor:2]
#define MONSTER_3_COLOR [P3_Calculator getMonsterColor:3]
#define MONSTER_4_COLOR [P3_Calculator getMonsterColor:4]
#define MONSTER_5_COLOR [P3_Calculator getMonsterColor:5]

+(BOOL)judgeGestureIsVerticalOrNot:(CGPoint)tranlation;
+(ccColor3B)getMonsterColor:(int)monster_id;

@end
