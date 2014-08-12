//
//  WorldUILayer.m
//  HST
//
//  Created by Emerson on 14-8-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "WorldUILayer.h"
#import "CCLayerColor+CCLayerColorAnimation.h"

@implementation WorldUILayer

-(id)init
{
    if (self = [super init]) {
        
        CCLayerColor * shadowLayer = [CCLayerColor layerWithColor:ccc4(0.0, 0.0,0.0, 0.0 * 255.0)];
        [self addChild:shadowLayer z:-1];
        [shadowLayer fadeIn];
        [self addMainMapUIByType:0];
    }
    return self;
}

#pragma mark - 大地图UI动画
- (void)addMainMapUIByType:(MainMapType)mainmapType
{
    CCSprite * uibg = [CCSprite spriteWithFile:@"MainMapUIBg.png"];
    [uibg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uibg setPosition:CGPointMake(504, 415)];
    [uibg setScale:0.0];
    [self addChild:uibg];
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * bgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2, nil];
    [uibg runAction:bgSeq];
    
    CCSprite * uiName = [CCSprite spriteWithFile:@"MainMap_P1Name.png"];
    [uiName setPosition:CGPointMake(494.0, 608.0)];
    [uiName setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiName setScale:0.0];
    [self addChild:uiName];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiName afterDelay:0.2];
    
    CCSprite * uiButton = [CCSprite spriteWithFile:@"MainMap_P1PlayButton.png"];
    [uiButton setPosition:CGPointMake(512.0, 234.0)];
    [uiButton setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiButton setScale:0.0];
    [self addChild:uiButton];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiButton afterDelay:0.4];
    [self performSelector:@selector(shakeDialogIcon:) withObject:uiButton afterDelay:1.25];
    
    CCSprite * uiImage = [CCSprite spriteWithFile:@"MainMap_P1Image.png"];
    [uiImage setPosition:CGPointMake(300.0, 478.0)];
    [uiImage setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiImage setScale:0.0];
    [self addChild:uiImage];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiImage afterDelay:0.4];
    
    CCLabelTTF * uilabel1 = [CCLabelTTF labelWithString:@"To Moms & Dads:" fontName:@"Kankin" fontSize:32.0];
    [uilabel1 setPosition:CGPointMake(510.0, 498.0)];
    [uilabel1 setColor:ccc3(255.0, 130.0, 130.0)];
    [self addChild:uilabel1];
    
    CCLabelTTF * uilabel2 = [CCLabelTTF labelWithString:@"Alex is designed for building basic" fontName:@"Kankin" fontSize:24.0];
    [uilabel2 setPosition:CGPointMake(569.0, 458.0)];
    [uilabel2 setColor:ccc3(150.0, 150.0, 150.0)];
    [self addChild:uilabel2];
    
    CCLabelTTF * uilabel3 = [CCLabelTTF labelWithString:@"sense of tone and color for kids." fontName:@"Kankin" fontSize:24.0];
    [uilabel3 setPosition:CGPointMake(560.0, 429.0)];
    [uilabel3 setColor:ccc3(150.0, 150.0, 150.0)];
    [self addChild:uilabel3];
    
    CCLabelTTF * uilabel4c = [CCLabelTTF labelWithString:@"Level:" fontName:@"Kankin" fontSize:24.0];
    [uilabel4c setPosition:CGPointMake(432.0, 372.0)];
    [uilabel4c setColor:ccc3(150.0, 150.0, 150.0)];
    [self addChild:uilabel4c];
    
    CCLabelTTF * uilabel5 = [CCLabelTTF labelWithString:@"Basic" fontName:@"Kankin" fontSize:24.0];
    [uilabel5 setPosition:CGPointMake(491.0, 372.0)];
    [uilabel5 setColor:ccc3(89.0, 227.0, 0.0)];
    [self addChild:uilabel5];
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

- (void)shakeDialogIcon:(CCNode *)node
{
    float moveLength = 2.f;
    float moveDuration = 0.5f;
    CCMoveBy* moveBy1 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCMoveBy* moveBy2 = [CCMoveBy actionWithDuration:moveDuration * 2 position:ccp(0, moveLength * 2)];
    CCMoveBy* moveBy3 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCSequence* moveSequence =
    [CCSequence actions:
     [CCDelayTime actionWithDuration:CCRANDOM_0_1() * 0.5],
     [CCEaseSineOut actionWithAction:moveBy1],
     [CCEaseSineInOut actionWithAction:moveBy2],
     [CCEaseSineIn actionWithAction:moveBy3],
     nil];
    CCRepeatForever* moveRepeat = [CCRepeatForever actionWithAction:moveSequence];
    [node runAction:moveRepeat];
}

@end
