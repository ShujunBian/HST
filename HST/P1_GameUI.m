//
//  P1_GameUI.m
//  HST
//
//  Created by wxy325 on 8/26/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P1_GameUI.h"
#import "P1_BlowUI.h"

@interface P1_GameUI ()

@property (assign, nonatomic) UIInterfaceOrientation currentOrientation;

@property (assign, nonatomic) BOOL fIsToShowBlowUi;
@end

@implementation P1_GameUI

- (void) didLoadFromCCB
{
    self.touchEnabled = YES;
    _fIsShowShadow = NO;
    self.fIsFirst = YES;
//    [self.background retain];
//    [self.blowUI retain];
//    [self.label1 retain];
//    [self.label2 retain];
//    [self.arrow retain];
}


- (void)dealloc
{
    [super dealloc];
//    self.background = nil;
//    self.blowUI = nil;
//    self.label1 = nil;
//    self.label2 = nil;
//    self.arrow = nil;
}

- (void)updateOrientation:(UIInterfaceOrientation)orientation
{
    if (self.currentOrientation == 0 || self.currentOrientation == orientation)
    {
        [self updateBlowUIpositon:orientation];
    }
    else
    {
        [self.blowUI runAction:
         [CCSequence actions:
          [CCFadeOut actionWithDuration:0.3f],
          [CCCallBlock actionWithBlock:^{
             [self updateBlowUIpositon:orientation];
         }],
          [CCFadeIn actionWithDuration:0.3f],
          nil]];
    }
}

- (void)updateBlowUIpositon:(UIInterfaceOrientation)orientation
{
    self.currentOrientation = orientation;
    [self.blowUI updateOrientation:orientation];
    
    switch (orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        {
            //在屏幕右边
            self.blowUI.position = ccp(876.f, 384.f);
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            //在屏幕左边
            self.blowUI.position = ccp(148.f, 384.f);
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)setIsFirstOpen:(BOOL)fFirst
{

    if (fFirst)
    {
        _fIsShowShadow = YES;
        self.background.visible = 127;
        self.label1.opacity = 255;
        self.label2.opacity = 255;
        self.arrow.opacity = 255;
    }
    else
    {
        self.background.opacity = 0;
        self.label1.opacity = 0;
        self.label2.opacity = 0;
        self.arrow.opacity = 0;
        self.blowUI.opacity = 0;
        [self scheduleToCheckBlowUi];
    }

}

- (void)handleBlow
{
    _fIsShowShadow = NO;
    self.fIsToShowBlowUi = NO;
    for (CCNode* node in self.children)
    {
        [node runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];
    }
}
- (void)restart
{
    _fIsShowShadow = YES;
    [self.background runAction:[CCFadeTo actionWithDuration:0.3f opacity:127]];
    self.background.visible = YES;
    for (CCNode* node in self.children)
    {
        if (node != self.background)
        {
            [node runAction:[CCFadeTo actionWithDuration:0.3f opacity:255]];
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.fIsFirst)
    {
        [self handleBlow];
    }
}
- (void)scheduleToCheckBlowUi
{
    self.fIsToShowBlowUi = YES;
    [self performSelector:@selector(checkToShowBlowUi) withObject:nil afterDelay:10.f];
}
- (void)checkToShowBlowUi
{
    if (self.fIsToShowBlowUi)
    {
        self.fIsToShowBlowUi = NO;
        [self.blowUI runAction:[CCFadeTo actionWithDuration:0.3f opacity:255]];
    }
}
@end
