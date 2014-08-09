//
//  CCLayer+CircleTransitionExtension.m
//  HST
//
//  Created by wxy325 on 8/9/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer+CircleTransitionExtension.h"
#import "CircleTransitionLayer.h"
#import "CCDirector.h"


@implementation CCLayer (CircleTransitionExtension)
- (void)showScene
{
    return;
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [[CCDirector sharedDirector].runningScene addChild:layer];
//    [self addChild:layer];
    [layer showSceneWithDuration:1.f onCompletion:^{
        [layer removeFromParentAndCleanup:YES];
    }];
}

- (void)changeToScene:(CCScene*)scene
{
    
        [[CCDirector sharedDirector] replaceScene:scene];
    return;
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [[CCDirector sharedDirector].runningScene addChild:layer];
//    [self addChild:layer];
    [layer hideSceneWithDuration:1.f onCompletion:^{
        [layer removeFromParentAndCleanup:YES];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
}

@end
