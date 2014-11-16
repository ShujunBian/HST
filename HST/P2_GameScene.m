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
#import "P2_GameObjects.h"
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
#import "P2_SkyLayer.h"
#import "P2_MusicFinishLayer.h"
#import "P2_TapIndicator.h"

#define kP2FirstOpenKey @"kP2FirstOpenKey"

#define ADD_MONSTER_UPDATE_DELTA 0.3f

@interface P2_GameScene ()

@property (strong, nonatomic) MainMapHelper* mainMapHelper;
@property (nonatomic) NSInteger maxMusicSeconds;
@property (nonatomic) NSInteger currentSongType;
@property (strong, nonatomic) NSDate* initialDate;
@property (assign, nonatomic) int iCountHaha;
@property (assign, nonatomic) int nextMusicFrameIndex;
@property (nonatomic, strong) P2_MusicSelectLayer * musicSelectLayer;
@property (nonatomic, strong) P2_MusicFinishLayer * musicFinishLayer;
@property (nonatomic, strong) P2_TapIndicator* tapIndicator;

@property (nonatomic) int matchCounter;

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
        self.nextMusicFrameIndex = 0;
        self.currentSongType = 1;
        self.matchCounter = 0;
        
        [self initBackgroundMusicAndEffect];
        
        self.iCountHaha = 0;
    }
    return  self;
}

- (void) didLoadFromCCB
{
    [self.tapIndicator retain];
    [self.tapIndicator hideWithAnimation:NO];
    [self reorderChild:self.tapIndicator z:19];
    
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
    
//    [self performSelector:@selector(addFinishLayer) withObject:nil afterDelay:2.0];
    
    self.musicSelectLayer = [[[P2_MusicSelectLayer alloc]init]autorelease];
    self.musicSelectLayer.delegate = self;
    [self.musicSelectLayer addP2SelectSongUI];
    [self addChild:self.musicSelectLayer z:20];
    [self.mainMapHelper disableRestartButton];
    [self.mainMapHelper disableHelpButton];
}

- (void)addFinishLayer
{
    self.musicFinishLayer = [[[P2_MusicFinishLayer alloc]init]autorelease];
    self.musicFinishLayer.matchString = @"test";
    [self.musicFinishLayer addFinishedUI];
    self.musicFinishLayer.delegate = self;
    [self addChild:self.musicFinishLayer z:20];
}

- (void)playBackgroundMusic
{
    NSLog(@"current start Data is %@",[NSDate dateWithTimeIntervalSinceNow:0]);
    NSString * backgroundMusic = [NSString stringWithFormat:@"P2_%ld_background.mp3",(long)_currentSongType];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:backgroundMusic loop:NO];
    [VolumnHelper sharedVolumnHelper].isPlayingWordBgMusic = NO;
    self.initialDate = [NSDate date];
}

