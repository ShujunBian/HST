//
//  WorldP2Layer.h
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "WorldSublayer.h"
#import "P2_LittleFlyObjects.h"

@class P2_LittleMonster;
@class P2_Monster;
@class P2_Mushroom;
@interface WorldP2Layer : CCLayer<WorldSubLayer>

@property (nonatomic, assign) P2_LittleFlyObjects * blueLittleFly;
@property (nonatomic, assign) P2_LittleFlyObjects * greenLittleFly;
@property (nonatomic, assign) P2_Monster * monster;
@property (nonatomic, assign) P2_LittleMonster * purpLittleMonster;
@property (nonatomic, assign) P2_LittleMonster * organeLittleMonster;
@property (nonatomic, assign) P2_Mushroom * rightTwoMushroom;

@property (nonatomic, strong) CCSprite* dialogIcon;
@end
