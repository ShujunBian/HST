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

#define EVERYDELTATIME 0.016667

@interface P2_GameScene ()

@property (strong, nonatomic) MainMapHelper* mainMapHelper;
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
//        if (frameToShowCurrentFrame == nil) {
//            frameToShowCurrentFrame = [[NSArray alloc]initWithObjects:@"5",@"6",@"7",@"8",@"9",@"10",@"11",
//                                       @"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",
//                                       @"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
//                                       @"31",@"32",@"33",@"34",@"35",@"36",@"37", nil];
//        }
//        
//        if (musicTypeInFrame == nil) {
//            musicTypeInFrame = [[NSArray alloc]initWithObjects:@"3",@"2",@"1",@"7",@"6",@"5",@"6",@"7",@"3",@"2",@"1",@"7",
//                                @"6",@"5",@"6",@"7",@"3",@"2",@"1",@"7",@"6",@"5",@"6",@"7",@"3",@"2",@"1",@"7",@"6",@"5",@"6",@"7",@"1", nil];
//        }
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
//    monster = nil;
    
    monster.position = CGPointMake(512, -5);
    
    firstLittleMonster = (P2_LittleMonster *)[CCBReader nodeGraphFromFile:@"P2_FirstLittlemonster.ccbi"];
    [self addChild:firstLittleMonster z:0];
    firstLittleMonster.position = CGPointMake(370, 0);

    
    secondLittleMonster = (P2_LittleMonster *)[CCBReader nodeGraphFromFile:@"P2_SecondLittlemonster.ccbi"];
    [self addChild:secondLittleMonster z:0];
    secondLittleMonster.position = CGPointMake(260, 0);
    
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    [monster littleJump];
    [self performSelector:@selector(letFirstLittleMonsterJump) withObject:self afterDelay:0.2];
    [self performSelector:@selector(letSecondLittleMonsterJump) withObject:self afterDelay:0.4];
    
    isFrameCounterShowed = NO;
    self.frameCounter = 1;
    deltaCounter = 0;
    _currentSongType = 2;
    
    [self schedule:@selector(updateEveryDeltaTime:) interval:0.1];
    [self scheduleUpdate];
    
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    NSString * backgroundMusic = [NSString stringWithFormat:@"P2_%d_background.mp3",_currentSongType];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:backgroundMusic loop:NO];

}

- (void)onEnter
{
    [super onEnter];
//    [NSTimer scheduledTimerWithTimeInterval:0.015 target:[VolumnHelper sharedVolumnHelper] selector:@selector(upBackgroundVolumn:) userInfo:nil repeats:YES];
    
    [self showScene];
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

-(void)updateEveryDeltaTime:(ccTime)delta
{
    deltaCounter ++;
    if (deltaCounter == 10) {
        _frameCounter ++;
        deltaCounter = 0;
        isFrameCounterShowed = NO;
    }
    
    if (_frameCounter == 68) {
        [[SimpleAudioEngine sharedEngine] rewindBackgroundMusic];
        _frameCounter = 1;
    }
    else if ([frameToShowCurrentFrame containsObject:[NSNumber numberWithInteger:_frameCounter]] && !isFrameCounterShowed){
        isFrameCounterShowed = YES;
        NSInteger musicType = [[musicTypeInFrame objectAtIndex:[frameToShowCurrentFrame indexOfObject:[NSNumber numberWithInteger:_frameCounter]]] integerValue];
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
//            CCBAnimationManager* animationManager = monster.userObject;
//            [animationManager runAnimationsForSequenceNamed:@"ReadyToJump"];
//            [monster monsterCloseEyesWhenReadyToJump];
            
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
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"world.ccbi"];
    [self changeToScene:scene];
//    [[CCDirector sharedDirector] replaceScene:
//     [CircleTransition transitionWithDuration:1.0
//                                        scene:scene]];
}

#pragma mark - 退出时释放内存
- (void)dealloc
{
    [self.monster removeFromParentAndCleanup:YES];
    self.monster = nil;
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
