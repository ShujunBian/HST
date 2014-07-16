//
//  WXYSampleMonster.m
//  HST
//
//  Created by wxy325 on 7/17/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WXYSampleMonster.h"
#import "MonsterEye.h"
#import "MonsterEyeUpdateObject.h"

@interface WXYSampleMonster ()
@property (strong, nonatomic) MonsterEyeUpdateObject* updateObj;

@end


@implementation WXYSampleMonster

- (id)init
{
    self = [super init];
    if (self)
    {
        //初始化update object
        self.updateObj = [[MonsterEyeUpdateObject alloc] init];
        
        //在屏幕添加怪物眼睛
        MonsterEye* eye1 = [[MonsterEye alloc] initWithEyeWhiteName:@"p2_monster_eyewhite.png" eyeballName:@"p2_monster_eyeblack.png" eyelidColor:ccc3(0, 0, 255)];
        eye1.position = ccp(100, 100);  //这里坐标乱设的
        [self addChild:eye1];
        MonsterEye* eye2 = [[MonsterEye alloc] initWithEyeWhiteName:@"p2_monster_eyewhite.png" eyeballName:@"p2_monster_eyeblack.png" eyelidColor:ccc3(0, 0, 255)];
        eye2.position = ccp(100, 100);
        [self addChild:eye2];
        
        //把怪物眼睛加入到updateObj
        //只有加入updateObj的怪物眼睛才会定时眨眼、移动等
        [self.updateObj addMonsterEye:eye1];
        [self.updateObj addMonsterEye:eye2];
        
        
        //开始自动定时眨眼
        [self.updateObj beginUpdate];
        
//        [self.updateObj endUpdate];   //退出时调用endUpdate
        
    }
    return self;
}


@end
