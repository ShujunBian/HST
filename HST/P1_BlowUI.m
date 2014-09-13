//
//  P1_BlowUI.m
//  HST
//
//  Created by wxy325 on 8/26/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P1_BlowUI.h"

@implementation P1_BlowUI
- (GLubyte)opacity
{
    return self.label1.opacity;
}
- (void) setOpacity:(GLubyte)opacity
{
    self.background.opacity = opacity;
    self.label1.opacity = opacity;
    self.label2.opacity = opacity;
}

- (void) didLoadFromCCB
{
//    [self.background retain];
//    [self.label1 retain];
//    [self.label2 retain];
    [self.label1 setFontName:@"Kankin"];
    [self.label2 setFontName:@"Kankin"];
}

- (void)dealloc
{
    [super dealloc];
//    self.background = nil;
//    self.label1 = nil;
//    self.label2 = nil;
}
- (void)updateOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
        {
            //在屏幕右边
            self.background.scaleX = -1.f;
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            //在屏幕左边
            self.background.scaleX = 1.f;
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
