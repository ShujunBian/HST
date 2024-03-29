//
//  WorldP3Layer.h
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "WorldSublayer.h"

@interface WorldP3Layer : CCLayer<WorldSubLayer>

@property (nonatomic, assign) CCLayer * monsterLayer;

@property (strong, nonatomic) CCSprite* dialogIcon;

@end
