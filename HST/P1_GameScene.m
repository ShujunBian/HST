//
//  GameScene.m
//  town
//
//  Created by Song on 13-7-25.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P1_GameScene.h"
#import "cocos2d.h"
#import "CCBAnimationManager.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldLayer.h"
#import "NSNotificationCenter+Addition.h"
#import "CircleTransition.h"
#import "VolumnHelper.h"
#import "CCLayer+CircleTransitionExtension.h"
#import "WXYUtility.h"
#import "P1_GameUI.h"
#import "P1_TapUI.h"

#define kP1FirstOpenKey @"kP1FirstOpenKey"

#define kBubbleZorder 10
#define kP1Zorder 21


@interface P1_GameScene()
{
    int currentBubblePositionIndex;
    int currentPositionArrayIndex;
    BOOL shouldBlowBubble;
    BOOL couldRestart;                  //是否可以重新开始
    int bubbleCountInCurrentBlow;
    
//    MainMapHelper * mainMapHelper;
}
@property (strong, nonatomic) MainMapHelper* mainMapHelper;
@property (strong, nonatomic) NSMutableArray* bubblesReadyToRelease;
@property (strong, nonatomic) NSMutableArray* currentOnScreenBubbles;
@property (nonatomic) BOOL isAutoBubble;
@property (strong, nonatomic) CCSprite* blowUi;

@property (strong, nonatomic) P1_TapUI* tapUI;
@property (assign, nonatomic) BOOL fToShowTapIndicator;
@end


@implementation P1_GameScene
#define MAX_BUBBLE_POSITION_COUNT 4

static NSMutableArray *bubblePositions = nil;
static NSMutableArray *bubbleScales = nil;
- (P1_TapUI*)tapUI
{
    if (!_tapUI)
    {
        _tapUI = (P1_TapUI*)[CCBReader nodeGraphFromFile:@"P1_TapUI.ccbi"];
        [_tapUI retain];
    }
    return _tapUI;
}

- (CCSprite*)blowUi
{
    if (!_blowUi)
    {
        _blowUi = [CCSprite spriteWithFile:@"p1_blow.png"];
        [_blowUi retain];
    }
    return _blowUi;
}

- (void)loadBubbleAttributes
{
    bubblePositions = [@[] mutableCopy];
    bubbleScales = [@[] mutableCopy];
    for(int i = 1; i <= MAX_BUBBLE_POSITION_COUNT; i++)
    {
        NSString *filename = [NSString stringWithFormat:@"P1_BubblePosition%d.ccbi",i];
        CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:filename];
        CCLayer *layer = [scene.children lastObject];
        CCSprite * body;
        NSMutableArray* positions = [@[] mutableCopy];
        NSMutableArray* scales = [@[] mutableCopy];
        CCARRAY_FOREACH(layer.children,body)
        {
            CGPoint p = body.position;
            [positions addObject:[NSValue valueWithCGPoint:p]];
            [scales addObject:@(body.scale)];
        }
        [bubblePositions addObject:positions];
        [bubbleScales addObject:scales];
    }
}

- (void) didLoadFromCCB
{
    self.mainMapHelper = [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 727.0)];
    [self reorderChild:self.gameUI z:18];

    
    [NSNotificationCenter registerShouldReleseRestBubbleNotificationWithSelector:@selector(releaseBubbleReadyToRelease) target:self];
    
    [self.monsterInitPositionReferenceSprite setVisible:NO];
    shouldBlowBubble = NO;
    couldRestart = NO;
    _monster.delegate = self;
    if(!bubblePositions)
    {
        [self loadBubbleAttributes];
    }
    
    self.isAutoBubble = NO;
    
    self.currentOnScreenBubbles = [NSMutableArray array];
    self.bubblesReadyToRelease = [NSMutableArray array];
    
    self.toolColorLayer.visible = NO;
    [self schedule:@selector(updateBlow:)];
    [self.gameUI retain];
    [self.gameUI updateOrientation:[UIApplication sharedApplication].statusBarOrientation];

    //FirstOpen
    if ([self checkIsFirstOpen] )
    {
        [self setIsFirstOpen:NO];
        //first open
        [self.gameUI setIsFirstOpen:YES];
        self.fToShowTapIndicator = YES;
        self.mainMapHelper.mainMapMenu.enabled = NO;
        self.mainMapHelper.helpMenu.enabled = NO;
    }
    else
    {
        [self.gameUI setIsFirstOpen:NO];
        self.fToShowTapIndicator = NO;
        self.mainMapHelper.mainMapMenu.enabled = YES;
        self.mainMapHelper.helpMenu.enabled = YES;
    }
}
#pragma mark - UI
- (BOOL)checkIsFirstOpen
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* fFirst = [userDefaults objectForKey:kP1FirstOpenKey];
    return !fFirst || [fFirst isEqual:[NSNull null]] || fFirst.boolValue;
}
- (BOOL)setIsFirstOpen:(BOOL)fFirst
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@NO forKey:kP1FirstOpenKey];
    return [userDefaults synchronize];
}

