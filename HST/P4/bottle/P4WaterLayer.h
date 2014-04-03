//
//  P4WaterLayer.h
//  hst_p4
//
//  Created by wxy325 on 1/20/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "CCNode.h"
@class CCParticleSystemQuad;
@class CCSprite;


@protocol P4WaterLayerDelegate <NSObject>

- (void)startWaterOut:(ccColor3B)color;
- (void)waterOutColorChange:(ccColor3B)color;
- (void)endWaterOut;

@end

@interface P4WaterLayer : CCNode

@property (strong, nonatomic) CCSprite* bottleMask;

@property (strong, nonatomic) CCSprite* water1;
@property (strong, nonatomic) CCSprite* water2;

@property (strong, nonatomic) CCParticleSystemQuad* sprayLeft;
@property (strong, nonatomic) CCParticleSystemQuad* sprayRight;

@property (assign, nonatomic) CGPoint leftSprayPrePosition;
@property (assign, nonatomic) CGPoint rightSprayPrePosition;

@property (unsafe_unretained, nonatomic) NSObject<P4WaterLayerDelegate>* delegate;

- (void)beginAddWater:(ccColor3B)waterColor;
- (void)endAddWater;
- (void)beginReleaseWater;

- (void)mergeWater;


- (void)waterMoveWithDeltaX:(float)deltaX deltaY:(float)deltaY;

- (void)waterHeightChange:(float)height;


@end
