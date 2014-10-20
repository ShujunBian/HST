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
- (void)didLoadFromCCB
{
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
        }
        else if (CGRectContainsPoint([self.number2 getRect], locationInNodeSpace))
        {
            [self selectButton:self.number2];
        }
        else if (CGRectContainsPoint([self.number3 getRect], locationInNodeSpace))
        {
            [self selectButton:self.number3];
        }
        else if (CGRectContainsPoint([self.okButton getRect], locationInNodeSpace))
        {
            NSLog(@"ok");
        }
        
    }
}

- (void)selectButton:(P5_NumberButton*)btn
{
    self.number1.selected = self.number1 == btn;
    self.number2.selected = self.number2 == btn;
    self.number3.selected = self.number3 == btn;
}

- (void)mainmapUIScaleAnimation:(CCNode *)node
{
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.2 scale:0.85];
    CCScaleTo * uibgScaleTo3 = [CCScaleTo actionWithDuration:0.15 scale:1.1];
    CCScaleTo * uibgScaleTo4 = [CCScaleTo actionWithDuration:0.15 scale:0.95];
    CCScaleTo * uibgScaleTo5 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * uibgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2,uibgScaleTo3,uibgScaleTo4,uibgScaleTo5, nil];
    [node runAction:uibgSeq];
}

@end
