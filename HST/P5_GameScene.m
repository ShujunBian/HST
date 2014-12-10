//
//  P5_GameScene.m
//  Dig
//
//  Created by Emerson on 14-1-24.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P5_GameScene.h"
#import "P5_GrassLayer.h"
#import "P5_Monster.h"
#import "P5_SkyLayer.h"
#import "HelloWorldLayer.h"
#import "NSNotificationCenter+Addition.h"
#import "CCBReader.h"
#import "CircleTransition.h"
#import "CCLayer+CircleTransitionExtension.h"
#import "WXYUtility.h"
#import "SimpleAudioEngine.h"
#import "VolumnHelper.h"
#import "P5_UiLayer.h"
#import "CircleTransitionLayer.h"


#define kHoleCoverTag 1
#define kP5FirstOpenKey @"kP5FirstOpenKey"

@interface P5_GameScene ()

@property (strong, nonatomic) MainMapHelper* mainMapHelper;
@property (strong, nonatomic) CCLayer * chooseLayer;
@property (strong, nonatomic) P5_UiLayer* uiLayer;
@property (strong, nonatomic) P5_HelpUi* helpUi;
@property (strong, nonatomic) P5_HelpUi2* helpUi2;
@property (assign, nonatomic) int iUiState;
@property (assign, nonatomic) BOOL fIsToShowHelpUi;
@property (assign, nonatomic) BOOL fIsShowUi2;
@end

@implementation P5_GameScene
//{
//    MainMapHelper * mainMapHelper;
//}
@synthesize monsterUpground;
@synthesize monsterUnderground;
@synthesize grassLayer;
@synthesize undergrounScene;

@synthesize skyLayer;
@synthesize mountain1;
@synthesize mountain2;

- (void) didLoadFromCCB
{
    self.fIsShowUi2 = NO;
    [self.monsterUnderground retain];
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    CCLayerColor * background = [CCLayerColor layerWithColor:ccc4(183,255,226,255)];
    [self addChild:background z:-10];
    
    grassLayer = (P5_GrassLayer *)[CCBReader nodeGraphFromFile:@"P5_GrassLayer.ccbi"];
    [self addChild:grassLayer z:2];
    
    undergrounScene = (P5_UndergroundScene *)[CCBReader nodeGraphFromFile:@"P5_UndergroundScene.ccbi"];
    undergrounScene.position = CGPointMake(0.0 , -720.0);
    [self addChild:undergrounScene z:3];
    [undergrounScene createUndergroundWorld];
    undergrounScene.delegate = self;
    
    self.chooseLayer = [[[CCLayer alloc]init]autorelease];
    [self addChild:self.chooseLayer z:4];
    self.chooseLayer.visible = YES;
    
    self.uiLayer = (P5_UiLayer*)[CCBReader nodeGraphFromFile:@"P5_UiLayer.ccbi"];
    [self.chooseLayer addChild:self.uiLayer];
    self.uiLayer.position = ccp(512, -384 + 50);
    self.uiLayer.delegate = self;
    
    self.helpUi = (P5_HelpUi*)[CCBReader nodeGraphFromFile:@"P5_HelpUi.ccbi"];
    [self.chooseLayer addChild:self.helpUi];
    self.helpUi.position = ccp(0, -768 + 50);
    self.helpUi2 = (P5_HelpUi2*)[CCBReader nodeGraphFromFile:@"P5_HelpUi2.ccbi"];
    [self addChild:self.helpUi2 z:6];
    self.helpUi2.position = ccp(0, -768 + 50);
    
    monsterUpground = (P5_Monster *)[CCBReader nodeGraphFromFile:@"P5_Monster.ccbi"];
    [self addChild:monsterUpground z:0];
    monsterUpground.position = CGPointMake(700.0 , 53.0);
    monsterUpground.isUpground = YES;
    
    monsterUnderground = (P5_Monster *)[CCBReader nodeGraphFromFile:@"P5_MonsterUnderground.ccbi"];
    [undergrounScene addChild:monsterUnderground z:5];
    monsterUnderground.position = CGPointMake(900.0, 650.0);
    [monsterUnderground setVisible:NO];
    monsterUnderground.delegate = undergrounScene;
    monsterUnderground.isUpground = NO;
    undergrounScene.monsterUnderground = monsterUnderground;
    
    CCSprite * caveCover = [CCSprite spriteWithFile:@"P5_cave_cover.png"];
    [caveCover setPosition:CGPointMake(859.0, 65.0)];
    [self addChild:caveCover z:1];
    CCSprite * holeCover = [CCSprite spriteWithFile:@"P5_hole_cover.png"];
    holeCover.position = CGPointMake(900.5, 612);
    [undergrounScene addChild:holeCover z:6 tag:kHoleCoverTag];
    
    [self setScale:2.0];
    [self setPosition:CGPointMake(-winSize.width / 2 + 60.0, winSize.height /2)];

//    [self performSelector:@selector(moveToUnderground) withObject:self afterDelay:1.3];
}
- (void)showUi
{
    [self.uiLayer showAnimate];
}

