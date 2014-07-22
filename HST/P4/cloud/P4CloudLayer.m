//
//  P4CloudLayer.m
//  hst_p4
//
//  Created by wxy325 on 1/17/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "P4CloudLayer.h"

#define CLOUD_TOP_MOVE_DURATION 20.f
#define CLOUD_1_MOVE_DURATION 80.f
#define CLOUD_2_MOVE_DURATION 40.f
#define CLOUD_3_MOVE_DURATION 40.f

@implementation P4CloudLayer

- (void)startAnimation
{
//    [self.cloudTop startAnimationWithDuration:CLOUD_TOP_MOVE_DURATION];
    [self.cloud1 startAnimationWithDuration:CLOUD_1_MOVE_DURATION];
//    [self.cloud2 startAnimationWithDuration:CLOUD_2_MOVE_DURATION];
//    [self.cloud3 startAnimationWithDuration:CLOUD_3_MOVE_DURATION];
}


@end
