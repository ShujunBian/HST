//
//  MainMapHelper.m
//  HST
//
//  Created by Emerson on 14-3-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "MainMapHelper.h"
#import "SimpleAudioEngine.h"
#import "P1_GameScene.h"
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
    if([prototype class] != [P1_GameScene class]) {
        self.restartItem = [WXYMenuItemImage itemWithNormalImage:@"restartButton.png"
                                                   selectedImage:nil
                                                          target:self
                                                        selector:@selector(restartGameScene)];
        self.restartMenu = [CCMenu menuWithItems:_restartItem, nil];
        [_restartMenu setPosition:CGPointMake(point.x + 92.0, point.y)];
        [prototype addChild:_restartMenu z:15];
        
        [_restartMenu setOpacity:0.0];
        CCFadeIn * fadeIn = [CCFadeIn actionWithDuration:0.2];
        [_restartMenu runAction:fadeIn];
    }
    else {
        self.restartItem = [WXYMenuItemImage itemWithNormalImage:@"P1_AutoButton.png"
                                                   selectedImage:nil
                                                          target:self
                                                        selector:@selector(restartGameScene)];
        self.restartMenu = [CCMenu menuWithItems:_restartItem, nil];
        [_restartMenu setPosition:CGPointMake(point.x + 115.0, point.y)];
        [prototype addChild:_restartMenu z:15];
        
        [_restartMenu setOpacity:0.0];
        CCFadeIn * fadeIn = [CCFadeIn actionWithDuration:0.2];
        [_restartMenu runAction:fadeIn];
    }
    
    self.mainMapItem = [WXYMenuItemImage itemWithNormalImage:@"mainMapButton.png"
                                               selectedImage:nil
                                                      target:self
                                                    selector:@selector(returnToMainMap)];
    self.mainMapMenu = [CCMenu menuWithItems:_mainMapItem, nil];
    [_mainMapMenu setPosition:point];
    [prototype addChild:_mainMapMenu z:15];
    [_mainMapMenu setOpacity:0.0];
    CCFadeIn * fadeIn = [CCFadeIn actionWithDuration:0.2];
    [_mainMapMenu runAction:fadeIn];
    
    self.helpItem = [WXYMenuItemImage itemWithNormalImage:@"helpButton.png" selectedImage:nil target:self selector:@selector(helpBtnPressed)];
    self.helpMenu = [CCMenu menuWithItems:self.helpItem, nil];
    self.helpMenu.position = ccp([CCDirector sharedDirector].winSize.width - 50.f, point.y);
    [prototype addChild:self.helpMenu z:15];
    [self.helpItem setOpacity:0.0];
    CCFadeIn * fadeIn2 = [CCFadeIn actionWithDuration:0.2];
    [self.helpItem runAction:fadeIn2];
    
}

- (void)restartGameScene
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"UILittleButton.mp3"];
    if ([self.delegate respondsToSelector:@selector(restartGameScene)])
    {
        [self.delegate restartGameScene];
    }
    
}

- (void)returnToMainMap
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"UILittleButton.mp3"];
    _mainMapItem.isEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(returnToMainMap)])
    {
        [self.delegate returnToMainMap];
    }
}

- (void)helpBtnPressed
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"UILittleButton.mp3"];
    if ([self.delegate respondsToSelector:@selector(helpButtonPressed)])
    {
        [self.delegate helpButtonPressed];
    }
}

@end
