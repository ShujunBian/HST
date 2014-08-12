//
//  CCLayerColor+CCLayerColorAnimation.m
//  HST
//
//  Created by Emerson on 14-8-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCLayerColor+CCLayerColorAnimation.h"

@implementation CCLayerColor (CCLayerColorAnimation)

- (void)fadeIn
{
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(fadeInAnimation:) userInfo:nil repeats:YES];
}

- (void)fadeInAnimation:(NSTimer *)timer
{
    if (self.opacity == 255.0 * 0.75) {
        [timer invalidate];
    }
    
    if (fabsf(self.opacity - 255.0 * 0.75) < 20) {
        self.opacity = 255.0 * 0.75;
    }
    else {
        self.opacity += 19.125;
    }
}

@end
