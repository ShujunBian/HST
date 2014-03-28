//
//  P4Extension.m
//  hst_p4
//
//  Created by wxy325 on 1/26/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "P4Extension.h"

BOOL colorCompare(ccColor3B c1, ccColor3B c2)
{
    return (c1.r == c2.r) && (c1.g == c2.g) && (c1.b == c2.b);
}

float colorChange(float colorFrom, float colorTo, float speed)
{
    float r;
    if (colorFrom < colorTo)
    {
        r = (colorFrom + speed) < colorTo ? (colorFrom + speed) : colorTo;
    }
    else
    {
        r = (colorFrom - speed) > colorTo ? (colorFrom - speed) : colorTo;
    }
    return r;
}

float maxThree(float a, float b, float c)
{
    return max(max(a, b),c);
}
float minThree(float a, float b, float c)
{
    return min(min(a, b), c);
}