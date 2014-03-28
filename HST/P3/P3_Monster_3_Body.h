//
//  P3_Monster_3_Body.h
//  sing
//
//  Created by pursue_finky on 14-1-27.
//  Copyright (c) 2014年 mhc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P3_Monster_3_Body : NSObject
{
}

@property(nonatomic,strong) CCSprite *monsterBody;

@property(nonatomic,strong) CCSprite *monsterBodyMouth;

@property(nonatomic,strong) CCSprite *monsterBodySingMouth;

@property(nonatomic,strong) CCSprite *monsterBodyEye;

-(id)initWithPosition:(CGPoint)postion;

@end
