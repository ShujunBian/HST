//
//  GameScene.m
//  town
//
//  Created by Song on 13-7-25.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_GameScene.h"
#import "cocos2d.h"
#import "CCBAnimationManager.h"
#import "SimpleAudioEngine.h"
#import "P2_GrassLayer.h"
#import "P2_Monster.h"
#import "P2_LittleMonster.h"
#import "P2_LittleFlyObjects.h"
#import "P2_CalculateHelper.h"
#import "SimpleAudioEngine.h"
#import "P2_LittleFlyBoom.h"
#import "MainMapHelper.h"
#import "HelloWorldLayer.h"
#import "CircleTransition.h"
#import "VolumnHelper.h"
#import "CCLayer+CircleTransitionExtension.h"
#import "WXYUtility.h"

#define EVERYDELTATIME 0.016667

@interface P2_GameScene ()

@property (strong, nonatomic) MainMapHelper* mainMapHelper;
@property (nonatomic) NSInteger maxMusicSeconds;
@property (nonatomic) NSInteger currentSongType;

@end

@implementation P2_GameScene
@synthesize grassLayer;
@synthesize monster;
@synthesize firstLittleMonster;
@synthesize secondLittleMonster;


- (id)init
{
    if ((self = [super init])) {
        self.frameCounter = 0;
        self.currentSongType = 2;
        
        [self initBackgroundMusicAndEffect];
    }
    return  self;
}

- (void) didLoadFromCCB
{
    self.mainMapHelper = [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 727.0)];
    
    CCLayerColor * background = [CCLayerColor layerWithColor:ccc4(183,255,225,255)];
    [self addChild:background z:-10];
    
    grassLayer = (P2_GrassLayer *)[CCBReader nodeGraphFromFile:@"P2_Grass.ccbi"];
    [self addChild:grassLayer z:1];
    
    self.monster = (P2_Monster *)[CCBReader nodeGraphFromFile:@"P2_Monster.ccbi"];
    [self addChild:monster z:0];
    
    monster.position = CGPointMake(512, -5);
    
    firstLittleMonster = (P2_LittleMonster *)[CCBReader nodeGraphFromFile:@"P2_FirstLittlemonster.ccbi"];
    [self addChild:firstLittleMonster z:0];
    firstLittleMonster.position = CGPointMake(370, 0);

    
    secondLittleMonster = (P2_LittleMonster *)[CCBReader nodeGraphFromFile:@"P2_SecondLittlemonster.ccbi"];
    [self addChild:secondLittleMonster z:0];
    secondLittleMonster.position = CGPointMake(260, 0);
    
}

- (void)playBackgroundMusic
{
    NSLog(@"current start Data is %@",[NSDate dateWithTimeIntervalSinceNow:0]);
    NSString * backgroundMusic = [NSString stringWithFormat:@"P2_%d_background.mp3",_currentSongType];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:backgroundMusic loop:NO];
    [VolumnHelper sharedVolumnHelper].isPlayingWordBgMusic = NO;

}

- (void)onEnter
{
    [super onEnter];

    [self showScene];
    
    [monster littleJump];
    [self performSelector:@selector(letFirstLittleMonsterJump) withObject:self afterDelay:0.2];
    [self performSelector:@selector(letSecondLittleMonsterJump) withObject:self afterDelay:0.4];
    
    [self schedule:@selector(addLittleFlyObjectEverySecond) interval:1.0];
    [self scheduleUpdate];
    
//    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    [self playBackgroundMusic];

}

- (void)onExit
{
    [super onExit];
    
    [frameToShowCurrentFrame release];
    frameToShowCurrentFrame = nil;
    [musicTypeInFrame release];
    musicTypeInFrame = nil;
    
    self.mainMapHelper = nil;
}

