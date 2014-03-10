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

@interface P1_GameScene : CCLayer<P1_BlowDetecterDelegate,P1_MonsterDelegate>

@property (nonatomic,retain) P1_Monster *monster;
@property (nonatomic,retain) CCSprite *monsterInitPositionReferenceSprite;

@property (nonatomic,retain) CCSprite *toolColorLayer;

@end
