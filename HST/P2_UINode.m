//
//  P2_UINode.m
//  HST
//
//  Created by Emerson on 14-8-20.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P2_UINode.h"
#import "CCLayerColor+CCLayerColorAnimation.h"
#import "WXYMenuItemImage.h"
@interface P2_UINode()

@property (nonatomic) int uiNumber;
@property (nonatomic, strong) CCSprite * uiBg;
@property (nonatomic, strong) CCMenuItem * uiPlayButtonItem;
@property (nonatomic, strong) CCMenu * uiPlayButton;
@property (nonatomic, strong) CCSprite * uiImage;
@property (nonatomic, strong) CCSprite * uiShadow;
@property (nonatomic, strong) CCSprite * uiButtonShadow;

@end

@implementation P2_UINode

- (id)initWithUINumber:(int)uiNumber
{
    if (self = [super init]) {
        self.isAnimationFinished = YES;
        self.uiNumber = uiNumber;
        
        self.uiBg = [CCSprite spriteWithFile:@"P2_MusicSelectBg.png"];
        [self.uiBg setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self.uiBg setPosition:CGPointMake(0.0, 0.0)];
        [self addChild:self.uiBg];
        
        self.uiPlayButtonItem = [WXYMenuItemImage itemWithNormalImage:@"MainMapPlayButton.png"
                                                         selectedImage:nil
                                                                target:self
                                                              selector:@selector(clickUIPlayButton:)];
        self.uiPlayButton = [CCMenu menuWithItems:self.uiPlayButtonItem, nil];
        [self.uiPlayButton setPosition:musicPlayButtonPoint[uiNumber]];
        [self.uiPlayButton setAnchorPoint:CGPointMake(0.5, 0.5)];
//        [self.uiPlayButtonItem setScale:0.0];
        [self addChild:self.uiPlayButton z:0];
//        [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:self.uiPlayButtonItem afterDelay:0.4];

        self.uiShadow = [CCSprite spriteWithFile:@"P2_UIShadow.png"];
        [self.uiShadow setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self.uiShadow setPosition:musicShadowPoint[uiNumber]];
        [self.uiShadow setOpacity:0.0];
        [self addChild:self.uiShadow z:1];
        
        CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
        CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
        CCSequence * bgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2, nil];
        [self runAction:bgSeq];
        
//            self.uiShadow = [CCSprite spriteWithFile:@"P2_UIbgShadow.png"];
//            [self.uiShadow setAnchorPoint:CGPointMake(0.5, 0.5)];
//            [self.uiShadow setPosition:CGPointMake(0.0, 0.0)];
//            [self.uiShadow setScale:0.0];
//            [self addChild:self.uiShadow z:1];
//            CCScaleTo * uiShadowScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.20];
//            CCScaleTo * uiShadowScaleTo2 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
//            CCSequence * ShadowSeq = [CCSequence actions:uiShadowScaleTo1,uiShadowScaleTo2, nil];
//            [self.uiShadow runAction:ShadowSeq];
//            
//            self.uiButtonShadow = [CCSprite spriteWithFile:@"P2_UIButtonShadow.png"];
//            [self.uiButtonShadow setAnchorPoint:CGPointMake(0.5, 0.5)];
//            [self.uiButtonShadow setPosition:CGPointMake(musicPlayButtonPoint[uiNumber].x, musicPlayButtonPoint[uiNumber].y)];
//            [self.uiButtonShadow setScale:0.0];
//            [self addChild:self.uiButtonShadow z:2];
//            [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:self.uiButtonShadow afterDelay:0.4];

        self.uiImage = [CCSprite spriteWithFile:[NSString stringWithFormat:@"P2_MusicSelectImage%d.png",uiNumber]];
        [self.uiImage setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self.uiImage setPosition:musicImagePoint[uiNumber]];
        [self.uiImage setScale:0.0];
        [self addChild:self.uiImage];
        [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:self.uiImage afterDelay:0.4];
        
        NSString * songName,*timeString;
        switch (uiNumber) {
            case 0:{
                songName = @"Honey Mushroom";
                timeString = @"1:05";
                break;
            }
            case 1:{
                songName = @"Honey Mushroom";
                timeString = @"1:05";
                break;
            }
            default: {
                songName = @"";
                timeString = @"";
                break;
            }
        }
        CCLabelTTF * uilabel1 = [CCLabelTTF labelWithString:songName fontName:@"Kankin" fontSize:36.0];
        [uilabel1 setPosition:CGPointMake(401.0 - 527.0, 368.0 - 403.0)];
        [uilabel1 setAnchorPoint:CGPointMake(0.0, 0.0)];
        [uilabel1 setColor:ccc3(255.0, 130.0, 130.0)];
        [uilabel1 setOpacity:0];
        [self addChild:uilabel1];
        [self performSelector:@selector(p2UILabelFadeInAnimation:) withObject:uilabel1 afterDelay:0.2];
        
        CCLabelTTF * uilabel2 = [CCLabelTTF labelWithString:@"Composed by" fontName:@"Kankin" fontSize:24.0];
        [uilabel2 setAnchorPoint:CGPointMake(0.0, 0.0)];
        [uilabel2 setPosition:CGPointMake(416.0 - 527.0, 334.0 - 403.0)];
        [uilabel2 setColor:ccc3(150.0, 150.0, 150.0)];
        [uilabel2 setOpacity:0];
        [self addChild:uilabel2];
        [self performSelector:@selector(p2UILabelFadeInAnimation:) withObject:uilabel2 afterDelay:0.2];
        
        CCLabelTTF * uilabel3 = [CCLabelTTF labelWithString:@"Ting Shan" fontName:@"Kankin" fontSize:24.0];
        [uilabel3 setAnchorPoint:CGPointMake(0.0, 0.0)];
        [uilabel3 setPosition:CGPointMake(549.0 - 527.0, 333.0 - 403.0)];
        [uilabel3 setColor:ccc3(90, 198.0, 255.0)];
        [uilabel3 setOpacity:0];
        [self addChild:uilabel3];
        [self performSelector:@selector(p2UILabelFadeInAnimation:) withObject:uilabel3 afterDelay:0.2];
        
        CCLabelTTF * uilabel4 = [CCLabelTTF labelWithString:@"Time:" fontName:@"Kankin" fontSize:24.0];
        [uilabel4 setAnchorPoint:CGPointMake(0.0, 0.0)];
        [uilabel4 setPosition:CGPointMake(479.0 - 527.0, 276.0 - 403.0)];
        [uilabel4 setColor:ccc3(150.0, 150.0, 150.0)];
        [uilabel4 setOpacity:0];
        [self     addChild:uilabel4];
        [self performSelector:@selector(p2UILabelFadeInAnimation:) withObject:uilabel4 afterDelay:0.2];
        
        CCLabelTTF * uilabel5 = [CCLabelTTF labelWithString:timeString fontName:@"Kankin" fontSize:24.0];
        [uilabel5 setAnchorPoint:CGPointMake(0.0, 0.0)];
        [uilabel5 setPosition:CGPointMake(538.0 - 527.0, 276.0 - 403.0)];
        [uilabel5 setColor:ccc3(89.0, 227.0, 0.0)];
        [uilabel5 setOpacity:0];
        [self addChild:uilabel5];
        [self performSelector:@selector(p2UILabelFadeInAnimation:) withObject:uilabel5 afterDelay:0.2];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)delta
{
    if (self.position.x < musicSelectPoint[0].x + kXDistanceBetweenSongs &&
        self.position.x > musicSelectPoint[0].x - kXDistanceBetweenSongs) {
        
        [self.uiShadow setOpacity:fabsf(self.position.x - musicSelectPoint[0].x) / kXDistanceBetweenSongs * 255.0];
    }
    else {
        [self.uiShadow setOpacity:255.0];

    }
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

- (void)setToFinalPosition:(CGPoint)finalPosition
              andIsToRight:(BOOL)isToRight
{
    self.isAnimationFinished = NO;
    int rate = isToRight ? 1 : -1;
    CCMoveTo * moveTo1 = [CCMoveTo actionWithDuration:0.12 position:CGPointMake(finalPosition.x + rate * 30, finalPosition.y)];
//    CCEaseOut * easeOut1 = [CCEaseOut actionWithAction:moveTo1 rate:1.5];
    CCMoveTo * moveTo2 = [CCMoveTo actionWithDuration:0.07 position:CGPointMake(finalPosition.x - rate * 15, finalPosition.y)];
//    CCEaseBackOut * easeOut2 = [CCEaseBackOut actionWithAction:moveTo2];
    CCMoveTo * moveTo3 = [CCMoveTo actionWithDuration:0.03 position:CGPointMake(finalPosition.x + rate * 5.0, finalPosition.y)];

    CCMoveTo * moveTo4 = [CCMoveTo actionWithDuration:0.03 position:CGPointMake(finalPosition.x - rate * 2.5, finalPosition.y)];

    CCMoveTo * moveTo5 = [CCMoveTo actionWithDuration:0.03 position:CGPointMake(finalPosition.x, finalPosition.y)];
//    CCEaseBackOut * easeOut3 = [CCEaseBackOut actionWithAction:moveTo3];
    CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
        self.isAnimationFinished = YES;
    }];
    CCSequence * seq = [CCSequence actions:
                        moveTo1,
                        moveTo2,
                        moveTo3,
                        moveTo4,
                        moveTo5,
                        callBack,
                        nil];
    
    [self runAction:seq];
}

- (void)shakeDialogIcon:(CCNode *)node
{
    float moveLength = 2.f;
    float moveDuration = 0.5f;
    CCMoveBy* moveBy1 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCMoveBy* moveBy2 = [CCMoveBy actionWithDuration:moveDuration * 2 position:ccp(0, moveLength * 2)];
    CCMoveBy* moveBy3 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCSequence* moveSequence =
    [CCSequence actions:
     [CCDelayTime actionWithDuration:0.5 * 0.5],
     [CCEaseSineOut actionWithAction:moveBy1],
     [CCEaseSineInOut actionWithAction:moveBy2],
     [CCEaseSineIn actionWithAction:moveBy3],
     nil];
    CCRepeatForever* moveRepeat = [CCRepeatForever actionWithAction:moveSequence];
    [node runAction:moveRepeat];
}

- (void)p2UILabelFadeInAnimation:(CCLabelTTF *)label
{
    CCFadeIn * fadeIn = [CCFadeIn actionWithDuration:0.5];
    [label runAction:fadeIn];
}

- (void)clickUIPlayButton:(id)sender
{
    [self.delegate clickUIPlayButtonByMusicNumber:self.uiNumber];
}

@end
