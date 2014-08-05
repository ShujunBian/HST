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

#import "SimpleAudioEngine.h"


#import "CircleTransition.h"
#import "WorldP1Layer.h"
#import "WorldP2Layer.h"
#import "WorldP3Layer.h"
#import "WorldP4Layer.h"
#import "WorldP5Layer.h"

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
    self.fIsChangingScene = NO;
    
    [self.p1Layer retain];
    [self.p2Layer retain];
    [self.p3Layer retain];
    [self.p4Layer retain];
    [self.p5Layer retain];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"world.mp3" loop:YES];
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
}
- (void)onExitTransitionDidStart
{
    [super onExitTransitionDidStart];
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
            //P1
            CCScene* p1Scene = [CCBReader sceneWithNodeGraphFromFile:@"P1_GameScene.ccbi"];
			[[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p1Scene]];
        }
        else if (CGRectContainsPoint(WORLD_P2_RECT_1, locationInNodeSpace) ||
                 CGRectContainsPoint(WORLD_P2_RECT_2, locationInNodeSpace))
        {
            //P2
            CCScene* p2Scene = [CCBReader sceneWithNodeGraphFromFile:@"P2_GameScene.ccbi"];
            [self preloadMusicAndEffect];
			[[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p2Scene]];
        }
        else if (CGRectContainsPoint(WORLD_P3_RECT, locationInNodeSpace))
        {
            //P3
            CCScene * p3Scene = [CCBReader sceneWithNodeGraphFromFile:@"P3_GameScene.ccbi"];
            [[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p3Scene]];
        }
        else if (CGRectContainsPoint(WORLD_P4_RECT, locationInNodeSpace))
        {
            //P4
            CCScene * p4Scene = [CCBReader sceneWithNodeGraphFromFile:@"P4GameLayer.ccbi"];
            [[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p4Scene]];
        }
        else if (CGRectContainsPoint(WORLD_P5_RECT, locationInNodeSpace))
        {
            //P5
            CCScene* p5Scene = [CCBReader sceneWithNodeGraphFromFile:@"P5_GameScene.ccbi"];
			[[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p5Scene]];
        }
        else
        {
            self.fIsChangingScene = NO;
        }
    }

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
