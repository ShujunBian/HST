//
//  LittleFly.h
//  jump
//
//  Created by Emerson on 13-9-2.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "P2_GameObjects.h"

@class P2_LittleFlyObjects;
@class P2_Monster;

@protocol P2_LittleFlyObjectsDelegate <NSObject>

- (BOOL)isSamePositionWithOtherFlyObjects:(P2_LittleFlyObjects *)littleFlyObject;
- (void)removeFromOnScreenArray:(P2_LittleFlyObjects *)littleFlyObject;

@end

@interface P2_LittleFlyObjects : P2_GameObjects

@property (nonatomic, assign) id<P2_LittleFlyObjectsDelegate> delegate;

@property (nonatomic, strong) CCSprite * body;
@property (nonatomic, strong) CCSprite * wing;
@property (nonatomic) int musicType;

- (ccColor3B)colorAtIndex:(NSUInteger)index;
- (void)setBodyColor:(ccColor3B)color;
- (int)countOfColor;
- (void)handleCollision;

@end
