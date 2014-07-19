//
//  MonsterEyeUpdateObject.m
//  HST
//
//  Created by wxy325 on 7/17/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "MonsterEyeUpdateObject.h"
#import "MonsterEye.h"

#define UPDATE_DURATION_MIN 2.f
#define UPDATE_DURATION_RANGE 1.f

@interface MonsterEyeUpdateObject ()

@property (strong, nonatomic) NSMutableArray* eyesArray;

@property (assign, nonatomic) BOOL isUpdate;

@property (strong, nonatomic) NSLock* lock;
@end

@implementation MonsterEyeUpdateObject

- (id)init
{
    self = [super init];
    if (self)
    {
        self.eyesArray = [@[] mutableCopy];
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)addMonsterEye:(MonsterEye*)eye
{
    [self.eyesArray addObject:eye];
}
- (void)removeMonsterEye:(MonsterEye*)eye
{
    [self.eyesArray removeObject:eye];
}
- (void)removeAllMonsterEyes
{
    [self.eyesArray removeAllObjects];
}

- (void)beginUpdate
{
    [self.lock lock];
    self.isUpdate = YES;
    [self.lock unlock];
    [self eyeUpdate];
}
- (void)endUpdate
{
    [self.lock lock];
    self.isUpdate = NO;
    [self.lock unlock];
}
- (void)eyeUpdate
{
    [self.lock lock];
    BOOL fUpdate = self.isUpdate;
    [self.lock unlock];
    if (!fUpdate)
    {
        return;
    }
    
    float randomNum = CCRANDOM_0_1();
    if (randomNum < 0.5)
    {
        //Move
        
        float angle = 360.f * CCRANDOM_0_1();
        
        for (MonsterEye* e in self.eyesArray)
        {
            [e eyeMoveAngle:angle];
        }
    }
    else
    {
        //Blink
        for (MonsterEye* e in self.eyesArray)
        {
            [e blink];
        }
    }
    
    [self performSelector:@selector(eyeUpdate) withObject:nil afterDelay:UPDATE_DURATION_MIN + UPDATE_DURATION_RANGE * CCRANDOM_0_1()];
    
}

@end
