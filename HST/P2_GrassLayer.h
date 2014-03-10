//
//  GrassLayer.h
//  Jump
//
//  Created by Emerson on 13-8-29.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@class P2_Flower;
@class P2_Mushroom;

@interface P2_GrassLayer : CCLayer

@property (nonatomic, strong) P2_Flower * flower;
@property (nonatomic, strong) P2_Mushroom * mushroom;

@property (nonatomic, strong) CCSprite * grass;
@property (nonatomic, strong) CCSprite * grass2;

@end
