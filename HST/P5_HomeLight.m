//
//  P5_HomeLight.m
//  HST
//
//  Created by Emerson on 14-12-5.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P5_HomeLight.h"

@implementation P5_HomeLight
@synthesize light;

- (void) didLoadFromCCB
{
    [light setRotation:-10.0];
    
    CCSequence * lightRotationSeq = [CCSequence actions:
                                  [CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:2.0 angle:10.0] rate:2.5],
                                     [CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:2.0 angle:-10.0] rate:2.5],
                                  nil];
    CCRepeatForever * lightRotationForever = [CCRepeatForever actionWithAction:lightRotationSeq];
    [light runAction:lightRotationForever];
}

- (void)dealloc
{
    [super dealloc];
}
@end
