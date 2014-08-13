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
    if (self.opacity == 191) {
        [timer invalidate];
    }
    
    if (fabsf(self.opacity - 191) < 20) {
        self.opacity = 191;
    }
    else {
        self.opacity += 19;
    }
}

- (void)fadeOut
{
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(fadeOutAnimation:) userInfo:nil repeats:YES];
}

- (void)fadeOutAnimation:(NSTimer *)timer
{
    if (self.opacity == 0) {
        [timer invalidate];
    }
    
    if (fabsf(self.opacity - 0) < 16) {
        self.opacity -= 1;
        if (fabsf(self.opacity - 0) < 2) {
            self.opacity = 0;
        }
    }
    else {
        self.opacity -= 15;
    }
}

@end
