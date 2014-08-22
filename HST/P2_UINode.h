//
//  P2_UINode.h
//  HST
//
//  Created by Emerson on 14-8-20.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCNode.h"

static CGPoint musicShadowPoint[] =
{
    {0.0,-36.5},
    {0.0,-36.5}
};

static CGPoint musicPlayButtonPoint[] = {
    {3.0,-235.0},
    {3.0,-235.0}
};

static CGPoint musicImagePoint[] = {
    {1.0,124.0},
    {-6.0,124.0}
};


@interface P2_UINode : CCNode

- (id)initWithUINumber:(int)uiNumber;

@end
