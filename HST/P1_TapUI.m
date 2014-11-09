//
//  P1_TapUI.m
//  HST
//
//  Created by wxy325 on 8/26/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P1_TapUI.h"

@implementation P1_TapUI

- (void) didLoadFromCCB
{
    self.touchEnabled = NO;
    [self.background retain];
    [self.label retain];
    [self.label setFontName:@"Kankin"];
}
- (void)dealloc
{
    self.background = nil;
    self.label = nil;
    
    [super dealloc];
}

@end
