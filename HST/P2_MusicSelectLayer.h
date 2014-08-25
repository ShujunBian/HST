//
//  P2_MusicSelectLayer.h
//  HST
//
//  Created by Emerson on 14-8-14.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "CCLayerColor+CCLayerColorAnimation.h"
#import "P2_UINode.h"

#define kMaxSongNumber          3
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

@protocol P2_MusicSelectLayerDelegate <NSObject>

- (void)changeCurrentSongByNumber:(int)number;
- (void)selectLayerRemoveFromeGameScene;

@end

@interface P2_MusicSelectLayer : CCLayer<UIGestureRecognizerDelegate,P2_UINodeDelegate>

@property (nonatomic) int currentSongNumber;
@property (nonatomic, assign) id<P2_MusicSelectLayerDelegate> delegate;

- (void)addP2SelectSongUI;
- (void)resetUINodeByCurrentSongNumber:(int)number;

@end
