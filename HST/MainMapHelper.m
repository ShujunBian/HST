//
//  MainMapHelper.m
//  HST
//
//  Created by Emerson on 14-3-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "MainMapHelper.h"

@implementation MainMapHelper

+ (void)addMenuToCurrentPrototype:(id)prototype
{
    CCMenuItem * restartItem = [CCMenuItemImage itemWithNormalImage:@"restartButton.png"
                                                      selectedImage:nil
                                                             target:prototype
                                                           selector:@selector(restartGameScene)];
    CCMenu * restartMenu = [CCMenu menuWithItems:restartItem, nil];
    [restartMenu setPosition:CGPointMake(158.0, 727.0)];
    [prototype addChild:restartMenu];
    
    CCMenuItem * mainMapItem = [CCMenuItemImage itemWithNormalImage:@"mainMapButton.png"
                                                      selectedImage:nil
                                                             target:prototype
                                                           selector:@selector(returnToMainMap)];
    CCMenu * mainMapMenu = [CCMenu menuWithItems:mainMapItem, nil];
    [mainMapMenu setPosition:CGPointMake(66.0, 727.0)];
    [prototype addChild:mainMapMenu];
}

@end
