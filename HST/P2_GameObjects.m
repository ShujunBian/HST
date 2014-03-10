//
//  GameObjects.m
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_GameObjects.h"
#define ARC4RANDOM_MAX 0x100000000

@implementation P2_GameObjects

- (id)init
{
	if( (self=[super init]))
    {
        [self scheduleUpdate];
        objectMovingSpeed = 1024.0 / 8.0 * EVERYDELTATIME;
//        self.isFlyingOut = NO;
	}
	return self;
}


- (void)didLoadFromCCB
{
}


- (void)update:(ccTime)delta
{
    //NSLog(@"self position is %f",self.position.x );
//    if (!self.isFlyingOut) {
        if (self.position.x < - 100) {
            [self actionWhenOutOfScreen];
        }
        self.position = CGPointMake(self.position.x - objectMovingSpeed, self.position.y);
//    }
}

- (void)setObjectFirstPosition
{
    objectPostionX = (float)arc4random() / ARC4RANDOM_MAX * 1024.0;
    self.position = CGPointMake(objectPostionX, self.contentSize.height / 2);
}

- (void)actionWhenOutOfScreen
{
    objectPostionX = 1024.0 + (float)arc4random() / ARC4RANDOM_MAX * 1024.0;
    self.position = CGPointMake(objectPostionX, self.contentSize.height / 2);
}


@end
