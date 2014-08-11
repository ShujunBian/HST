//
//  GameScene.h
//  town
//
//  Created by Song on 13-7-25.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCLayer.h"
#import "CCBReader.h"
#import "CocosDenshion.h"
#import "P2_LittleFlyObjects.h"

@class P2_GrassLayer;
@class P2_Monster;
@class P2_LittleMonster;

@interface P2_GameScene : CCLayer<P2_LittleFlyObjectsDelegate>
{
    BOOL isFrameCounterShowed;
    NSInteger deltaCounter;
    NSArray * frameToShowCurrentFrame;
    NSArray * musicTypeInFrame;
}

@property (nonatomic) NSInteger frameCounter;
@property (nonatomic, strong) NSMutableArray * flyObjectsOnScreen;
@property (nonatomic, assign) P2_GrassLayer * grassLayer;
@property (nonatomic, strong) P2_Monster * monster;
@property (nonatomic, assign) P2_LittleMonster * firstLittleMonster;
@property (nonatomic, assign) P2_LittleMonster * secondLittleMonster;


@end
