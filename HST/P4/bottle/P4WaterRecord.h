//
//  P4WaterRecord.h
//  hst_p4
//
//  Created by wxy325 on 1/21/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "cocos2d.h"

typedef NS_ENUM(NSInteger, P4WaterFlowType)
{
    P4WaterFlowTypeOne, P4WaterFlowTypeTwo
};



@interface P4WaterRecord : NSObject


@property (assign, nonatomic) float colorRadius;
@property (assign, nonatomic) ccColor3B colorFrom;
@property (assign, nonatomic) ccColor3B color;
@property (assign, nonatomic) ccColor3B colorTo;
@property (assign, nonatomic) BOOL isChangeColor;
@property (assign, nonatomic) float colorChangeSpeed;

@property (assign, nonatomic) float height;

@property (assign, nonatomic) float offset;
@property (assign, nonatomic) P4WaterFlowType flowType;
@property (assign, nonatomic) float flowSpeed;
@property (assign, nonatomic) float flowSpeedMin;

@property (assign, nonatomic) float waveScale;

@property (assign, nonatomic) float waveScaleLowest;


- (id)init;

- (void)updateRecord;
- (void)waterUp;

- (BOOL)mergeRecord:(P4WaterRecord*)record;


- (void)waterMoveWithDeltaX:(float)deltaX deltaY:(float)deltaY;
@end
