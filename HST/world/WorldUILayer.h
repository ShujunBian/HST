//
//  WorldUILayer.h
//  HST
//
//  Created by Emerson on 14-8-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCLayer.h"

@class WorldLayer;

@protocol WorldUILayerDelegate <NSObject>

- (void)removeFromWorldLayer;

@end

typedef enum {
    MainMapP1 = 1,
    MainMapP2,
    MainMapP3,
    MainMapP4,
    MainMapP5
} MainMapType;

@interface WorldUILayer : CCLayer

@property (nonatomic) MainMapType currentMainMapType;
@property (nonatomic, assign) id<WorldUILayerDelegate> delegate;

- (id)initWithMainMapType:(MainMapType)currentMainMapType;

@end
