//
//  MonsterEyeTestLayer.m
//  HST
//
//  Created by wxy325 on 7/16/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "MonsterEyeTestLayer.h"
#import "cocos2d.h"
#import "MonsterEye.h"
#import "MonsterEyeUpdateObject.h"

@interface MonsterEyeTestLayer ()
@property (strong, nonatomic) MonsterEye* eye;
@property (strong, nonatomic) MonsterEyeUpdateObject* updateObj;
@end

@implementation MonsterEyeTestLayer

+ (CCScene*)scene
{
    CCScene* scene = [CCScene  node];
    CCLayer* layer = [[MonsterEyeTestLayer alloc] init];
    [scene addChild:layer];
    return scene;
}
- (id)init
{
    self = [super initWithColor:ccc4(255, 0, 0, 255)];
    if (self)
    {
        self.updateObj = [[MonsterEyeUpdateObject alloc] init];
        MonsterEye* eye = [[MonsterEye alloc] initWithEyeWhiteName:@"p2_monster_eyewhite.png" eyeballName:@"p2_monster_eyeblack.png" eyelidColor:ccc3(0, 0, 255)];
        eye.position = ccp(512, 384);
        [self addChild:eye];
        self.eye = eye;
        [self.updateObj addMonsterEye:eye];
        
        eye = [[MonsterEye alloc] initWithEyeWhiteName:@"p2_monster_eyewhite.png" eyeballName:@"p2_monster_eyeblack.png" eyelidColor:ccc3(0, 0, 255)];
        eye.position = ccp(512, 484);
        [self addChild:eye];
        self.eye = eye;
        [self.updateObj addMonsterEye:eye];
        
//        self.touchEnabled = YES;
        [self.updateObj beginUpdate];
    }
    return self;
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.eye eyeMoveAngle:CCRANDOM_0_1() * 360.f];
}
@end
