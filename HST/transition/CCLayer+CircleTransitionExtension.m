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
#warning 这里加背景音乐变大
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [[CCDirector sharedDirector].runningScene addChild:layer];
    [layer showSceneWithDuration:0.7f onCompletion:^{
        [layer removeFromParentAndCleanup:YES];
    }];
}

- (void)changeToScene:(SceneBlock)sceneBlock
{
#warning 这里加背景音乐变小
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [[CCDirector sharedDirector].runningScene addChild:layer];
    [layer hideSceneWithDuration:0.7f onCompletion:^{
        [layer removeFromParentAndCleanup:YES];
        [[CCDirector sharedDirector] replaceScene:sceneBlock()];
    }];
}

@end
