//
//  P3_Calculator.m
//  sing
//
//  Created by Pursue_finky on 13-12-12.
//  Copyright (c) 2013年 mhc. All rights reserved.
//

#import "P3_Calculator.h"



@implementation P3_Calculator

static ccColor3B monsterColors[] = {
    {255, 145, 248},//1
    {76,211,255},//2
    {84,249,46},//3
    {255,70,100},//4
    {29,255,247},//5
   
};


+(BOOL)judgeGestureIsVerticalOrNot:(CGPoint)tranlation{
    
    float tan = tranlation.x / tranlation .y;
    
    if( tan < 1 && tan > -1)
        return YES;
    else
        return NO;
}

+(ccColor3B)getMonsterColor:(int)monster_id
{
    ccColor3B color = monsterColors[monster_id -1];
    
    return color;
}

@end
