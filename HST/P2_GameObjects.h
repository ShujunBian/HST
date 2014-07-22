//
//  GameObjects.h
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"

#define EVERYDELTATIME 0.016667

@interface P2_GameObjects : CCNode
{
    float objectPostionX;
    float objectPostionY;
    float objectMovingSpeed;
}

@property (nonatomic) BOOL isInMainMap;
@property (nonatomic) BOOL isFlyingOut;

- (id)init;
- (void)didLoadFromCCB;
- (void)update:(ccTime)delta;
- (void)setObjectFirstPosition;
- (void)actionWhenOutOfScreen;

@end