- (void)initBackgroundMusicAndEffect
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"P2_MusicSetting" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
    frameToShowCurrentFrame = [[NSArray alloc]initWithArray:[(NSArray *)[dictionary objectForKey: @"MusicEffectPosition"] objectAtIndex:0]];
    musicTypeInFrame = [[NSArray alloc]initWithArray:[(NSArray *)[dictionary objectForKey: @"MusicEffect"] objectAtIndex:0]];
    self.maxMusicSeconds = [(NSNumber *)[(NSArray *)[dictionary objectForKey:@"maxMusicSeconds"] objectAtIndex:0] integerValue];
}

//- (void)onExitTransitionDidStart
//{
//    [NSTimer scheduledTimerWithTimeInterval:0.015 target:[VolumnHelper sharedVolumnHelper] selector:@selector(upBackgroundVolumn:) userInfo:nil repeats:YES];
//}

- (void)letFirstLittleMonsterJump
{
    CCBAnimationManager* firanimationManager = firstLittleMonster.userObject;
    firanimationManager.delegate = firstLittleMonster;
    [firanimationManager runAnimationsForSequenceNamed:@"LittleJump"];
}

- (void)letSecondLittleMonsterJump
{
    CCBAnimationManager* secanimationManager = secondLittleMonster.userObject;
    secanimationManager.delegate = secondLittleMonster;
    [secanimationManager runAnimationsForSequenceNamed:@"LittleJump"];
}

- (void)update:(ccTime)delta
{
    int currentJumpFrame = [P2_CalculateHelper getMonsterCurrentJumpFrameBy:monster.currentJumpTime];
    float collisionHeight = [P2_CalculateHelper getTheMonsterCollisionHeightFrom:currentJumpFrame];
    for (P2_LittleFlyObjects * tempObjects in _flyObjectsOnScreen) {
        if ( (fabsf((monster.position.x - tempObjects.position.x)) < 50 &&
              fabsf(monster.position.y - tempObjects.position.y) < collisionHeight + 50) ||
            (fabsf((monster.position.x - tempObjects.position.x)) < 125 &&
             fabsf(monster.position.y - tempObjects.position.y) < collisionHeight)) {
                
                [_flyObjectsOnScreen removeObject:tempObjects];
                [tempObjects handleCollision];
                [monster handleCollision];
                break;
            }
    }
}

- (void)addLittleFlyObjectEverySecond
{
    _frameCounter ++;
    
    if (_frameCounter == _maxMusicSeconds) {
        [[SimpleAudioEngine sharedEngine] rewindBackgroundMusic];
        _frameCounter = 0;
    }
    else if ([frameToShowCurrentFrame containsObject:[NSNumber numberWithInteger:_frameCounter + 1]]){
        NSLog(@"%d",_frameCounter + 1);
        NSLog(@"Add subject is %@",[NSDate dateWithTimeIntervalSinceNow:0]);
        NSInteger musicType = [[musicTypeInFrame objectAtIndex:[frameToShowCurrentFrame indexOfObject:[NSNumber numberWithInteger:_frameCounter + 1]]] integerValue];
        [self updateForAddingLittleFly:musicType];
    }
}

-(void)updateForAddingLittleFly:(NSInteger)musicType
{
    P2_LittleFlyObjects * littleFly = (P2_LittleFlyObjects *)[CCBReader nodeGraphFromFile:@"P2_LittleFly.ccbi"];
    littleFly.delegate = self;
    littleFly.currentSongType = _currentSongType;
    [littleFly setObjectFirstPosition];
    [self addChild:littleFly z:0];
    littleFly.musicType = (int)musicType;
    
    ccColor3B color = [littleFly colorAtIndex:musicType];
    [littleFly setBodyColor:color];
    [self.flyObjectsOnScreen addObject:littleFly];
}


-(void)firstLittleMonsterJump
{
    firstLittleMonster.isFinishJump = NO;
    CCBAnimationManager* firstLittleMonsterAnimationManager = firstLittleMonster.userObject;
    [firstLittleMonsterAnimationManager runAnimationsForSequenceNamed:@"ReadyToJump"];
}

