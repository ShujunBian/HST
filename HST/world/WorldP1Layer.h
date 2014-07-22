//
//  WorldP1Layer.h
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "WorldSublayer.h"
#import "P1_Bubble.h"

@interface WorldP1Layer : CCLayer<WorldSubLayer>

@property (nonatomic, assign) P1_Bubble * blueBubble;
@property (nonatomic, assign) P1_Bubble * purpBubble;
@property (nonatomic, assign) P1_Bubble * yellowBubble;
@property (nonatomic, assign) P1_Bubble * greenBubble;

@end
