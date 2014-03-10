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

@interface P1_GameScene()
{
    int currentBubblePositionIndex;
    int currentPositionArrayIndex;
    BOOL shouldBlowBubble;
    
    int bubbleCountInCurrentBlow;
    
    NSMutableArray *currentOnScreenBubbles;
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
    [CDAudioManager configure:kAMM_PlayAndRecord];
    [[CDAudioManager sharedManager] playBackgroundMusic:@"bg.mp3" loop:YES];
    
    //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bg.mp3"];
    
    [self.monsterInitPositionReferenceSprite setVisible:NO];
    shouldBlowBubble = NO;
    _monster.delegate = self;
    if(!bubblePositions)
    {
        [self loadBubbleAttributes];
    }
    
    [P1_BlowDetecter instance].delegate = self;
    
    //self.isTouchEnabled = YES;
    currentOnScreenBubbles = [@[] mutableCopy];
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


- (void)dealloc
{
    [super dealloc];
    [P1_BlowDetecter purge];
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
    NSLog(@"animationManage is %@",animationManager);
    [animationManager runAnimationsForSequenceNamed:@"blow2"];
    
    
    [self addChild:bubble];
    
    [currentOnScreenBubbles addObject:bubble];
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
    [[SimpleAudioEngine sharedEngine] playEffect:@"bubble_out.mp3"];
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

-(void)monsterMouthEndBlow:(P1_Monster*)monster
{
    
}

@end