-(void)secondLittleMonsterJump
{
    secondLittleMonster.isFinishJump = NO;
    CCBAnimationManager* secondLittleMonsterAnimationManager = secondLittleMonster.userObject;
    [secondLittleMonsterAnimationManager runAnimationsForSequenceNamed:@"ReadyToJump"];
}

#pragma mark - Touch

-(void) ccTouchesBegan:(NSSet*)touches withEvent:(id)event
{
//    for(UITouch* touch in touches)
//    {
        if (monster.isFinishJump) {
            monster.isFinishJump = NO;
            
            [monster monsterReadyToJump];
            [self performSelector:@selector(firstLittleMonsterJump) withObject:nil afterDelay:0.2];
            [self performSelector:@selector(secondLittleMonsterJump) withObject:nil afterDelay:0.4];
        }
        
//    }
}

-(void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - property
- (NSMutableArray *)flyObjectsOnScreen
{
    if (!_flyObjectsOnScreen) {
        _flyObjectsOnScreen = [[NSMutableArray alloc]initWithCapacity:5];
    }
    return _flyObjectsOnScreen;
}

#pragma mark - LittleFlyDelegate

-(void)removeFromOnScreenArray:(P2_LittleFlyObjects *)littleFlyObject
{
    if (littleFlyObject && _flyObjectsOnScreen && [_flyObjectsOnScreen count] != 0) {
        [_flyObjectsOnScreen removeObject:littleFlyObject];
    }
}

#pragma mark - 菜单键调用函数 mainMapDelegate
- (void)restartGameScene
{
}

- (void)returnToMainMap
{
    [self unscheduleAllSelectors];
    for (CCNode * child in [self children]) {
        [child stopAllActions];
        [child unscheduleAllSelectors];
    }
    
//    [mainMapHelper release];
    self.mainMapHelper = nil;
    [self releaseCurrentFlyObjectOnScreenBubbles];
    [self releaseMusicAndEffect];
    
    [self changeToScene:^CCScene *{
        CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"world.ccbi"];
        return scene;
    }];
//    [[CCDirector sharedDirector] replaceScene:
//     [CircleTransition transitionWithDuration:1.0
//                                        scene:scene]];
}
- (void)helpButtonPressed
{
#warning 未完成
}

#pragma mark - 退出时释放内存
- (void)dealloc
{
    [self.monster removeFromParentAndCleanup:YES];
    self.monster = nil;
    [WXYUtility clearImageCachedOfPlist:@"p2_resource"];
    [super dealloc];
    
//    [[CCTextureCache sharedTextureCache]removeAllTextures];
}

#pragma mark - 释放数组和动画委托
- (void)releaseCurrentFlyObjectOnScreenBubbles
{
    NSInteger flyObjectCount = [_flyObjectsOnScreen count];
    for (int i = 0; i < flyObjectCount;  ++ i) {
        P2_LittleFlyObjects * littleFly = (P2_LittleFlyObjects *)[_flyObjectsOnScreen objectAtIndex:0];
        [_flyObjectsOnScreen removeObject:littleFly];
        [littleFly removeFromParentAndCleanup:YES];
    }
    [_flyObjectsOnScreen release];
    
    [firstLittleMonster releaseAnimationDelegate];
    [secondLittleMonster releaseAnimationDelegate];
}

#pragma mark - 释放音效和背景音乐
- (void)releaseMusicAndEffect
{
#warning 之后卸载音乐根据配置文件
    for (int i = 0; i < 7; ++ i) {
        NSString * boomMusicFilename = [NSString stringWithFormat:@"P2_%d.mp3",i + 1];
        [[SimpleAudioEngine sharedEngine]unloadEffect:boomMusicFilename];
    }
//    [[CDAudioManager sharedManager]stopBackgroundMusic];
}
@end
