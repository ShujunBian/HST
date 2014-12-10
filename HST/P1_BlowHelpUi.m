//
//  P1_BlowHelpUi.m
//  HST
//
//  Created by wxy325 on 12/7/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P1_BlowHelpUi.h"
#import "CCSprite+getRect.h"
#import "CCLayer+CircleTransitionExtension.h"
#import "P1_BlowDetecter.h"
#import "CCBReader.h"
#import "SimpleAudioEngine.h"
@implementation P1_BlowHelpUi

- (void)onEnter
{
    [super onEnter];
    [self showScene];
}
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(id)event
{
    CCDirector* director = [CCDirector sharedDirector];
    for(UITouch* touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:[director view]];
        CGPoint locationGL = [director convertToGL:touchLocation];
        CGPoint locationInNodeSpace = [self convertToNodeSpace:locationGL];
        
        if (CGRectContainsPoint([self.okBtn getRect], locationInNodeSpace)) {
            //OK
            [self okBtnPressed];
        } else if (CGRectContainsPoint(CGRectMake(467, 55, 118, 29), locationInNodeSpace)) {
            //No
            [self noBtnPressed];
        }
    }
}

- (void)okBtnPressed
{
    [self mainmapUIScaleAnimation:self.okBtn];
    [P1_BlowDetecter setIsEnableDetect:YES];
    [P1_BlowDetecter setIsFirstDetect:NO];
    [P1_BlowDetecter instance];
    [self changeToP1];
}
- (void)noBtnPressed
{
    [self mainmapUIScaleAnimation:self.noLabel];
    [P1_BlowDetecter setIsEnableDetect:NO];
    [P1_BlowDetecter setIsFirstDetect:NO];
    [self changeToP1];
}
- (void)changeToP1
{
    NSString * ccbiFileName = [NSString stringWithFormat:@"P%d_GameScene.ccbi",1];
    [self changeToScene:^CCScene *{
        CCScene* p1Scene = [CCBReader sceneWithNodeGraphFromFile:ccbiFileName];
        return p1Scene;
    }];
}

- (void)mainmapUIScaleAnimation:(CCNode *)node
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"UILittleButton.mp3"];
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.2 scale:0.85];
    CCScaleTo * uibgScaleTo3 = [CCScaleTo actionWithDuration:0.15 scale:1.1];
    CCScaleTo * uibgScaleTo4 = [CCScaleTo actionWithDuration:0.15 scale:0.95];
    CCScaleTo * uibgScaleTo5 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * uibgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2,uibgScaleTo3,uibgScaleTo4,uibgScaleTo5, nil];
    [node runAction:uibgSeq];
}
@end
