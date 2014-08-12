//
//  WorldLayer.m
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WorldLayer.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import "CCBReader.h"
#import "MonsterEyeTestLayer.h"
#import "VolumnHelper.h"
#import "SimpleAudioEngine.h"
#import "CCLayerColor+CCLayerColorAnimation.h"

#import "CircleTransition.h"
#import "WorldP1Layer.h"
#import "WorldP2Layer.h"
#import "WorldP3Layer.h"
#import "WorldP4Layer.h"
#import "WorldP5Layer.h"

#import "CircleTransitionLayer.h"
#import "CCLayer+CircleTransitionExtension.h"

#define WORLD_P1_RECT CGRectMake(123, 455, 385, 280)
#define WORLD_P2_RECT_1 CGRectMake(25, 25, 230, 260)
#define WORLD_P2_RECT_2 CGRectMake(25, 25, 500, 95)
#define WORLD_P3_RECT CGRectMake(350, 205, 385, 205)
#define WORLD_P4_RECT CGRectMake(750, 80, 240, 275)
#define WORLD_P5_RECT CGRectMake(760, 430, 240, 240)

@interface WorldLayer ()
//@property (assign, nonatomic) float currentRadius;
//@property (strong, nonatomic) CCRenderTexture* renderTexture;
@property (assign, nonatomic) CGSize winSize;
@property (assign, nonatomic) BOOL fIsChangingScene;
@end

@implementation WorldLayer

- (void)onEnter
{
    [super onEnter];
    [self showScene];
    self.fIsChangingScene = NO;
    
    [self.p1Layer retain];
    [self.p2Layer retain];
    [self.p3Layer retain];
    [self.p4Layer retain];
    [self.p5Layer retain];

    
    
//    [self.p1Layer removeFromParentAndCleanup:YES];
//    [self.p2Layer removeFromParentAndCleanup:YES];
//    [self.p3Layer removeFromParentAndCleanup:YES];
//    [self.p4Layer removeFromParentAndCleanup:YES];
//    [self.p5Layer removeFromParentAndCleanup:YES];
//    self.p1Layer = nil;
//    self.p2Layer = nil;
//    self.p3Layer = nil;
//    self.p4Layer = nil;
//    self.p5Layer = nil;
    if (![SimpleAudioEngine sharedEngine].isBackgroundMusicPlaying)
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"world.mp3" loop:YES];
    }    
}
- (void)onExitTransitionDidStart
{
    [super onExitTransitionDidStart];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.015 target:[VolumnHelper sharedVolumnHelper] selector:@selector(downBackgroundVolumn:) userInfo:nil repeats:YES];
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)onExit
{
    [super onExit];
    self.p1Layer = nil;
    self.p2Layer = nil;
    self.p3Layer = nil;
    self.p4Layer = nil;
    self.p5Layer = nil;

}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.fIsChangingScene)
    {
        return;
    }
    CCDirector* director = [CCDirector sharedDirector];
    for (UITouch* touch in touches)
    {
        self.fIsChangingScene = YES;
        CGPoint touchLocation = [touch locationInView:director.view];
        CGPoint locationGL = [director convertToGL:touchLocation];
        CGPoint locationInNodeSpace = [self convertToNodeSpace:locationGL];
        
        if (CGRectContainsPoint(WORLD_P1_RECT, locationInNodeSpace))
        {
            
            //p1
            CCLayerColor * shadowLayer = [CCLayerColor layerWithColor:ccc4(0.0, 0.0,0.0, 0.0 * 255.0)];
            [self addChild:shadowLayer z:1];
            [shadowLayer fadeIn];
            
            [self addMainMapUIByType:MainMapP1 onLayer:shadowLayer];
            
//            [self changeToScene:^CCScene *{
//                CCScene* p1Scene = [CCBReader sceneWithNodeGraphFromFile:@"P1_GameScene.ccbi"];
//                return p1Scene;
//            }];
        }
        else if (CGRectContainsPoint(WORLD_P2_RECT_1, locationInNodeSpace) ||
                 CGRectContainsPoint(WORLD_P2_RECT_2, locationInNodeSpace))
        {
            //P2
            [self preloadMusicAndEffect];
            [self changeToScene:^CCScene *{
                CCScene* p2Scene = [CCBReader sceneWithNodeGraphFromFile:@"P2_GameScene.ccbi"];
                return p2Scene;
            }];
        }
        else if (CGRectContainsPoint(WORLD_P3_RECT, locationInNodeSpace))
        {
            //P3

            [self changeToScene:^CCScene *{
                CCScene * p3Scene = [CCBReader sceneWithNodeGraphFromFile:@"P3_GameScene.ccbi"];
                return p3Scene;
            }];
        }
        else if (CGRectContainsPoint(WORLD_P4_RECT, locationInNodeSpace))
        {
            //P4
            [self changeToScene:^CCScene *{
                CCScene * p4Scene = [CCBReader sceneWithNodeGraphFromFile:@"P4GameLayer.ccbi"];
                return p4Scene;
            }];
        }
        else if (CGRectContainsPoint(WORLD_P5_RECT, locationInNodeSpace))
        {
            //P5
            [self changeToScene:^CCScene *{
                CCScene* p5Scene = [CCBReader sceneWithNodeGraphFromFile:@"P5_GameScene.ccbi"];
                return p5Scene;
            }];
        }
        else
        {
            self.fIsChangingScene = NO;
        }
    }

}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - 大地图UI动画
- (void)addMainMapUIByType:(MainMapType)mainmapType
                   onLayer:(CCLayer *)layer
{
    CCSprite * uibg = [CCSprite spriteWithFile:@"MainMapUIBg.png"];
    [uibg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uibg setPosition:CGPointMake(504, 415)];
    [uibg setScale:0.0];
    [layer addChild:uibg];
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * bgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2, nil];
    [uibg runAction:bgSeq];
    
    CCSprite * uiName = [CCSprite spriteWithFile:@"MainMap_P1Name.png"];
    [uiName setPosition:CGPointMake(494.0, 608.0)];
    [uiName setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiName setScale:0.0];
    [layer addChild:uiName];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiName afterDelay:0.2];
    
    CCSprite * uiButton = [CCSprite spriteWithFile:@"MainMap_P1PlayButton.png"];
    [uiButton setPosition:CGPointMake(512.0, 234.0)];
    [uiButton setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiButton setScale:0.0];
    [layer addChild:uiButton];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiButton afterDelay:0.4];
    [self performSelector:@selector(shakeDialogIcon:) withObject:uiButton afterDelay:1.25];
    
    CCSprite * uiImage = [CCSprite spriteWithFile:@"MainMap_P1Image.png"];
    [uiImage setPosition:CGPointMake(300.0, 478.0)];
    [uiImage setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiImage setScale:0.0];
    [layer addChild:uiImage];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiImage afterDelay:0.4];
    
    CCLabelTTF * uilabel1 = [CCLabelTTF labelWithString:@"For Moms & Dads" fontName:@"Kankin" fontSize:64.0];
    [uilabel1 setPosition:CGPointMake(510.0, 498.0)];
    [layer addChild:uilabel1];

    
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

#pragma mark - 预加载音效
- (void)preloadMusicAndEffect
{
    for (int i = 0; i < 7; ++ i) {
        NSString * boomMusicFilename = [NSString stringWithFormat:@"P2_%d.mp3",i + 1];
        [[SimpleAudioEngine sharedEngine]preloadEffect:boomMusicFilename];
    }
}

@end
