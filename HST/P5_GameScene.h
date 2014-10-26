//
//  P5_GameScene.h
//  Dig
//
//  Created by Emerson on 14-1-24.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "CCBReader.h"
#import "P5_UndergroundScene.h"
#import "CCBAnimationManager.h"
#import "MainMapHelper.h"
#import "P5_UiLayer.h"
#import "P5_HelpUi.h"
#import "P5_HelpUi2.h"

@class P5_Monster;
@class P5_UndergroundScene;
@class P5_GrassLayer;
@class P5_SkyLayer;

@interface P5_GameScene : CCLayer<P5_UndergroundSceneDelegate, MainMapDelegate, P5_UILayerDelegate>

@property (nonatomic, assign) P5_Monster * monsterUpground;
@property (nonatomic, strong) P5_Monster * monsterUnderground;
@property (nonatomic, assign) P5_GrassLayer * grassLayer;
@property (nonatomic, assign) P5_UndergroundScene * undergrounScene;

@property (nonatomic, assign) P5_SkyLayer * skyLayer;
@property (nonatomic, assign) CCSprite * mountain1;
@property (nonatomic, assign) CCSprite * mountain2;

@end
