//
//  MonsterEyeUpdateObject.h
//  HST
//
//  Created by wxy325 on 7/17/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MonsterEye;
//MonsterEyeUpdateObject
//定时处理MonsterEye的随机眨眼，移动等等

@interface MonsterEyeUpdateObject : NSObject

- (id)init;

- (void)addMonsterEye:(MonsterEye*)eye;
- (void)removeMonsterEye:(MonsterEye*)eye;
- (void)removeAllMonsterEyes;

- (void)beginUpdate;
- (void)endUpdate;
@end
