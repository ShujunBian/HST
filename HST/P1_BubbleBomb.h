//
//  BubbleBomb.h
//  town
//
//  Created by Song on 13-8-4.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@protocol P1_BubbleBoomDelegate <NSObject>

@optional

- (void)removeBubbleFromParent;

@end

@interface P1_BubbleBomb : CCNode<CCBAnimationManagerDelegate>

@property (nonatomic, assign) CCParticleSystemQuad *ps;
@property (nonatomic) ccColor3B tintColor;
@property (nonatomic, assign) id<P1_BubbleBoomDelegate> delegate;


@end
