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
#import "MainMapHelper.h"
#import "NSNotificationCenter+Addition.h"

@interface P1_GameScene()
{
    int currentBubblePositionIndex;
    int currentPositionArrayIndex;
    BOOL shouldBlowBubble;
    BOOL couldRestart;                  //是否可以重新开始
    int bubbleCountInCurrentBlow;
    
    NSMutableArray *currentOnScreenBubbles;
    NSMutableArray *bubblesReadyToRelease;
}

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
    [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 727.0)];
    
    [CDAudioManager configure:kAMM_PlayAndRecord];
    [[CDAudioManager sharedManager] playBackgroundMusic:@"P1_bg.mp3" loop:YES];
    
    [NSNotificationCenter registerShouldReleseRestBubbleNotificationWithSelector:@selector(releaseBubbleReadyToRelease) target:self];
    
    [self.monsterInitPositionReferenceSprite setVisible:NO];
    shouldBlowBubble = NO;
    couldRestart = NO;
    _monster.delegate = self;
    if(!bubblePositions)
    {
        [self loadBubbleAttributes];
    }
    
    [P1_BlowDetecter instance].delegate = self;
    
    currentOnScreenBubbles = [@[] mutableCopy];
    bubblesReadyToRelease = [@[] mutableCopy];
    
    self.toolColorLayer.visible = NO;
    [self schedule:@selector(updateBlow:)];
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
    
    [currentOnScreenBubbles addObject:bubble];
}

#pragma mark - 移除在待移除数组中的bubble
- (void)releaseBubbleReadyToRelease
{
    NSInteger bubbleLeaveCount = [bubblesReadyToRelease count];
    for (int i = 0; i < bubbleLeaveCount;  ++ i) {
        P1_Bubble * bubble = [bubblesReadyToRelease objectAtIndex:0];
        if (bubble.isReadyRelease) {
            [bubblesReadyToRelease removeObject:bubble];
            [bubble removeFromParentAndCleanup:YES];
            [bubble release];
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
        
        for (P1_Bubble * bubble in currentOnScreenBubbles)
        {
            CGPoint bubblePosition = bubble.position;
            if((bubblePosition.x - locationInNodeSpace.x) * (bubblePosition.x - locationInNodeSpace.x) + (bubblePosition.y - locationInNodeSpace.y) * (bubblePosition.y - locationInNodeSpace.y) < 4500 && (bubble.isReadyForboom == YES))
            {
                [currentOnScreenBubbles removeObject:bubble];
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
    
    for (P1_Bubble *bubble in currentOnScreenBubbles)
    {
        [bubblesReadyToRelease addObject:bubble];
        [bubble goAway];
    }
    [currentOnScreenBubbles removeAllObjects];
    currentBubblePositionIndex++;
    if(currentBubblePositionIndex > 3)
        currentBubblePositionIndex = 0;
    bubbleCountInCurrentBlow = 0;
}

-(void)monsterMouthEndBlow:(P1_Monster*)monster
{
    
}

#pragma mark - 菜单键调用函数
- (void)restartGameScene
{
    if ([currentOnScreenBubbles count] != 0 && couldRestart) {
        couldRestart = NO;
        for (P1_Bubble *bubble in currentOnScreenBubbles)
        {
            [bubble goAway];
        }
        [currentOnScreenBubbles removeAllObjects];
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
    
    [self releaseCurrentOnScreenBubbles];
    [[CDAudioManager sharedManager] stopBackgroundMusic];
    
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFade transitionWithDuration:1.0
                                        scene:[HelloWorldLayer scene]]];
}

#pragma mark - 退出时释放内存
- (void)dealloc
{
    [super dealloc];
    
    [[CCTextureCache sharedTextureCache]removeAllTextures];
    [P1_BlowDetecter purge];
}

- (void)releaseCurrentOnScreenBubbles
{
    NSInteger bubbleCount = [currentOnScreenBubbles count];
    for (int i = 0; i < bubbleCount;  ++ i) {
        P1_Bubble * bubble = [currentOnScreenBubbles objectAtIndex:0];
        [currentOnScreenBubbles removeObject:bubble];
        [bubble removeFromParentAndCleanup:YES];
        [bubble release];
    }
    [currentOnScreenBubbles release];
    
    NSInteger bubbleLeaveCount = [bubblesReadyToRelease count];
    for (int i = 0; i < bubbleLeaveCount;  ++ i) {
        P1_Bubble * bubble = [bubblesReadyToRelease objectAtIndex:0];
        [bubblesReadyToRelease removeObject:bubble];
        [bubble removeFromParentAndCleanup:YES];
        [bubble release];
    }
    [bubblesReadyToRelease release];
}


@end
