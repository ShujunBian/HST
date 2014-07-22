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

@interface WorldP2Layer : CCLayer<WorldSubLayer>

@property (nonatomic, assign) P2_LittleFlyObjects * blueLittleFly;
@property (nonatomic, assign) P2_LittleFlyObjects * greenLittleFly;

@end
