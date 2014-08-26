//
//  P2_UINode.h
//  HST
//
//  Created by Emerson on 14-8-20.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCNode.h"

#define kMaxSongNumber          2
#define kMinSongNumber          0
#define kXDistanceBetweenSongs  521.0

static CGPoint musicSelectPoint[] =
{
    {527.0,403.0},
    {1048.0,403.0},
    {1569.0,403.0},
    {2090.0,403.0},
    {2611.0,403.0}
};

static CGPoint musicShadowPoint[] =
{
    {0.0,-36.5},
    {0.0,-36.5},
    {0.0,-36.5}
};

static CGPoint musicPlayButtonPoint[] = {
    {3.0,-235.0},
    {3.0,-235.0},
    {3.0,-235.0}
};

static CGPoint musicImagePoint[] = {
    {1.0,124.0},
    {-6.0,124.0}
};

@protocol P2_UINodeDelegate <NSObject>

- (void)clickUIPlayButtonByMusicNumber:(int)number;

@end

@interface P2_UINode : CCNode

@property (nonatomic) BOOL isAnimationFinished;
@property (nonatomic, assign) id<P2_UINodeDelegate> delegate;

- (id)initWithUINumber:(int)uiNumber;
- (void)setToFinalPosition:(CGPoint)finalPosition
              andIsToRight:(BOOL)isToRight;

@end
