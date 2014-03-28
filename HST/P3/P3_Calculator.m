//
//  P3_Calculator.m
//  sing
//
//  Created by Pursue_finky on 13-12-12.
//  Copyright (c) 2013年 mhc. All rights reserved.
//

#import "P3_Calculator.h"



@implementation P3_Calculator




+(BOOL)judgeGestureIsVerticalOrNot:(CGPoint)tranlation{
    
    float tan = tranlation.x / tranlation .y;
    
    if( tan < 1 && tan > -1)
        return YES;
    else
        return NO;
}

+(ccColor3B)getMonster_1_Color
{
    ccColor3B color = {255,145,248};
    
    return color;
}

@end