#pragma mark - Life Cycle
- (void)onEnter
{
    [super onEnter];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"P1_bg.mp3"];
    [VolumnHelper sharedVolumnHelper].isPlayingWordBgMusic = NO;
    
    [P1_BlowDetecter instance].delegate = self;

    [self showScene];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
}

- (void)onExit
{
    [super onExit];
    self.currentOnScreenBubbles = nil;
    self.bubblesReadyToRelease = nil;
    
    [P1_BlowDetecter purge];
    self.mainMapHelper = nil;
    self.gameUI = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)hideToolColorLayer
{
    self.toolColorLayer.visible = NO;
}

-(void) updateBlow:(ccTime)delta
{
    static float blowInterval = 0;
    if(shouldBlowBubble)
    {
        blowInterval += delta;
        if(bubbleCountInCurrentBlow >= 5)
        {
            [_monster bigMouth];
            shouldBlowBubble = NO;
            couldRestart = YES;
            [self performSelector:@selector(hideToolColorLayer) withObject:nil afterDelay:0.1];
            
            return;
        }
        
        if(blowInterval > 0.2)
        {
            blowInterval = 0;
            NSArray *positions = bubblePositions[currentBubblePositionIndex];
            NSValue *v = positions[bubbleCountInCurrentBlow];
            
            NSArray *scales = bubbleScales[currentBubblePositionIndex];
            NSNumber *scale = scales[bubbleCountInCurrentBlow];
            
            //NSLog(@"pp:%@ %@",v,scale);
            CGPoint p = [v CGPointValue];
            [self blowOutABubbleToPosition:p andScale:[scale floatValue]];
            
            bubbleCountInCurrentBlow++;
            
        }
    }
}

- (void)blowOutABubbleToPosition:(CGPoint)position andScale:(float)scale
{
    P1_Bubble *bubble = (P1_Bubble *)[CCBReader nodeGraphFromFile:@"P1_Bubble.ccbi"];
    bubble.delegate = self;
    bubble.position = self.monsterInitPositionReferenceSprite.position;
    bubble.targetPosition = position;
    [bubble randomASize:scale];
    
    static int colorIndex = 0;
    colorIndex++;
    if(colorIndex == [bubble countOfColor])
    {
        colorIndex = 1;
    }
    bubble.currentBubbleType = (P1_BubbleType)colorIndex;
    ccColor3B color = [bubble colorAtIndex:colorIndex];
    [bubble setBodyColor:color];
    
    self.toolColorLayer.visible = YES;
    self.toolColorLayer.color = color;
    
    CCBAnimationManager* animationManager = bubble.userObject;
    [animationManager runAnimationsForSequenceNamed:@"blow2"];
    
    [self addChild:bubble];
    
    [self.currentOnScreenBubbles addObject:bubble];
}

#pragma mark - 移除在待移除数组中的bubble
- (void)releaseBubbleReadyToRelease
{
    NSInteger bubbleLeaveCount = [self.bubblesReadyToRelease count];
    for (int i = 0; i < bubbleLeaveCount;  ++ i) {
        P1_Bubble * bubble = [self.bubblesReadyToRelease objectAtIndex:0];
        if (bubble.isReadyRelease) {
            [self.bubblesReadyToRelease removeObject:bubble];
            [bubble removeFromParentAndCleanup:YES];
//            [bubble release];
        }
    }
}

