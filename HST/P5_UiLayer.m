//
//  P5_UiLayer.m
//  HST
//
//  Created by wxy325 on 10/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "cocos2d.h"
#import "P5_UiLayer.h"
#import "P5_NumberButton.h"
#import "CCSprite+getRect.h"
@interface P5_UiLayer ()

@property (strong, nonatomic) CCLayerColor* shadowLayer;
@property (strong, nonatomic) CCNode* containerNode;
@property (strong, nonatomic) P5_NumberButton* number1;
@property (strong, nonatomic) P5_NumberButton* number2;
@property (strong, nonatomic) P5_NumberButton* number3;
@property (strong, nonatomic) CCSprite* okButton;
@end

@implementation P5_UiLayer
@synthesize isShow = _isShow;
- (void)didLoadFromCCB
{
    _isShow = NO;
//    self.containerNode.scale = 0.5;
    [self.containerNode retain];
    [self.shadowLayer retain];
    [self.number1 retain];
    [self.number2 retain];
    [self.number3 retain];
    [self.okButton retain];
    
    self.number1.numberLabel.string = @"1";
    self.number2.numberLabel.string = @"2";
    self.number2.selected = NO;
    self.number3.numberLabel.string = @"3";
    self.number3.selected = NO;
    
    self.containerNode.scale = 0;
    self.shadowLayer.opacity = 0;
}

- (void)dealloc
{
    self.containerNode = nil;
    self.shadowLayer = nil;
    self.number1 = nil;
    self.number2 = nil;
    self.number3 = nil;
    self.okButton = nil;
    self.containerNode = nil;
    [super dealloc];
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCDirector* director = [CCDirector sharedDirector];

    for(UITouch* touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:director.view];
        CGPoint locationGL = [director convertToGL:touchLocation];
        CGPoint locationInNodeSpace = [self convertToNodeSpace:locationGL];
        if (CGRectContainsPoint([self.number1 getRect], locationInNodeSpace))
        {
            [self selectButton:self.number1];
            if ([self.delegate respondsToSelector:@selector(p5Ui:selectIndex:)]) {
                [self.delegate p5Ui:self selectIndex:0];
            }
        }
        else if (CGRectContainsPoint([self.number2 getRect], locationInNodeSpace))
        {
            [self selectButton:self.number2];
            if ([self.delegate respondsToSelector:@selector(p5Ui:selectIndex:)]) {
                [self.delegate p5Ui:self selectIndex:1];
            }
        }
        else if (CGRectContainsPoint([self.number3 getRect], locationInNodeSpace))
        {
            [self selectButton:self.number3];
            if ([self.delegate respondsToSelector:@selector(p5Ui:selectIndex:)]) {
                [self.delegate p5Ui:self selectIndex:2];
            }
        }
        else if (CGRectContainsPoint([self.okButton getRect], locationInNodeSpace))
        {
            [self mainMapUIScaleHelper:self.okButton];
            if ([self.delegate respondsToSelector:@selector(p5UiOkButtonPressed:)]) {
                [self.delegate p5UiOkButtonPressed:self];
            }
        }
    }
}

- (void)selectButton:(P5_NumberButton*)btn
{
    self.number1.selected = self.number1 == btn;
    self.number2.selected = self.number2 == btn;
    self.number3.selected = self.number3 == btn;
}

- (void)mainmapUIScaleAnimation:(CCNode *)node delay:(float)delay
{
    node.scale = 0;
    [self performSelector:@selector(mainMapUIScaleHelper:) withObject:node afterDelay:delay];

}
- (void)mainMapUIScaleHelper:(CCNode*)node
{
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.2 scale:0.85];
    CCScaleTo * uibgScaleTo3 = [CCScaleTo actionWithDuration:0.15 scale:1.1];
    CCScaleTo * uibgScaleTo4 = [CCScaleTo actionWithDuration:0.15 scale:0.95];
    CCScaleTo * uibgScaleTo5 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * uibgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2,uibgScaleTo3,uibgScaleTo4,uibgScaleTo5, nil];
    [node runAction:uibgSeq];
}


- (void)showAnimate
{
    if (_isShow) {
        return;
    }
    _isShow = YES;
    [self.shadowLayer runAction:[CCFadeTo actionWithDuration:0.3f opacity:191]];
    [self.containerNode setScale:0.0];
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * bgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2, nil];
    [self.containerNode runAction:bgSeq];
    
    [self mainmapUIScaleAnimation:self.number1 delay:0.2];
    [self mainmapUIScaleAnimation:self.number2 delay:0.2];
    [self mainmapUIScaleAnimation:self.number3 delay:0.2];
    [self mainmapUIScaleAnimation:self.okButton delay:0.4];
}
- (void)hideAnimate
{
    if (!_isShow) {
        return;
    }
    _isShow = NO;
    [self.shadowLayer runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];
    CCScaleTo * scaleTo = [CCScaleTo actionWithDuration:0.1 scale:1.2];
    CCScaleTo * scaleDisappera = [CCScaleTo actionWithDuration:0.2 scale:0.0];
    [self.containerNode runAction:[CCSequence actionOne:scaleTo two:scaleDisappera]];
}
@end
