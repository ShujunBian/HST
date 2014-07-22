//
//  P4WaterRecord.m
//  hst_p4
//
//  Created by wxy325 on 1/21/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "P4WaterRecord.h"
#import "P4Extension.h"

#define WAVE_SCALE_LOWEST 0.2f
#define WAVE_SCALE_HIGHEST 1.f
#define WAVE_SCALE_RADIO 0.99f
#define WAVE_SCALE_UP_RADIO 1.05f

#define COLOR_CHANGE_SPEED 2.f

#define FLOW_SPEED_MAX 8.f
#define FLOW_SPEED_MIN 1.f
#define FLOW_SPEED_REDUCE_RADIO 0.995f;
#define FLOW_SPEED_ADD_RADIO 1.05f;

@interface P4WaterRecord ()
- (void)checkFlowSpeedMinAndMax;
- (void)checkWaveScaleMinAndMax;
@end

@implementation P4WaterRecord

- (id)init
{
    self = [super init];
    if (self)
    {
        self.color = ccc3(0, 0, 0);
        self.height = 0;
        self.offset = 0;
        self.flowSpeed = 4.f;
        self.flowSpeedMin = FLOW_SPEED_MIN;
//        self.rotate = 0;
//        self.fToRotate = NO;
//        self.rotateFrom = 0;
//        self.rotateTo = 0;
//        self.rotateRadio = 1;
        self.waveScaleLowest = WAVE_SCALE_LOWEST;
        self.waveScale = WAVE_SCALE_LOWEST;

        self.isChangeColor = NO;
        self.colorChangeSpeed = 1.f;
    }
    return self;
}

- (void)updateRecord
{
    //Update Offset
    self.offset += self.flowSpeed;
    
    //Update Wave Scale
    self.waveScale *= WAVE_SCALE_RADIO;
    [self checkWaveScaleMinAndMax];
    
    //Update Flow Speed
    self.flowSpeed *= FLOW_SPEED_REDUCE_RADIO;
    [self checkFlowSpeedMinAndMax];
    
    //Update Color
    if (self.isChangeColor)
    {
        if (colorCompare(self.color, self.colorTo))
        {
            self.isChangeColor = NO;
        }
        else
        {
            float r,g,b;
            r = colorChange(self.color.r, self.colorTo.r, self.colorChangeSpeed);
            g = colorChange(self.color.g, self.colorTo.g, self.colorChangeSpeed);
            b = colorChange(self.color.b, self.colorTo.b, self.colorChangeSpeed);
//            if (r == self.colorTo.r || g == self.colorTo.g || b == self.colorTo.b)
//            {
//                CCLOG(@"r,g,b:%f,%f,%f  toRGB:%d,%d,%d",r,g,b,self.colorTo.r,self.colorTo.g, self.colorTo.r);
//            }
            self.color = ccc3(r, g, b);
        }
    }
    
}
- (void)waterUp
{
    self.waveScale *= WAVE_SCALE_UP_RADIO;
    [self checkWaveScaleMinAndMax];
    
    self.flowSpeed *= FLOW_SPEED_ADD_RADIO;
    [self checkFlowSpeedMinAndMax];
}

- (BOOL)mergeRecord:(P4WaterRecord*)record
{
    if (colorCompare(self.color, record.color))
    {
        float newHeight = self.height + record.height;
        self.flowSpeed = (self.flowSpeed * self.height + record.flowSpeed * record.height) / newHeight;
//        self.waveScale = (self.waveScale * self.height + record.waveScale * record.height) / newHeight;
        self.height = newHeight;
        
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Helper
- (void)checkFlowSpeedMinAndMax
{
    BOOL fFlowSpeedMinu = NO;
    if (self.flowSpeed < 0)
    {
        fFlowSpeedMinu = YES;
        self.flowSpeed = -self.flowSpeed;
    }
    
    self.flowSpeed = self.flowSpeed < self.flowSpeedMin ? self.flowSpeedMin : self.flowSpeed;
    self.flowSpeed = self.flowSpeed > FLOW_SPEED_MAX ? FLOW_SPEED_MAX : self.flowSpeed;
    
    if (fFlowSpeedMinu)
    {
        self.flowSpeed = -self.flowSpeed;
    }
}

- (void)checkWaveScaleMinAndMax
{
    
    float h = WAVE_SCALE_HIGHEST * (1 + 0.1 * CCRANDOM_0_1());
    self.waveScale = self.waveScale < self.waveScaleLowest ? self.waveScaleLowest : self.waveScale;
    self.waveScale = self.waveScale > h ? h : self.waveScale;
}

- (void)waterMoveWithDeltaX:(float)deltaX deltaY:(float)deltaY
{
    float changeRate = sqrt(deltaX * deltaX + deltaY * deltaY) / 100;
    if (deltaX < 0)
    {
        changeRate = -changeRate;
    }
    self.waveScale *= (1 + 5 * ABS(changeRate));
    
    self.flowSpeed += 20 * changeRate;
    [self checkFlowSpeedMinAndMax];
    
    [self checkWaveScaleMinAndMax];
}
@end
