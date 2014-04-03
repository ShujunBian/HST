//
//  P3_Monster_3_Body.m
//  sing
//
//  Created by pursue_finky on 14-1-27.
//  Copyright (c) 2014年 mhc. All rights reserved.
//

#import "P3_Monster_3_Body.h"

@implementation P3_Monster_3_Body
@synthesize monsterBody;
@synthesize monsterBodyEye;
@synthesize monsterBodyMouth;



-(id)initWithPosition:(CGPoint)postion
{
    if(self != nil)
    {
        monsterBody = [CCSprite spriteWithFile:@"P3_Monster3_Body.png"];
        
        [monsterBody setAnchorPoint:CGPointMake(0.5, 0)];
        
        monsterBodyEye = [CCSprite spriteWithFile:@"P3_Monster_Body_Eye.png"];
        
        [monsterBodyEye setPosition:CGPointMake(113, 51.5)];
        
        monsterBodyMouth = [CCSprite spriteWithFile:@"P3_Monster_body_mouth.png"];
        
        [monsterBodyMouth setPosition:CGPointMake(113, 30)];
        
        [monsterBody addChild:monsterBodyEye];
        [monsterBody addChild:monsterBodyMouth];
        
        [monsterBody setPosition:postion];
        
    }
    return self;
}

@end
