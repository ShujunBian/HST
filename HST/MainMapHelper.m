//
//  MainMapHelper.m
//  HST
//
//  Created by Emerson on 14-3-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "MainMapHelper.h"

@implementation MainMapHelper

+ (void)addMenuToCurrentPrototype:(id)prototype atMainMapButtonPoint:(CGPoint)point
{
    CCMenuItem * restartItem = [CCMenuItemImage itemWithNormalImage:@"restartButton.png"
                                                      selectedImage:nil
                                                             target:prototype
                                                           selector:@selector(restartGameScene)];
    CCMenu * restartMenu = [CCMenu menuWithItems:restartItem, nil];
    [restartMenu setPosition:CGPointMake(point.x + 92.0, point.y)];
    [prototype addChild:restartMenu z:15];
    
    CCMenuItem * mainMapItem = [CCMenuItemImage itemWithNormalImage:@"mainMapButton.png"
                                                      selectedImage:nil
                                                             target:prototype
                                                           selector:@selector(returnToMainMap)];
    CCMenu * mainMapMenu = [CCMenu menuWithItems:mainMapItem, nil];
    [mainMapMenu setPosition:point];
    [prototype addChild:mainMapMenu z:15];
}

@end
