//
//  WorldP4Layer.h
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "WorldSublayer.h"

@class P4Monster;
@class P4Bottle;
@interface WorldP4Layer : CCLayer<WorldSubLayer>


@property (strong, nonatomic) P4Monster* greenMonster;
@property (strong, nonatomic) P4Monster* yellowMonster;
@property (strong, nonatomic) P4Monster* purpleMonster;
@property (strong, nonatomic) P4Monster* blueMonster;
@property (strong, nonatomic) P4Monster* redMonster;
@property (strong, nonatomic) P4Bottle* bottle;



@end
