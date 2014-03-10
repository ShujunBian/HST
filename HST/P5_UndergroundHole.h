//
//  P5_UndergroundHole.h
//  Dig
//
//  Created by Emerson on 14-1-26.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class P5_Bell;
@interface P5_UndergroundHole : NSObject

@property (nonatomic, strong) P5_Bell * bell;
@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) float scaleRate;
@property (nonatomic) float roatateDegree;
@property (nonatomic) BOOL isChoosen;
@property (nonatomic) NSInteger holeNumber;

@end
