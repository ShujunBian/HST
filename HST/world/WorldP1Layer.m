//
//  WorldP1Layer.m
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WorldP1Layer.h"

@implementation WorldP1Layer

@synthesize blueBubble;
@synthesize purpBubble;
@synthesize yellowBubble;
@synthesize greenBubble;

static ccColor3B bubbleColors[] = {
    {255,229,55},//黄色
    {255,188,248},//紫色
    {91,222,255},//蓝色
    {111,255,141},//绿色
    {131,255,245},//蓝绿
    {135,246,203},
    {151,255,28},
    {255,169,175},
    {255,200,33},
    {213,176,255}
};

- (id)init
{
    if (self = [super init]) {

    }
    return self;
}

- (void) didLoadFromCCB
{
    [blueBubble.body setColor:bubbleColors[2]];
    [purpBubble.body setColor:bubbleColors[1]];
    [yellowBubble.body setColor:bubbleColors[0]];
    [greenBubble.body setColor:bubbleColors[3]];
}
@end
