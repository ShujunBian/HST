//
//  P3_Monster_5_Body.m
//  sing
//
//  Created by pursue_finky on 14-1-27.
//  Copyright (c) 2014年 mhc. All rights reserved.
//

#import "P3_Monster_5_Body.h"

@implementation P3_Monster_5_Body
@synthesize monsterBody;
@synthesize monsterBodyEye;
@synthesize monsterBodyMouth;



-(id)initWithPosition:(CGPoint)postion
{
    if(self != nil)
    {
        monsterBody = [CCSprite spriteWithFile:@"P3_Monster5_Body.png"];
        
        [monsterBody setAnchorPoint:CGPointMake(0.5, 0)];
        
        monsterBodyEye = [CCSprite spriteWithFile:@"P3_Monster_Body_Eye.png"];
        
        [monsterBodyEye setScale:0.55f];
        
        [monsterBodyEye setPosition:CGPointMake(51.5, 51.5)];
        
        monsterBodyMouth = [CCSprite spriteWithFile:@"P3_Monster_body_mouth.png"];
        
        [monsterBodyMouth setScale:0.4f];
        
        [monsterBodyMouth setPosition:CGPointMake(51.5, 30)];
        
        [monsterBody addChild:monsterBodyEye];
        [monsterBody addChild:monsterBodyMouth];
        
        [monsterBody setPosition:postion];
        
    }
    return self;

}
@end
