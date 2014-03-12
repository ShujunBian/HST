//
//  LittleFlyBoom.h
//  jump
//
//  Created by Emerson on 13-9-3.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@interface P2_LittleFlyBoom : CCNode<CCBAnimationManagerDelegate>

@property (nonatomic, assign) CCParticleSystemQuad * boom;
@property (nonatomic) ccColor3B tintColor;
@property (nonatomic) BOOL isScheduledForRemove;

@end
