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
    [self showSceneOnCompletion:nil];
}
- (void)showSceneOnCompletion:(VoidBlock)completion
{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:[VolumnHelper sharedVolumnHelper] selector:@selector(upBackgroundVolumn:) userInfo:nil repeats:YES];
#warning 这里加背景音乐变大
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [layer removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector].runningScene addChild:layer];
    [layer showSceneWithDuration:.3f onCompletion:^{
        [layer removeFromParentAndCleanup:NO];
        if (completion)
        {
            completion();
        }
        
    }];
}

- (void)changeToLoadedScene:(CCScene*)scene
{
    [self changeToLoadedScene:scene onCompletion:nil];
}
- (void)changeToLoadedScene:(CCScene*)scene onCompletion:(VoidBlock)completion
{
#warning 这里加背景音乐变小
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [layer removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector].runningScene addChild:layer];
    [layer hideSceneWithDuration:.5f onCompletion:^{
        [layer removeFromParentAndCleanup:NO];
        [[CCDirector sharedDirector] replaceScene:scene];
        if (completion)
        {
            completion();
        }
    }];
}

- (void)changeToScene:(SceneBlock)sceneBlock
{
    [self changeToScene:sceneBlock onCompletion:nil];
}
- (void)changeToScene:(SceneBlock)sceneBlock onCompletion:(VoidBlock)completion
{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:[VolumnHelper sharedVolumnHelper] selector:@selector(downBackgroundVolumn:) userInfo:nil repeats:YES];
#warning 这里加背景音乐变小
    CircleTransitionLayer* layer = [CircleTransitionLayer layer];
    [layer removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector].runningScene addChild:layer];
    [layer hideSceneWithDuration:.5f onCompletion:^{
        [layer removeFromParentAndCleanup:NO];
        [[CCDirector sharedDirector] replaceScene:sceneBlock()];
        if (completion)
        {
            completion();
        }
    }];
}


@end
