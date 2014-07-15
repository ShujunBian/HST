//
//  P4Bottle.h
//  hst_p4
//
//  Created by wxy325 on 1/18/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "CCLayer.h"
#import "P4WaterLayer.h"
@class CCSprite;
@class P4BottleEar;
@class P4WaterLayer;
@class P4Monster;
@class CCParticleSystemQuad;

@class P4GameLayer;



@interface P4Bottle : CCLayer<P4WaterLayerDelegate>


@property (strong, nonatomic) CCSprite* bottleMain;
@property (strong, nonatomic) CCSprite* leftCap;
@property (strong, nonatomic) CCSprite* rightCap;
@property (strong, nonatomic) CCSprite* leftEar;
@property (strong, nonatomic) CCSprite* rightEar;
@property (strong, nonatomic) CCSprite* leftFoot;
@property (strong, nonatomic) CCSprite* rightFoot;
@property (strong, nonatomic) CCSprite* renewButton;

@property (strong, nonatomic) P4WaterLayer* waterLayer;

@property (strong, nonatomic) CCParticleSystemQuad* waterIn;
@property (strong, nonatomic) CCParticleSystemQuad* waterOut1;
@property (strong, nonatomic) CCParticleSystemQuad* waterOut2;

@property (unsafe_unretained, nonatomic) P4GameLayer* gameLayer;
@property (readonly, nonatomic) BOOL isFull;

- (void)capOpen;
- (void)capClose;

- (void)startWaterIn:(P4Monster*)monster;
- (void)stopWaterIn;
- (CGRect)getRect;


- (void)bottleMoveWithDeltaX:(float)deltaX deltaY:(float)deltaY;
- (void)bottleMoveBack:(float)delay;


@end