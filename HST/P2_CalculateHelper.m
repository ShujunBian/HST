//
//  CalculateHelper.m
//  jump
//
//  Created by Emerson on 13-9-3.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_CalculateHelper.h"
#define EVERYDELTATIME 0.016667

@implementation P2_CalculateHelper

+(float)getTheRestFrameForMonsterMoveWith:(float)height
{
    //ax^2 + bx + c = 0;
    float a , b;
    a = 2.5;
    b = -55.0;
    return (int)(((-b) - sqrtf(b * b - 4 * a * (400 - height))) / 5);
}

+(float)getTheMonsterCollisionHeightFrom:(int)frame
{
    if (frame >= 0 && frame <= 24) {
        return (2.18 * frame + 195.16);
    }
    else if(frame > 24 && frame <= 40)
    {
        return -0.595 * frame + 261.8;
    }
    else
    {
        NSLog(@"Get the Monster collision height is WRONG");
        return 0.0;
    }
}

+(int)getMonsterCurrentJumpFrameBy:(float)currentJumpTime
{
    int frame = (int)(currentJumpTime / EVERYDELTATIME);
    if (frame >= 40) {
        frame = 40;
    }
    return frame;
}


@end
