//
//  P2_MusicFinishLayer.h
//  HST
//
//  Created by Emerson on 14-8-25.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCLayer.h"

@protocol P2_MusicFinishLayerDelegate <NSObject>

- (void)finishLayerRemoveFromeGameScene;

@end

@interface P2_MusicFinishLayer : CCLayer

@property (nonatomic, strong) NSString * matchString;
@property (nonatomic, assign) id<P2_MusicFinishLayerDelegate> delegate;

- (void)addFinishedUI;

@end
