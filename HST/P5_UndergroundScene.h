//
//  P5_UndergroundLayer.h
//  Dig
//
//  Created by Emerson on 14-1-26.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "CCBReader.h"
#import "CCBAnimationManager.h"
#import "P5_Monster.h"

@class P5_UndergroundHole;
@class P5_Bell;
@class P5_Monster;

@protocol P5_UndergroundSceneDelegate <NSObject>

@optional

- (void)releaseTheCacheInTexture;

@end

@interface P5_UndergroundScene : CCLayer<P5_MonsterDelegate>

typedef enum {
    UINormal,
    UIBetweenHoles,
} UIMode;

@property (nonatomic, strong) P5_Monster * monsterUnderground;
@property (nonatomic, strong) NSMutableArray * drawOrderArray;
@property (nonatomic, strong) NSMutableArray * undergroundHolesArray;
@property (nonatomic, strong) CCArray * undergroundPassagesArray;

@property (nonatomic, assign) id<P5_UndergroundSceneDelegate> delegate;

- (void)createUndergroundWorld;
- (CGPoint)monsterCurrentPosition;

@end
