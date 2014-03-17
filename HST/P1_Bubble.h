//
//  Bubble.h
//  town
//
//  Created by Song on 13-8-4.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"
#import "P1_BubbleBomb.h"

@interface P1_Bubble : CCNode <CCBAnimationManagerDelegate,P1_BubbleBoomDelegate>
{
    double movingTime;
    CGPoint originalPosition;
    
    float mySineCycle;
    float tobeSize;
}

@property (nonatomic, assign) CCSprite *body;
@property (nonatomic, assign) CCSprite *blowAnimator;
@property (nonatomic) CGPoint targetPosition;
@property (nonatomic) bool isReadyForboom;
@property (nonatomic) BOOL isReadyRelease;

- (int)countOfColor;
- (ccColor3B)colorAtIndex:(NSUInteger)index;
- (void)setBodyColor:(ccColor3B)color;
- (void)randomASize:(float)size;
- (void)boom;
- (void)goAway;

@end
