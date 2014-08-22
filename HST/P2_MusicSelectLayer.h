//
//  P2_MusicSelectLayer.h
//  HST
//
//  Created by Emerson on 14-8-14.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "CCLayerColor+CCLayerColorAnimation.h"

static CGPoint musicSelectPoint[] =
{
    {527.0,403.0},
    {1048.0,403.0}
};

//
//static CGPoint musicPlayButtonPoint[] = {
//    {531.0,168.0},
//    {1052.0,168.0}
//};
//
//static CGPoint musicImagePoint[] = {
//    {528.0,527.0},
//    {1042.0,527.0}
//};

@interface P2_MusicSelectLayer : CCLayer

- (void)addP2SelectSongUI;

@end
