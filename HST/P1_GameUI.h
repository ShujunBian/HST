//
//  P1_GameUI.h
//  HST
//
//  Created by wxy325 on 8/26/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCNode.h"
@class P1_BlowUI;
@interface P1_GameUI : CCLayer

@property (readonly, nonatomic) BOOL fIsShowShadow;

@property (assign, nonatomic) BOOL fIsFirst;

@property (assign, nonatomic) CCLayerColor* background;
@property (assign, nonatomic) P1_BlowUI* blowUI;
@property (assign, nonatomic) CCLabelTTF* label1;
@property (assign, nonatomic) CCLabelTTF* label2;
@property (assign, nonatomic) CCSprite* arrow;

- (void)updateOrientation:(UIInterfaceOrientation)orientation;
- (void)setIsFirstOpen:(BOOL)fFirst;

- (void)handleBlow;
- (void)restart;

- (void)scheduleToCheckBlowUi;

@end