- (void)onEnter
{
    [super onEnter];

    [self showScene];
    
    [monster littleJump];
    [self performSelector:@selector(letFirstLittleMonsterJump) withObject:self afterDelay:0.2];
    [self performSelector:@selector(letSecondLittleMonsterJump) withObject:self afterDelay:0.4];
    
#warning 之后改为播放当前选择的音乐
//    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
//    [self playBackgroundMusic];
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

#pragma mark - 正式开始音乐播放
- (void)startMusic
{
    [self.mainMapHelper enableHelpButton];
    [self.mainMapHelper enableRestartButton];
    [self schedule:@selector(addLittleFlyObjectEverySecond:) interval:ADD_MONSTER_UPDATE_DELTA];
    [self scheduleUpdate];
    
    for (CCNode * node in [self children]) {
        
        if ([[node class] isSubclassOfClass:[P2_GrassLayer class]]) {
            ((P2_GrassLayer *)node).isWaitingForSelect = NO;
            for (CCNode * grassNode in [(P2_GrassLayer *)node children]) {
                if ([[grassNode class] isSubclassOfClass:[P2_GameObjects class]]) {
                    ((P2_GameObjects *)grassNode).isWaitingForSelect = NO;
                }
            }
        }
        else if ([[node class] isSubclassOfClass:[P2_SkyLayer class]]) {
            ((P2_SkyLayer *)node).isWaitingForSelect = NO;
        }
    }
}

- (void)stopMusic
{
    [self unschedule:@selector(addLittleFlyObjectEverySecond:)];
    [self unscheduleUpdate];

    for (CCNode * node in [self children]) {
        
        if ([[node class] isSubclassOfClass:[P2_GrassLayer class]]) {
            ((P2_GrassLayer *)node).isWaitingForSelect = YES;
            for (CCNode * grassNode in [(P2_GrassLayer *)node children]) {
                if ([[grassNode class] isSubclassOfClass:[P2_GameObjects class]]) {
                    ((P2_GameObjects *)grassNode).isWaitingForSelect = YES;
                }
            }
        }
        else if ([[node class] isSubclassOfClass:[P2_SkyLayer class]]) {
            ((P2_SkyLayer *)node).isWaitingForSelect = YES;
        }
    }
}

- (void)initBackgroundMusicAndEffect
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"P2_MusicSetting" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
    frameToShowCurrentFrame = [[NSArray alloc]initWithArray:[(NSArray *)[dictionary objectForKey: @"MusicEffectPosition"] objectAtIndex:self.currentSongType - 1]];
    musicTypeInFrame = [[NSArray alloc]initWithArray:[(NSArray *)[dictionary objectForKey: @"MusicEffect"] objectAtIndex:self.currentSongType - 1]];
    self.maxMusicSeconds = [(NSNumber *)[(NSArray *)[dictionary objectForKey:@"maxMusicSeconds"] objectAtIndex:self.currentSongType - 1] integerValue];
}

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
                ++ self.matchCounter;
                [_flyObjectsOnScreen removeObject:tempObjects];
                [tempObjects handleCollision];
                [monster handleCollision];
                break;
            }
    }
}

- (void)addLittleFlyObjectEverySecond:(float)delta
{
//    _frameCounter ++;
    
    if (_frameCounter == _maxMusicSeconds) {
        [[SimpleAudioEngine sharedEngine] rewindBackgroundMusic];
        _frameCounter = 0;
        self.nextMusicFrameIndex = 0;
        [self stopMusic];
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"P2_MusicSetting" ofType:@"plist"];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
        NSInteger maxCounter = [[(NSArray *)[dictionary objectForKey: @"MusicEffect"] objectAtIndex:self.currentSongType - 1] count];
        NSString * string = [NSString stringWithFormat:@"%d/%ld",
                             self.matchCounter,
                             (long)maxCounter
                             ];
        self.matchCounter = 0;
        self.musicFinishLayer = [[[P2_MusicFinishLayer alloc]init]autorelease];
        self.musicFinishLayer.delegate = self;
        self.musicFinishLayer.matchString = string;
        [self.musicFinishLayer addFinishedUI];
        [self addChild:self.musicFinishLayer z:20];
    }
    else
    {
        NSNumber* timeNum = frameToShowCurrentFrame[self.nextMusicFrameIndex];
        int expectedTime = [timeNum intValue];
        NSDate* d = [NSDate date];
        NSTimeInterval interval = [d timeIntervalSinceDate:self.initialDate];
        _frameCounter = (int)interval;
        if (expectedTime - 1.f - interval < ADD_MONSTER_UPDATE_DELTA * 1.1f)
        {
            //FirstOpen
            if ([self checkIsFirstOpen] )
            {
                [self setIsFirstOpen:NO];
                [self.tapIndicator showWithAnimation:YES];
            }
            
            NSNumber* musicTypeNumber = musicTypeInFrame[self.nextMusicFrameIndex];
            NSInteger musicType = musicTypeNumber.integerValue;
            [self updateForAddingLittleFly:musicType];
            self.nextMusicFrameIndex++;
            if (self.nextMusicFrameIndex >= frameToShowCurrentFrame.count)
            {
                self.nextMusicFrameIndex = 0;
            }
        }
    }
}

