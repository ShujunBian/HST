//
//  MainMapHelper.m
//  HST
//
//  Created by Emerson on 14-3-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "MainMapHelper.h"

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
    self.restartItem = [CCMenuItemImage itemWithNormalImage:@"restartButton.png"
                                                      selectedImage:nil
                                                             target:self
                                                           selector:@selector(restartGameScene)];
    self.restartMenu = [CCMenu menuWithItems:_restartItem, nil];
    [_restartMenu setPosition:CGPointMake(point.x + 92.0, point.y)];
    [prototype addChild:_restartMenu z:15];
    
    self.mainMapItem = [CCMenuItemImage itemWithNormalImage:@"mainMapButton.png"
                                                      selectedImage:nil
                                                             target:self
                                                           selector:@selector(returnToMainMap)];
    self.mainMapMenu = [CCMenu menuWithItems:_mainMapItem, nil];
    [_mainMapMenu setPosition:point];
    [prototype addChild:_mainMapMenu z:15];
}

- (void)restartGameScene
{
    CCScaleBy * scale1 = [CCScaleBy actionWithDuration:0.1 scale:1.4];
    CCScaleBy * scale2 = [CCScaleBy actionWithDuration:0.1 scale:0.7];
    CCScaleTo * scale3 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * seq = [CCSequence actions:scale1,scale2,scale3, nil];
    [_restartItem runAction:seq];
    
    [self.delegate restartGameScene];
}

- (void)returnToMainMap
{
    _mainMapItem.isEnabled = NO;
    CCScaleBy * scale1 = [CCScaleBy actionWithDuration:0.1 scale:1.4];
    CCScaleBy * scale2 = [CCScaleBy actionWithDuration:0.1 scale:0.7];
    CCScaleTo * scale3 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCCallBlock* callBlock = [CCCallBlock actionWithBlock:^{

    }];
    CCSequence * seq = [CCSequence actions:scale1,scale2,scale3, callBlock, nil];
    [_mainMapItem runAction:seq];
    [self.delegate returnToMainMap];


}
@end
