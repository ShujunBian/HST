//
//  MainMapHelper.h
//  HST
//
//  Created by Emerson on 14-3-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXYMenuItemImage.h"

@protocol MainMapDelegate <NSObject>

@required

- (void)restartGameScene;
- (void)returnToMainMap;
- (void)helpButtonPressed;
- (void)musicButtonPressed;

@end

@interface MainMapHelper : NSObject

+ (MainMapHelper *)addMenuToCurrentPrototype:(id)prototype atMainMapButtonPoint:(CGPoint)point;

- (void)addMenuToCurrentPrototype:(id)prototype atMainMapButtonPoint:(CGPoint)point;

@property (nonatomic, assign) WXYMenuItemImage * restartItem;
@property (nonatomic, assign) CCMenu * restartMenu;
@property (nonatomic, assign) WXYMenuItemImage * mainMapItem;
@property (nonatomic, assign) CCMenu * mainMapMenu;
@property (nonatomic, assign) WXYMenuItemImage * helpItem;
@property (nonatomic, assign) CCMenu * helpMenu;

@property (nonatomic, assign) CCMenu * musicMenu;
@property (nonatomic, assign) WXYMenuItemImage * musicItem;

@property (nonatomic, assign) id<MainMapDelegate> delegate;

- (void)disableMainMapButton;
- (void)disableHelpButton;
- (void)disableRestartButton;
- (void)disableMusicButton;
- (void)enableMainMapButton;
- (void)enableHelpButton;
- (void)enableRestartButton;
- (void)enableMusicButton;
@end