#pragma mark - Touch

-(void) ccTouchesBegan:(NSSet*)touches withEvent:(id)event
{
    CCDirector* director = [CCDirector sharedDirector];
    for(UITouch* touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:[director view]];
        CGPoint locationGL = [director convertToGL:touchLocation];
        CGPoint locationInNodeSpace = [self convertToNodeSpace:locationGL];
        
        for (P1_Bubble * bubble in self.currentOnScreenBubbles)
        {
            CGPoint bubblePosition = bubble.position;
            if((bubblePosition.x - locationInNodeSpace.x) * (bubblePosition.x - locationInNodeSpace.x) + (bubblePosition.y - locationInNodeSpace.y) * (bubblePosition.y - locationInNodeSpace.y) < 4500 && (bubble.isReadyForboom == YES))
            {
                [self.currentOnScreenBubbles removeObject:bubble];
                [bubble boom];
                
                if (_isAutoBubble) {
                    if ([self.currentOnScreenBubbles count] == 0) {
                        [self blowOutTheBubble];
                    }
                }

                if (self.tapUI)
                {
                    [self hideTapUI];
                }
                
                break;
            }
        }
    }
}

- (void)openTouch
{
    [self setTouchEnabled:YES];
}

- (void)blowOutTheBubble
{
    if(!shouldBlowBubble) {
        [self.gameUI handleBlow];
        if (self.tapUI.fIsShow) {
            [self hideTapUI];
            self.fToShowTapIndicator = YES;
        }
        self.mainMapHelper.mainMapMenu.enabled = YES;
        self.mainMapHelper.helpMenu.enabled = YES;
        [_monster smallMouth];
        [self setTouchEnabled:NO];
        [self performSelector:@selector(openTouch) withObject:nil afterDelay:1.0];
    }
}
#pragma mark - Blow Detecter Delegate
- (void)blowDetecterDidStartBlow
{
    [self blowOutTheBubble];
}

- (void)blowDetecterDidEndBlow
{
    
}

#pragma mark - Monster Delegate
-(void)monsterMouthStartBlow:(P1_Monster*)monster
{
    shouldBlowBubble = YES;
    [[SimpleAudioEngine sharedEngine] playEffect:@"P1_bubble_out.mp3"];
    [[SimpleAudioEngine sharedEngine] performSelector:@selector(unloadEffect:)
                                           withObject:@"P1_bubble_out.mp3" afterDelay:1.0];
    
    for (P1_Bubble * bubble in self.currentOnScreenBubbles)
    {
        [self.bubblesReadyToRelease addObject:bubble];
        [bubble goAway];
    }
    [self.currentOnScreenBubbles removeAllObjects];
    currentBubblePositionIndex++;
    if(currentBubblePositionIndex > 3)
        currentBubblePositionIndex = 0;
    bubbleCountInCurrentBlow = 0;
}

-(void)monsterMouthEndBlow:(P1_Monster*)monster
{
    
}

#pragma mark - 菜单键调用函数 mainMapDelegate
- (void)restartGameScene
{
    
    if (!self.gameUI.fIsFirst)
    {
        [self.gameUI handleBlow];
    }
    if (!_isAutoBubble) {
        [P1_BlowDetecter purge];
        _isAutoBubble = YES;
        CCNode<CCRGBAProtocol> *normalImage = [CCSprite spriteWithFile:@"P1_AutoButtonSelected.png"];
        [self.mainMapHelper.restartItem setNormalImage:normalImage];
        if ([self.currentOnScreenBubbles count] == 0) {
            [self blowOutTheBubble];
        }
    }
    else {
        [P1_BlowDetecter instance].delegate = self;
        _isAutoBubble = NO;
        CCNode<CCRGBAProtocol> *normalImage = [CCSprite spriteWithFile:@"P1_AutoButton.png"];
        [self.mainMapHelper.restartItem setNormalImage:normalImage];
    }

/*    if ([self.currentOnScreenBubbles count] != 0 && couldRestart) {
        couldRestart = NO;
        for (P1_Bubble *bubble in self.currentOnScreenBubbles)
        {
            [self.bubblesReadyToRelease addObject:bubble];
            [bubble goAway];
        }
        [self.currentOnScreenBubbles removeAllObjects];
        currentBubblePositionIndex++;
        if(currentBubblePositionIndex > 3)
            currentBubblePositionIndex = 0;
        bubbleCountInCurrentBlow = 0;
    }
 */
}