- (void)onEnter
{
    [super onEnter];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"P5_BackgroundMusic.mp3"];
    [VolumnHelper sharedVolumnHelper].isPlayingWordBgMusic = NO;
    
    [[[CCDirector sharedDirector] view]setMultipleTouchEnabled:NO];
    
    [self showScene];
    
    //Help Ui
    self.iUiState = 0;
    //FirstOpen
    if ([self checkIsFirstOpen])
    {
        [self setIsFirstOpen:NO];
        //first open
        [self performSelector:@selector(showInitHelp) withObject:nil afterDelay:2.8];
        self.fIsToShowHelpUi = YES;
    }
    else
    {
        self.fIsToShowHelpUi = NO;
    }
//    [self performSelector:@selector(showUi) withObject:nil afterDelay:1.8];
}
- (void)showInitHelp
{
    [self showHelp2:YES];
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [self moveToUnderground];
}

- (void)moveToUnderground
{
    [monsterUpground rollUpground];
//    CCBAnimationManager* animationManager = monsterUpground.userObject;
//    animationManager.delegate = self;
//    [animationManager runAnimationsForSequenceNamed:@"Jump"];
    [self performSelector:@selector(changeCameraCenter) withObject:self afterDelay:0.3];
}

- (void)changeCameraCenter
{
    CCMoveTo * moveDown = [CCMoveTo actionWithDuration:1.75 position:CGPointMake(0.0, 720.0)];
    CCEaseInOut * moveEaseInout = [CCEaseInOut actionWithAction:moveDown rate:3.0];
    CCScaleTo * scaleBack = [CCScaleTo actionWithDuration:1.75 scale:1.0];
    CCEaseInOut * scaleEaseInout = [CCEaseInOut actionWithAction:scaleBack rate:3.0];
    CCSpawn * spawn = [CCSpawn actions:moveEaseInout,scaleEaseInout, nil];
    [self runAction:spawn];
    
    [self performSelector:@selector(monsterMoveToUnderground) withObject:self afterDelay:1.8];

}

- (void)monsterMoveToUnderground
{
    [monsterUnderground setVisible:YES];
    [monsterUnderground moveToUnderground];
    
    self.mainMapHelper = [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 7.0)];
}

//- (void)completedAnimationSequenceNamed:(NSString *)name
//{
//    if ([name isEqualToString:@"Jump"]) {
//        [monsterUnderground setVisible:YES];
//        [monsterUnderground moveToUnderground];
//    }
//}

#pragma mark - 清除纹理中的缓存图片 undergroundSceneDelegate
- (void)releaseTheCacheInTexture
{
    [monsterUpground removeFromParentAndCleanup:YES];
    [skyLayer removeFromParentAndCleanup:YES];
    [mountain2 removeFromParentAndCleanup:YES];
    
    [[CCTextureCache sharedTextureCache]removeTextureForKey:@"P5_cave_cover.png"];
    [[CCTextureCache sharedTextureCache]removeTextureForKey:@"P5_hole_cover.png"];
    [[CCTextureCache sharedTextureCache]removeTextureForKey:@"P5_clouds.png"];
    [[CCTextureCache sharedTextureCache]removeTextureForKey:@"P5_mountain2.png"];
}
- (void)monsterDidArrayFinal
{
    self.iUiState = 1;
    if (self.fIsToShowHelpUi) {
        [self showHelp3:YES];
    }
}
- (void)touchesBegin
{
    if (self.fIsToShowHelpUi) {
        [self showHelp2:NO];
    }
}

