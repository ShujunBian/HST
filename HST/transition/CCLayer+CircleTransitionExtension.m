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
#import "VolumnHelper.h"

@implementation CCLayer (CircleTransitionExtension)
- (void)showScene
{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:[VolumnHelper sharedVolumnHelper] selector:@selector(upBackgroundVolumn:) userInfo:nil repeats:YES];
#warning 这里加背景音乐变大
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [layer removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector].runningScene addChild:layer];
    [layer showSceneWithDuration:.3f onCompletion:^{
        [layer removeFromParentAndCleanup:NO];
    }];
}

- (void)changeToLoadedScene:(CCScene*)scene
{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:[VolumnHelper sharedVolumnHelper] selector:@selector(downBackgroundVolumn:) userInfo:nil repeats:YES];
#warning 这里加背景音乐变小
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [layer removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector].runningScene addChild:layer];
    [layer hideSceneWithDuration:.5f onCompletion:^{
        [layer removeFromParentAndCleanup:NO];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
}

- (void)changeToScene:(SceneBlock)sceneBlock
{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:[VolumnHelper sharedVolumnHelper] selector:@selector(downBackgroundVolumn:) userInfo:nil repeats:YES];
#warning 这里加背景音乐变小
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [layer removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector].runningScene addChild:layer];
    [layer hideSceneWithDuration:.5f onCompletion:^{
        [layer removeFromParentAndCleanup:NO];
        [[CCDirector sharedDirector] replaceScene:sceneBlock()];
    }];
}

@end
