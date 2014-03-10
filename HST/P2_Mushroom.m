//
//  Mushroom.m
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_Mushroom.h"
#define RESETDISTANCE 80
#define MINDISTANCE 80
@implementation P2_Mushroom

-(BOOL)isSamePositionWithFlower:(P2_Flower *)flower
{
    float currentDistance = self.position.x - flower.position.x;
    if ( currentDistance < MINDISTANCE && currentDistance > -MINDISTANCE) {
        return YES;
    }
    else
        return false;
}

-(void)resetFlowerPosition:(P2_Flower *)flower
{
    [flower setPosition:(CGPointMake(flower.position.x + RESETDISTANCE, flower.position.y))];
}

@end
