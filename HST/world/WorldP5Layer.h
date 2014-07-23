//
//  WorldP5Layer.h
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "WorldSublayer.h"

@class P5_Monster;
@interface WorldP5Layer : CCLayer<WorldSubLayer>

@property (nonatomic, assign) P5_Monster * monster;

@end