- (void)returnToMainMap
{
    [self unscheduleAllSelectors];
    for (CCNode * child in [self children]) {
        [child stopAllActions];
        [child unscheduleAllSelectors];
    }
    
    [NSNotificationCenter unregister:self];
    self.mainMapHelper = nil;
    [self releaseCurrentOnScreenBubbles];
    
    [self changeToScene:^CCScene *{
        CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"world.ccbi"];
        return scene;
    }];
}

- (void)helpButtonPressed
{
    if (self.gameUI.fIsShowShadow) {
        return;
    }
    self.gameUI.fIsFirst = NO;
    [self reorderUiForHelpButtonPressed];
    if (self.tapUI.fIsShow)
    {
        [self hideTapUI];
    }
    [self.gameUI restart];
    self.fToShowTapIndicator = YES;
//    self.mainMapHelper.mainMapMenu.enabled = NO;
//    self.mainMapHelper.helpMenu.enabled = NO;
}
- (void)reorderUiForHelpButtonPressed
{
    [self reorderChild:self.mainMapHelper.mainMapMenu z:25];
}
- (void)hideTapUI
{
    [self.tapUI stopAllActions];
    for (CCNodeRGBA* node in self.tapUI.children)
    {
        [node stopAllActions];
        if ([node respondsToSelector:@selector(setOpacity:)]) {
            [node runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];
        }
    }
    self.tapUI.fIsShow = NO;
}

#pragma mark - 退出时释放内存
- (void)dealloc
{
    [super dealloc];
    [WXYUtility clearImageCachedOfPlist:@"p1_resource"];
//    [[CCTextureCache sharedTextureCache]removeAllTextures];
}

- (void)releaseCurrentOnScreenBubbles
{
    NSInteger bubbleCount = [self.currentOnScreenBubbles count];
    for (int i = 0; i < bubbleCount;  ++ i) {
        P1_Bubble * bubble = [self.currentOnScreenBubbles objectAtIndex:0];
        [self.currentOnScreenBubbles removeObject:bubble];
        [bubble removeFromParentAndCleanup:YES];
//        [bubble release];
    }
    self.currentOnScreenBubbles = nil;
//    [self.currentOnScreenBubbles release];

    
    NSInteger bubbleLeaveCount = [self.bubblesReadyToRelease count];
    for (int i = 0; i < bubbleLeaveCount;  ++ i) {
        P1_Bubble * bubble = [self.bubblesReadyToRelease objectAtIndex:0];
        [self.bubblesReadyToRelease removeObject:bubble];
        [bubble removeFromParentAndCleanup:YES];
//        [bubble release];
    }
    self.currentOnScreenBubbles = nil;
//    [bubblesReadyToRelease release];
    
}
- (void)handleDeviceOrientationChange
{
    [self.gameUI updateOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

#pragma mark - P1_BubbleDelegate
- (void)showTapIndicatorForBubblePosition:(CGPoint)pos
{
    if (self.fToShowTapIndicator && !self.gameUI.fIsShowShadow)
    {
        self.fToShowTapIndicator = NO;
        [self.tapUI removeFromParentAndCleanup:YES];
        [self addChild:self.tapUI z:kBubbleZorder + 1];
        [self.tapUI stopAllActions];
        for (CCNodeRGBA* node in self.tapUI.children)
        {
            [node stopAllActions];
            if ([node respondsToSelector:@selector(setOpacity:)]) {
                node.opacity = 0;
                [node runAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.3f opacity:255], nil]];
            }
        }
        
        pos.y -= 150.f;
        self.tapUI.position = pos;
        self.tapUI.fIsShow = YES;
    }
}
- (void)bubbleDidArrivePosition:(P1_Bubble *)bubble
{
    [self showTapIndicatorForBubblePosition:bubble.position];
}
@end
