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


- (void)waterHeightChange:(float)height;

@end

@interface P4WaterLayer : CCNode

@property (strong, nonatomic) CCSprite* bottleMask;

@property (strong, nonatomic) CCSprite* water1;
@property (strong, nonatomic) CCSprite* water2;

@property (strong, nonatomic) CCParticleSystemQuad* sprayLeft;
@property (strong, nonatomic) CCParticleSystemQuad* sprayRight;

@property (assign, nonatomic) CGPoint leftSprayPrePositionR;
@property (assign, nonatomic) CGPoint rightSprayPrePositionR;

@property (assign, nonatomic) CGPoint leftSprayPrePositionL;
@property (assign, nonatomic) CGPoint rightSprayPrePositionL;

@property (unsafe_unretained, nonatomic) NSObject<P4WaterLayerDelegate>* delegate;

@property (readonly, assign, nonatomic) float averageWaterScale;


- (void)beginAddWater:(ccColor3B)waterColor isRight:(BOOL)fIsRight;
- (void)endAddWater;
- (void)beginReleaseWater;

- (void)mergeWater;


- (void)waterMoveWithDeltaX:(float)deltaX deltaY:(float)deltaY;

- (void)waterHeightChange:(float)height;

- (void)worldSceneConfigure;

- (void)makeNewBubbleScaleRate:(float)scaleRate speedRate:(float)speedRate;
@end
