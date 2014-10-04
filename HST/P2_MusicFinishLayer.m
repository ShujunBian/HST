//
//  P2_MusicFinishLayer.m
//  HST
//
//  Created by Emerson on 14-8-25.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P2_MusicFinishLayer.h"
#import "WXYMenuItemImage.h"
#import "P2_Monster.h"
#import "CCBReader.h"
#import "CCLayerColor+CCLayerColorAnimation.h"

@interface P2_MusicFinishLayer()

@property (nonatomic, strong) CCLayerColor * shadowLayer;
@property (nonatomic, strong) CCNode * uiNode;
@property (nonatomic, strong) P2_Monster * monster;
@end

@implementation P2_MusicFinishLayer

-(id)init
{
    if (self = [super init]) {
        self.matchString = @"17/26";
    }
    return self;
}

- (void)addFinishedUI
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willAddFinishLayer)])
    {
        [self.delegate willAddFinishLayer];
    }
    
    [self setTouchEnabled:YES];
    [[[CCDirector sharedDirector]touchDispatcher] addTargetedDelegate:self priority:-10 swallowsTouches:YES];
    
    self.shadowLayer = [CCLayerColor layerWithColor:ccc4(0.0, 0.0,0.0, 0.0 * 255.0)];
    [self addChild:_shadowLayer z:-1];
    [_shadowLayer fadeIn];
    
    self.uiNode = [[CCNode alloc]init];
    [self.uiNode setPosition:CGPointMake(527.0, 403.0)];
    [self.uiNode setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    CCSprite * uibg = [CCSprite spriteWithFile:@"P2_MusicSelectBg.png"];
    [uibg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uibg setPosition:CGPointMake(0.0, 0.0)];
    [uibg setScale:0.0];
    [_uiNode addChild:uibg];
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * bgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2, nil];
    [uibg runAction:bgSeq];
    
    CCSprite * monsterShadow = [CCSprite spriteWithFile:@"P2_MusicFinishShadow.png"];
    [monsterShadow setAnchorPoint:CGPointMake(0.5, 0.5)];
    monsterShadow.position = CGPointMake(521.0 - 527.0, 437.0 - 403.0);
    [_uiNode addChild:monsterShadow z:1];
    
    self.monster = (P2_Monster *)[CCBReader nodeGraphFromFile:@"P2_Monster.ccbi"];
    [_uiNode addChild:self.monster z:1];
    self.monster.position = CGPointMake(521.0 - 527.0, 437.0 - 403.0);
    [self.monster setScale:0.0];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:self.monster afterDelay:0.2];
    /*
    CCSprite * uiImage = [CCSprite spriteWithFile:[NSString stringWithFormat:@"MainMap_P%dImage.png",_currentMainMapType]];
    [uiImage setPosition:CGPointMake(300.0 - 512.0, 478.0 - 384.0)];
    [uiImage setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiImage setScale:0.0];
    [_uiNode addChild:uiImage];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiImage afterDelay:0.4];
    */
    
    CCLabelTTF * uilabel1 = [CCLabelTTF labelWithString:@"Awesome!" fontName:@"Kankin" fontSize:36.0];
    [uilabel1 setPosition:CGPointMake(453.0 - 527.0, 328.0 - 403.0)];
    [uilabel1 setColor:ccc3(255.0, 130.0, 130.0)];
    [uilabel1 setOpacity:0];
    [uilabel1 setAnchorPoint:CGPointZero];
    [_uiNode addChild:uilabel1];
    [self performSelector:@selector(mainmapUILabelFadeInAnimation:) withObject:uilabel1 afterDelay:0.2];
    
    CCLabelTTF * uilabel2 = [CCLabelTTF labelWithString:@"You've finished the song." fontName:@"Kankin" fontSize:24.0];
    [uilabel2 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel2 setPosition:CGPointMake(405.0 - 527.0, 294.0 - 403.0)];
    [uilabel2 setColor:ccc3(150.0, 150.0, 150.0)];
    [uilabel2 setOpacity:0];
    [uilabel2 setAnchorPoint:CGPointZero];
    [_uiNode addChild:uilabel2];
    [self performSelector:@selector(mainmapUILabelFadeInAnimation:) withObject:uilabel2 afterDelay:0.2];
    
    CCLabelTTF * uilabel3 = [CCLabelTTF labelWithString:@"Match:" fontName:@"Kankin" fontSize:24.0];
    [uilabel3 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel3 setPosition:CGPointMake(467.0 - 527.0, 237.0 - 403.0)];
    [uilabel3 setColor:ccc3(150.0, 150.0, 150.0)];
    [uilabel3 setOpacity:0];
    [uilabel3 setAnchorPoint:CGPointZero];
    [_uiNode addChild:uilabel3];
    [self performSelector:@selector(mainmapUILabelFadeInAnimation:) withObject:uilabel3 afterDelay:0.2];
    
    CCLabelTTF * uilabel4 = [CCLabelTTF labelWithString:self.matchString fontName:@"Kankin" fontSize:24.0];
    [uilabel4 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel4 setPosition:CGPointMake(536.0 - 527.0, 237.0 - 403.0)];
    [uilabel4 setColor:ccc3(89.0, 227.0, 0.0)];
    [uilabel4 setOpacity:0];
    [uilabel4 setAnchorPoint:CGPointZero];
    [_uiNode addChild:uilabel4];
    [self performSelector:@selector(mainmapUILabelFadeInAnimation:) withObject:uilabel4 afterDelay:0.2];
    
    [self addChild:_uiNode];
    
    [self performSelector:@selector(removeFromGameScene) withObject:self afterDelay:4.0];
}

- (void)mainmapUIScaleAnimation:(CCNode *)node
{
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.1];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.15 scale:0.95];
    CCScaleTo * uibgScaleTo5 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
        [self.monster littleJump];
    }];
    CCSequence * uibgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2,uibgScaleTo5,callBack, nil];
    [node runAction:uibgSeq];
}

- (void)mainmapUILabelFadeInAnimation:(CCLabelTTF *)label
{
    CCFadeIn * fadeIn = [CCFadeIn actionWithDuration:0.5];
    [label runAction:fadeIn];
}

- (void)removeFromGameScene
{
    [_shadowLayer fadeOut];
    
    CCScaleTo * scaleTo = [CCScaleTo actionWithDuration:0.1 scale:1.2];
    CCScaleTo * scaleDisappera = [CCScaleTo actionWithDuration:0.2 scale:0.0];
    CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
//        [self removeFromParentAndCleanup:YES];
//        [self.delegate finishLayerRemoveFromeGameScene];
        [self performSelector:@selector(removeFinishLayer) withObject:nil afterDelay:0.1];
    }];
    CCSequence * seq = [CCSequence actions:scaleTo,scaleDisappera,callBack, nil];
    [self.uiNode runAction:seq];
}

- (void)removeFinishLayer
{
    [self removeFromParentAndCleanup:YES];
    [self.delegate finishLayerRemoveFromeGameScene];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)dealloc
{
    self.shadowLayer = nil;
    self.uiNode = nil;
    self.monster = nil;

    [super dealloc];
}
@end
