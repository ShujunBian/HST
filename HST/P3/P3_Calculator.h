//
//  P3_Calculator.h
//  sing
//
//  Created by Pursue_finky on 13-12-12.
//  Copyright (c) 2013年 mhc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"



@interface P3_Calculator : NSObject

#define MONSTER_1_COLOR [P3_Calculator getMonster_1_Color]

+(BOOL)judgeGestureIsVerticalOrNot:(CGPoint)tranlation;
+(ccColor3B)getMonster_1_Color;

@end
