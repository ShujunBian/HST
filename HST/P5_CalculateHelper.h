//
//  P5_CalculateHelper.h
//  Dig
//
//  Created by Emerson on 1/30/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P5_CalculateHelper : NSObject

+ (float)distanceBetweenEndPoint:(CGPoint)endPoint andStartPoint:(CGPoint)startPoint;

+ (float)degreeBetweenStartPoint:(CGPoint)startPoint
                     andEndPoint:(CGPoint)endPoint
                       isForSoil:(BOOL)isForSoil;

+ (NSInteger)chooseSoilPlistByStartPoint:(CGPoint)startPoint
                             andEndPoint:(CGPoint)endPoint;

+ (CGPoint)thirdPointInLinePoint1:(CGPoint)point1
                      SecondPoint:(CGPoint)point2
                          x_point:(float)x;

+ (BOOL)isThirdPoint:(CGPoint)point3
InLineWithFirstPoint:(CGPoint)point1
         SecondPoint:(CGPoint)point2;

+ (BOOL)isLineWithFirstPoint:(CGPoint)point1
                 SecondPoint:(CGPoint)point2
              InCircleCenter:(CGPoint)point3
                      Radius:(float)length;

+ (BOOL)isPoint:(CGPoint)point1
 inAnotherPoint:(CGPoint)point2
           with:(float)radius;

+ (CGPoint)thirdPointInLineStartPoint:(CGPoint)startPoint
                      EndPoint:(CGPoint)endPoint
                     withDistance:(float)distance
                       BeginPoint:(CGPoint)beginPoint;


@end
