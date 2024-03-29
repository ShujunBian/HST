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

typedef enum {
    P1_BubbleNone = 0,
    P1_BubbleDo,
    P1_BubbleRi,
    P1_BubbleMi,
    P1_BubbleFa,
    P1_BubbleSol,
    P1_BubbleLa,
    P1_BubbleXi
} P1_BubbleType;

@class P1_Bubble;

@protocol P1_BubbleDelegate <NSObject>

- (void)bubbleDidArrivePosition:(P1_Bubble*)bubble;

@end

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
@property (nonatomic) P1_BubbleType currentBubbleType;
@property (unsafe_unretained, nonatomic) NSObject<P1_BubbleDelegate>* delegate;

- (int)countOfColor;
- (ccColor3B)colorAtIndex:(NSUInteger)index;
- (void)setBodyColor:(ccColor3B)color;
- (void)randomASize:(float)size;
- (void)boom;
- (void)goAway;

@end