-(void)updateForAddingLittleFly:(NSInteger)musicType
{
    NSNumber* timeNum = frameToShowCurrentFrame[self.nextMusicFrameIndex];
    int expectedTime = [timeNum intValue];
    
    NSDate* d = [NSDate date];
    NSTimeInterval interval = [d timeIntervalSinceDate:self.initialDate];
    
    P2_LittleFlyObjects * littleFly = (P2_LittleFlyObjects *)[CCBReader nodeGraphFromFile:@"P2_LittleFly.ccbi"];
    littleFly.delegate = self;
    littleFly.currentSongType = _currentSongType;
    
    [littleFly setObjectFirstPosition:(expectedTime - 1.f - interval) * 1024.f / 2];
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
    if (monster.isFinishJump) {
        if (self.tapIndicator.isShowed) {
            [self.tapIndicator hideWithAnimation:YES];
        }
        
        monster.isFinishJump = NO;
        
        [monster monsterReadyToJump];
        [self performSelector:@selector(firstLittleMonsterJump) withObject:nil afterDelay:0.1];
        [self performSelector:@selector(secondLittleMonsterJump) withObject:nil afterDelay:0.2];
    }
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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

#pragma mark - P2_MusicSelectLayerDelegate
- (void)changeCurrentSongByNumber:(int)number
{
    self.currentSongType = number;
//    [self playBackgroundMusic];
}

- (void)selectLayerRemoveFromeGameScene
{
    self.musicSelectLayer = nil;
    
    [self initBackgroundMusicAndEffect];
    [self playBackgroundMusic];
    [self startMusic];
}
- (void)willAddFinishLayer
{
    if (self.tapIndicator.isShowed) {
        [self.tapIndicator hideWithAnimation:YES];
    }
}
- (void)finishLayerRemoveFromeGameScene
{
    self.musicFinishLayer = nil;
    
    self.musicSelectLayer = [[[P2_MusicSelectLayer alloc]init]autorelease];
    self.musicSelectLayer.delegate = self;
    self.musicSelectLayer.fIsFirst = NO;
    [self.musicSelectLayer addP2SelectSongUI];
    [self addChild:self.musicSelectLayer z:20];
    [self.musicSelectLayer resetUINodeByCurrentSongNumber:(self.currentSongType - 1)];
    [self.mainMapHelper disableRestartButton];
    [self.mainMapHelper disableHelpButton];
    
    [self initBackgroundMusicAndEffect];
    [self playBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"world.mp3" loop:YES];
    
}

#pragma mark - 菜单键调用函数 mainMapDelegate
- (void)restartGameScene
{
    
}

- (void)returnToMainMap
{
    _flyObjectsOnScreen = nil;
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
    
    [self selectLayerRemoveFromeGameScene];
    
//    [[CCDirector sharedDirector] replaceScene:
//     [CircleTransition transitionWithDuration:1.0
//                                        scene:scene]];
}
- (void)helpButtonPressed
{
    if (!self.tapIndicator.isShowed)
    {
        [self.tapIndicator showWithAnimation:YES];
    }
}

#pragma mark - 退出时释放内存
- (void)dealloc
{
    self.tapIndicator = nil;
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
}

#pragma mark - UI
- (BOOL)checkIsFirstOpen
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* fFirst = [userDefaults objectForKey:kP2FirstOpenKey];
    return !fFirst || [fFirst isEqual:[NSNull null]] || fFirst.boolValue;
}
- (BOOL)setIsFirstOpen:(BOOL)fFirst
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@NO forKey:kP2FirstOpenKey];
    return [userDefaults synchronize];
}
@end
