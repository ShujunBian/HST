//
//  GameScene.h
//  town
//
//  Created by Song on 13-7-25.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCLayer.h"
#import "CCBReader.h"
#import "P1_BlowDetecter.h"
#import "P1_Monster.h"
#import "CocosDenshion.h"
#import "MainMapHelper.h"
#import "P1_Bubble.h"

@class P1_GameUI;

@interface P1_GameScene : CCLayer<P1_BlowDetecterDelegate,P1_MonsterDelegate,MainMapDelegate, P1_BubbleDelegate>

@property (nonatomic, assign) P1_Monster *monster;
@property (nonatomic, assign) CCSprite *monsterInitPositionReferenceSprite;

@property (nonatomic, assign) CCSprite *toolColorLayer;
@property (strong, nonatomic) P1_GameUI* gameUI;

@end
