//
//  BubbleBomb.h
//  town
//
//  Created by Song on 13-8-4.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@interface P1_BubbleBomb : CCNode<CCBAnimationManagerDelegate>

@property (nonatomic,retain) CCParticleSystemQuad *ps;
@property (nonatomic) ccColor3B tintColor;

@end
