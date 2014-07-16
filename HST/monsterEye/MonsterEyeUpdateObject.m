//
//  MonsterEyeUpdateObject.m
//  HST
//
//  Created by wxy325 on 7/17/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "MonsterEyeUpdateObject.h"
#import "MonsterEye.h"

@interface MonsterEyeUpdateObject ()

@property (strong, nonatomic) NSMutableArray* eyesArray;

@end

@implementation MonsterEyeUpdateObject

- (id)init
{
    self = [super init];
    if (self)
    {
        self.eyesArray = [@[] mutableCopy];
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


- (void)beginUpdate
{

}
- (void)endUpdate
{
    
}
@end
