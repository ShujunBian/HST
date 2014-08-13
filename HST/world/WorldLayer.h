//
//  WorldLayer.h
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "WorldUILayer.h"
@class WorldP1Layer;
@class WorldP2Layer;
@class WorldP3Layer;
@class WorldP4Layer;
@class WorldP5Layer;

@interface WorldLayer : CCLayer<WorldUILayerDelegate>

@property (strong, nonatomic) WorldP1Layer* p1Layer;
@property (strong, nonatomic) WorldP2Layer* p2Layer;
@property (strong, nonatomic) WorldP3Layer* p3Layer;
@property (strong, nonatomic) WorldP4Layer* p4Layer;
@property (strong, nonatomic) WorldP5Layer* p5Layer;

@end
