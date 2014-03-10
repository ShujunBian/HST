//
//  P5_CalculateHelper.m
//  Dig
//
//  Created by Emerson on 1/30/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P5_CalculateHelper.h"
#import "cocos2d.h"

@implementation P5_CalculateHelper

+ (float)distanceBetweenEndPoint:(CGPoint)endPoint andStartPoint:(CGPoint)startPoint
{
    float x_Distance = endPoint.x - startPoint.x;
    float y_Distance = endPoint.y - startPoint.y;
    return sqrtf(x_Distance * x_Distance + y_Distance * y_Distance);
}

+ (float)degreeBetweenStartPoint:(CGPoint)startPoint
                     andEndPoint:(CGPoint)endPoint
                       isForSoil:(BOOL)isForSoil
{
    float len_y = endPoint.y - startPoint.y;
    float len_x = endPoint.x - startPoint.x;
    float tan_yx = fabsf(len_y)/fabsf(len_x);
    
    float angle = 0;
    if(len_y > 0 && len_x < 0) {
        angle = atanf(tan_yx) * 180.0 / M_PI - 180.0;
        if (isForSoil) {
            angle += 180.0;
        }
    }
    else if (len_y > 0 && len_x > 0) {
        angle = - atanf(tan_yx) * 180.0 / M_PI;
    }
    else if(len_y < 0 && len_x < 0) {
        angle = 180.0 - atanf(tan_yx) * 180.0 / M_PI;
        if (isForSoil) {
            angle = angle - 180.0;
        }
    }
    else if(len_y < 0 && len_x > 0) {
        angle = atanf(tan_yx) * 180.0 / M_PI;
    }
    return angle;
}

+ (NSInteger)chooseSoilPlistByStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint
{
    float len_y = endPoint.y - startPoint.y;
    float len_x = endPoint.x - startPoint.x;
    
    if(len_y > 0 && len_x < 0) {
        return 1;
    }
    else if (len_y > 0 && len_x > 0) {
        return 2;
    }
    else if(len_y < 0 && len_x < 0) {
        return 1;
    }
    else if(len_y < 0 && len_x > 0) {
        return 2;
    }
    else {
        NSLog(@"Choose Soil Failed");
        return 0;
    }
}

+ (BOOL)isThirdPoint:(CGPoint)point3
InLineWithFirstPoint:(CGPoint)point1
         SecondPoint:(CGPoint)point2
{
    float k = (point1.y - point2.y) / (point1.x - point2.x);
    float b = point1.y - k * point1.x;
    if (point3.y == k * point3.x + b) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (CGPoint)thirdPointInLinePoint1:(CGPoint)point1
                      SecondPoint:(CGPoint)point2
                          x_point:(float)x
{
    float a = (x - point1.x) / (x - point2.x);
    float y = (point1.y - point2.y * a) / (1 - a);
    
    return CGPointMake(x, y);
}

+ (BOOL)isLineWithFirstPoint:(CGPoint)point1
                 SecondPoint:(CGPoint)point2
              InCircleCenter:(CGPoint)point3 Radius:(float)length
{
    float k = (point1.y - point2.y) / (point1.x - point2.x);
    float b = point1.y - k * point1.x;
    float distance = fabsf(k * point3.x + -1 * point3.y + b) / sqrtf(k * k + 1);//圆心到直线距离
    float x_13 = point1.x - point3.x; float x_23 = point2.x - point3.x; float x_12 = point1.x - point2.x;
    float y_13 = point1.y - point3.y; float y_23 = point2.y - point3.y; float y_12 = point1.y - point2.y;
    float distance_13 = sqrtf(x_13 * x_13 + y_13 * y_13);//圆心到原处距离
    float distance_23 = sqrtf(x_23 * x_23 + y_23 * y_23);//圆心到第二处距离
    float distance_12 = sqrtf(x_12 * x_12 + y_12 * y_12);//实际上两点距离
    float idealDistance = sqrtf(distance_13 * distance_13 - distance * distance) + sqrtf(length * length - distance * distance);
    

    if (distance_12 < distance_23 && distance_13 < distance_23) {
        return NO;
    }
    else if (idealDistance < distance_12) {
        return YES;
    }
    else if (fabsf(point2.x - point3.x) < 30 && fabsf(point2.y - point3.y) < 30)
    {
        return YES;
    }
    else
        return NO;    
}

+ (BOOL)isPoint:(CGPoint)point1 inAnotherPoint:(CGPoint)point2 with:(float)radius
{
    return [P5_CalculateHelper distanceBetweenEndPoint:point1 andStartPoint:point2] < radius ? YES : NO;
}

+ (CGPoint)thirdPointInLineStartPoint:(CGPoint)startPoint
                      EndPoint:(CGPoint)endPoint
                     withDistance:(float)distance
                       BeginPoint:(CGPoint)beginPoint
{
    float k = (startPoint.y - endPoint.y) / (startPoint.x - endPoint.x);
    float x_distance = sqrtf(distance * distance / (1 + k * k));
    float y_distance = fabsf(x_distance * k);
    float x_direction = endPoint.x - startPoint.x >= 0 ? 1 : -1;
    float y_direction = endPoint.y - startPoint.y >= 0 ? 1 : -1;
    return CGPointMake(beginPoint.x + x_distance * x_direction,
                       beginPoint.y + y_distance * y_direction);
}
@end
