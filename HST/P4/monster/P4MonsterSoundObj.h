//
//  P4MonsterSoundObj.h
//  HST
//
//  Created by wxy325 on 8/9/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class P4Monster;
@class P4MonsterSoundObj;
@protocol P4MonsterSoundObjDelegate  <NSObject>

- (float)getMaxDelayTime;
- (void)soundWillPlay:(P4MonsterSoundObj*)obj delay:(float)delay;

@end

@interface P4MonsterSoundObj : NSObject

@property (assign,readonly, nonatomic) float maxDelay;
@property (unsafe_unretained, nonatomic) NSObject<P4MonsterSoundObjDelegate>* delegate;


- (id)initWithMonster:(P4Monster*)monster;
- (void)beginSound;
- (void)endSound;
@end
