//
//  Bubble.h
//  town
//
//  Created by Song on 13-8-4.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@interface P1_Bubble : CCNode <CCBAnimationManagerDelegate>
{
    double movingTime;
    CGPoint originalPosition;
    
    float mySineCycle;
    float tobeSize;
}

@property (nonatomic,retain) CCSprite *body;
@property (nonatomic,retain) CCSprite *blowAnimator;

@property (nonatomic) CGPoint targetPosition;

@property (nonatomic) bool isReadyForboom;


- (int)countOfColor;
- (ccColor3B)colorAtIndex:(NSUInteger)index;
- (void)setBodyColor:(ccColor3B)color;
- (void)randomASize:(float)size;
- (void)boom;
- (void)goAway;

@end
