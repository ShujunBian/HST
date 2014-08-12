//
//  GameScene.m
//  town
//
//  Created by Song on 13-7-25.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P1_GameScene.h"
#import "cocos2d.h"
#import "P1_Bubble.h"
#import "CCBAnimationManager.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldLayer.h"
#import "NSNotificationCenter+Addition.h"
#import "CircleTransition.h"
#import "VolumnHelper.h"
#import "CCLayer+CircleTransitionExtension.h"
#import "WXYUtility.h"

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
@end


@implementation P1_GameScene

#define MAX_BUBBLE_POSITION_COUNT 4

static NSMutableArray *bubblePositions = nil;
static NSMutableArray *bubbleScales = nil;

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
    

    
    [NSNotificationCenter registerShouldReleseRestBubbleNotificationWithSelector:@selector(releaseBubbleReadyToRelease) target:self];
    
    [self.monsterInitPositionReferenceSprite setVisible:NO];
    shouldBlowBubble = NO;
    couldRestart = NO;
    _monster.delegate = self;
    if(!bubblePositions)
    {
        [self loadBubbleAttributes];
    }
    

    
    self.currentOnScreenBubbles = [NSMutableArray array];
    self.bubblesReadyToRelease = [NSMutableArray array];
    
    self.toolColorLayer.visible = NO;
    [self schedule:@selector(updateBlow:)];
}
- (void)onEnter
{
    [super onEnter];
//    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"P1_bg.mp3" loop:YES];
////    [NSTimer scheduledTimerWithTimeInterval:0.015 target:[VolumnHelper sharedVolumnHelper] selector:@selector(upBackgroundVolumn:) userInfo:nil repeats:YES];
////    [CDAudioManager configure:kAMM_PlayAndRecord];
////    [[CDAudioManager sharedManager] playBackgroundMusic:@"P1_bg.mp3" loop:YES];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"P1_bg.mp3"];
//    [NSTimer scheduledTimerWithTimeInterval:0.01 target:[VolumnHelper sharedVolumnHelper] selector:@selector(upBackgroundVolumn:) userInfo:nil repeats:YES];
    [P1_BlowDetecter instance].delegate = self;

    [self showScene];
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
    bubble.position = self.monsterInitPositionReferenceSprite.position;
    bubble.targetPosition = position;
    [bubble randomASize:scale];
    
    static int colorIndex = 0;
    colorIndex++;
    if(colorIndex == [bubble countOfColor])
    {
        colorIndex = 0;
    }
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
                break;
            }
        }
    }
}

#pragma mark - Blow Detecter Delegate
- (void)blowDetecterDidStartBlow
{
    if(!shouldBlowBubble)
        [_monster smallMouth];
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
    if ([self.currentOnScreenBubbles count] != 0 && couldRestart) {
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
    
    [[CDAudioManager sharedManager] stopBackgroundMusic];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.01 target:[VolumnHelper sharedVolumnHelper] selector:@selector(downBackgroundVolumn:) userInfo:nil repeats:YES];
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


@end
