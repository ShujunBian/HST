//
//  WXYMenuItem.m
//  HST
//
//  Created by wxy325 on 8/12/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WXYMenuItemImage.h"

@implementation WXYMenuItemImage
- (void)selected
{
    [super selected];
    CCScaleBy * scale1 = [CCScaleTo actionWithDuration:0.1 scale:1.4];
    CCScaleBy * scale2 = [CCScaleBy actionWithDuration:0.1 scale:0.98];
    CCScaleTo * scale3 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * seq = [CCSequence actions:scale1,scale2,scale3, nil];
    [self runAction:seq];
    
}

@end
