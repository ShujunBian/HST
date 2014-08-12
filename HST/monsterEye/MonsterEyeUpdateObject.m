//
//  MonsterEyeUpdateObject.m
//  HST
//
//  Created by wxy325 on 7/17/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "MonsterEyeUpdateObject.h"
#import "MonsterEye.h"

#define UPDATE_DURATION_FIRST_MAX 4.f
#define UPDATE_DURATION_MIN 4.f
#define UPDATE_DURATION_RANGE 3.f

@interface MonsterEyeUpdateObject ()

@property (strong, nonatomic) NSMutableArray* eyesArray;

@property (assign, nonatomic) BOOL isUpdate;

@property (strong, nonatomic) NSLock* lock;
@property (assign, nonatomic) BOOL fIsFirstTime;

@end

@implementation MonsterEyeUpdateObject

- (id)init
{
    self = [super init];
    if (self)
    {
        self.eyesArray = [[@[] mutableCopy] autorelease];
        self.lock = [[[NSLock alloc] init] autorelease];
        self.mode = MonsterEyeUpdateObjectModeNormal;
        self.firstDelay = 0.f;
    }
    return self;
}
- (void)dealloc
{
    self.lock = nil;
    [self.eyesArray removeAllObjects];
    self.eyesArray = nil;
    [super dealloc];
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
    
//    float delayTime = CCRANDOM_0_1() * UPDATE_DURATION_FIRST_MAX;
    [self performSelector:@selector(eyeUpdate) withObject:nil afterDelay:0.2f];
//    [self eyeUpdate];
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
    if (self.mode == MonsterEyeUpdateObjectModeLaunchImage)
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
    }
    
    
    float delayTime = 0.f;
    if (self.fIsFirstTime)
    {
        self.fIsFirstTime = NO;
        delayTime = CCRANDOM_0_1() * UPDATE_DURATION_FIRST_MAX;
    }
    else
    {
        delayTime = UPDATE_DURATION_MIN + UPDATE_DURATION_RANGE * CCRANDOM_0_1();
    }
    
    [self performSelector:@selector(eyeUpdate) withObject:nil afterDelay:delayTime];
    
}

@end
