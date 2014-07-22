//
//  GameObjects.m
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_GameObjects.h"

@implementation P2_GameObjects

- (id)init
{
	if( (self=[super init]))
    {
        self.isInMainMap = NO;
        [self scheduleUpdate];
        objectMovingSpeed = 1024.0 / 8.0 * EVERYDELTATIME;
	}
	return self;
}


- (void)didLoadFromCCB
{
}


- (void)update:(ccTime)delta
{
    if (!self.isInMainMap) {
        if (self.position.x < - 100) {
            [self actionWhenOutOfScreen];
        }
        self.position = CGPointMake(self.position.x - objectMovingSpeed, self.position.y);
    }
}

- (void)setObjectFirstPosition
{
    objectPostionX = CCRANDOM_0_1() * 1024.0;
    self.position = CGPointMake(objectPostionX, self.contentSize.height / 2);
}

- (void)actionWhenOutOfScreen
{
    objectPostionX = 1024.0 + CCRANDOM_0_1() * 1024.0;
    self.position = CGPointMake(objectPostionX, self.contentSize.height / 2);
}


@end
