//
//  MainMapHelper.m
//  HST
//
//  Created by Emerson on 14-3-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "MainMapHelper.h"
#import "SimpleAudioEngine.h"
#import "WXYMenuItemImage.h"

@implementation MainMapHelper

+ (MainMapHelper *)addMenuToCurrentPrototype:(id)prototype atMainMapButtonPoint:(CGPoint)point
{
    MainMapHelper * mainMapHelper = [[[MainMapHelper alloc] init] autorelease];
    mainMapHelper.delegate = prototype;
    [mainMapHelper addMenuToCurrentPrototype:prototype atMainMapButtonPoint:point];
    return mainMapHelper;
}

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)addMenuToCurrentPrototype:(id)prototype atMainMapButtonPoint:(CGPoint)point
{
    self.restartItem = [WXYMenuItemImage itemWithNormalImage:@"restartButton.png"
                                                      selectedImage:nil
                                                             target:self
                                                           selector:@selector(restartGameScene)];
    self.restartMenu = [CCMenu menuWithItems:_restartItem, nil];
    [_restartMenu setPosition:CGPointMake(point.x + 92.0, point.y)];
    [prototype addChild:_restartMenu z:15];
    
    self.mainMapItem = [WXYMenuItemImage itemWithNormalImage:@"mainMapButton.png"
                                                      selectedImage:nil
                                                             target:self
                                                           selector:@selector(returnToMainMap)];
    self.mainMapMenu = [CCMenu menuWithItems:_mainMapItem, nil];
    [_mainMapMenu setPosition:point];
    [prototype addChild:_mainMapMenu z:15];
    
    self.helpItem = [WXYMenuItemImage itemWithNormalImage:@"helpButton.png" selectedImage:nil target:self selector:@selector(helpBtnPressed)];
    self.helpMenu = [CCMenu menuWithItems:self.helpItem, nil];
    
    self.helpMenu.position = ccp([CCDirector sharedDirector].winSize.width - 50.f, point.y);
    [prototype addChild:self.helpMenu];
    
}

- (void)restartGameScene
{

    
    if ([self.delegate respondsToSelector:@selector(restartGameScene)])
    {
        [self.delegate restartGameScene];
    }

}

- (void)returnToMainMap
{
    _mainMapItem.isEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(returnToMainMap)])
    {
        [self.delegate returnToMainMap];
    }
}

- (void)helpBtnPressed
{

    
    if ([self.delegate respondsToSelector:@selector(helpButtonPressed)])
    {
        [self.delegate helpButtonPressed];
    }
}

@end
