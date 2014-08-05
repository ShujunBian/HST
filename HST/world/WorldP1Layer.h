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

@property (nonatomic, strong) P1_Bubble * blueBubble;
@property (nonatomic, strong) P1_Bubble * purpBubble;
@property (nonatomic, strong) P1_Bubble * yellowBubble;
@property (nonatomic, strong) P1_Bubble * greenBubble;
@property (nonatomic, strong) CCSprite * dialogIcon;

@end
