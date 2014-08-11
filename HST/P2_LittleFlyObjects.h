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

- (void)removeFromOnScreenArray:(P2_LittleFlyObjects *)littleFlyObject;

@end

@interface P2_LittleFlyObjects : P2_GameObjects

@property (nonatomic, assign) id<P2_LittleFlyObjectsDelegate> delegate;

@property (nonatomic, assign) CCSprite * body;
@property (nonatomic, assign) CCSprite * wing;
@property (nonatomic) int musicType;

@property (nonatomic) NSInteger currentSongType;

- (ccColor3B)colorAtIndex:(NSUInteger)index;
- (void)setBodyColor:(ccColor3B)color;
- (int)countOfColor;
- (void)handleCollision;

@end