#pragma mark - 菜单键调用函数
- (void)restartGameScene
{

    if (self.fIsToShowHelpUi) {
        [self showHelp3:NO];
    }
    [self.mainMapHelper disableRestartButton];
    [self.mainMapHelper disableHelpButton];
    CircleTransitionLayer* circleLayer = [CircleTransitionLayer layer];
    [circleLayer removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector].runningScene addChild:circleLayer];
    [circleLayer hideSceneWithDuration:0.5f onCompletion:^{
        [undergrounScene restartUndergroundWorld];
        [circleLayer showSceneWithDuration:0.5f onCompletion:^{
            [self.mainMapHelper enableRestartButton];
            [self.mainMapHelper enableHelpButton];
            [circleLayer removeFromParentAndCleanup:YES];
            if (self.fIsToShowHelpUi && self.iUiState != 3) {
                [self showHelp1:YES];
            }
            else if (self.fIsToShowHelpUi && self.iUiState == 3)
            {
                [self showHelp2:YES];
            }
            self.iUiState = 0;
        }];
    }];
}

- (void)returnToMainMap
{
//    [mainMapHelper release];
    self.mainMapHelper = nil;
    [self unscheduleAllSelectors];
    for (CCNode * child in [self children]) {
        [child stopAllActions];
        [child unscheduleAllSelectors];
    }
    
    [NSNotificationCenter unregister:undergrounScene];

    [self changeToScene:^CCScene *{
        return [CCBReader sceneWithNodeGraphFromFile:@"world.ccbi"];
    }];
}

- (void)helpButtonPressed
{
    if (self.iUiState == 0) {
        [self showHelp2:YES];
    } else if (self.iUiState == 1) {
        [self showHelp3:YES];
        self.iUiState = 3;
    }
    self.fIsToShowHelpUi = YES;

}

- (void)showHelp1:(BOOL)fShow
{
    
    if (fShow)
    {
        [self.helpUi showShadowLayer];
        [self.helpUi showUi1];
    }
    else
    {
        [self.helpUi hideShadowLayer];
        [self.helpUi hideUi1];
    }
}

- (void)showHelp2:(BOOL)fShow
{
    if (fShow && !self.fIsShowUi2)
    {
        [self.helpUi showShadowLayer];
        [self.helpUi showUi2];
        [self.helpUi2 showUi2];
        self.fIsShowUi2 = YES;
    }
    else if (!fShow && self.fIsShowUi2)
    {
        [self.helpUi hideShadowLayer];
        [self.helpUi hideUi2];
        [self.helpUi2 hideUi2];
        self.fIsShowUi2 = NO;
    }
}
- (void)showHelp3:(BOOL)fShow
{
    if (fShow)
    {
        [self.helpUi showShadowLayer];
        [self.helpUi showUi3];
    }
    else
    {
        [self.helpUi hideShadowLayer];
        [self.helpUi hideUi3];
    }
}

- (void)musicButtonPressed
{

    if (self.fIsToShowHelpUi) {
        self.fIsToShowHelpUi = NO;
        self.iUiState = 0;
        [self showHelp1:NO];
    }
    
    [self showUi];
}

#pragma mark - 退出时释放内存
- (void)dealloc
{
//    self.monsterUnderground = nil;
    self.uiLayer = nil;
    [super dealloc];
//    [[CCTextureCache sharedTextureCache]removeAllTextures];
    [WXYUtility clearImageCachedOfPlist:@"p5_resource"];
}

#pragma mark - 
- (void)p5Ui:(P5_UiLayer*)uiLayer selectIndex:(int)index
{
    [[SimpleAudioEngine sharedEngine]playEffect:[NSString stringWithFormat:@"P5_%d_1.mp3", index + 1]];
}

- (void)p5UiOkButtonPressed:(P5_UiLayer*)uiLayer
{
    [self.uiLayer hideAnimate];
    undergrounScene.currentMusicIndex = uiLayer.currentMusicIndex;
}
#pragma mark - 
- (BOOL)checkIsFirstOpen
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* fFirst = [userDefaults objectForKey:kP5FirstOpenKey];
    return !fFirst || [fFirst isEqual:[NSNull null]] || fFirst.boolValue;
}
- (BOOL)setIsFirstOpen:(BOOL)fFirst
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@NO forKey:kP5FirstOpenKey];
    return [userDefaults synchronize];
}

@end
