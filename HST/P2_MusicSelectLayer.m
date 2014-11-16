//
//  P2_MusicSelectLayer.m
//  HST
//
//  Created by Emerson on 14-8-14.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P2_MusicSelectLayer.h"
#import "SimpleAudioEngine.h"

@interface P2_MusicSelectLayer()

@property (nonatomic, strong) CCLayerColor * shadowLayer;
@property (nonatomic, strong) NSMutableArray * uiNodeArray;
@property (nonatomic, strong) NSMutableArray * uiNodeCounterArray;

@property (nonatomic, strong) UIPanGestureRecognizer * panRecognizer;
@property (nonatomic) CGPoint touchBeganLocation;
@property (nonatomic) CGPoint touchLastLocation;

@end

@implementation P2_MusicSelectLayer

-(id)init
{
    if (self = [super init]) {
        self.currentSongNumber = 0;
        
        self.uiNodeArray = [NSMutableArray arrayWithCapacity:3];
        self.uiNodeCounterArray = [NSMutableArray arrayWithCapacity:3];
        
        self.panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]autorelease];
        self.panRecognizer.delegate = self;
        [[[CCDirector sharedDirector] view] addGestureRecognizer:self.panRecognizer];
    }
    return self;
}

- (void)addP2SelectSongUI
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"UIButton.mp3"];
    [self setTouchEnabled:YES];
    [[[CCDirector sharedDirector]touchDispatcher] addTargetedDelegate:self priority:-10 swallowsTouches:YES];
    
    self.shadowLayer = [CCLayerColor layerWithColor:ccc4(0.0, 0.0,0.0, 0.0 * 255.0)];
    [self addChild:_shadowLayer z:-1];
    [_shadowLayer fadeIn];
    
    CCLabelTTF * uilabel6 = [CCLabelTTF labelWithString:@"Select a" fontName:@"Kankin" fontSize:30.0];
    [uilabel6 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel6 setPosition:CGPointMake(403.0, 689.0)];
    [uilabel6 setColor:ccc3(255.0, 255.0, 255.0)];
    [uilabel6 setOpacity:0];
    [self addChild:uilabel6];
    [self performSelector:@selector(p2UILabelFadeInAnimation:) withObject:uilabel6 afterDelay:0.2];
    
    CCLabelTTF * uilabel7 = [CCLabelTTF labelWithString:@"Song Track" fontName:@"Kankin" fontSize:30.0];
    [uilabel7 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel7 setPosition:CGPointMake(504.0, 689.0)];
    [uilabel7 setColor:ccc3(255.0, 192.0, 0.0)];
    [uilabel7 setOpacity:0];
    [self addChild:uilabel7];
    [self performSelector:@selector(p2UILabelFadeInAnimation:) withObject:uilabel7 afterDelay:0.2];
    
    for (int i = 0; i < kMaxSongNumber; ++ i) {
        P2_UINode * uiNode = [[[P2_UINode alloc]initWithUINumber:i]autorelease];
        uiNode.delegate = self;
        [self.uiNodeArray addObject:uiNode];
        
        [uiNode setAnchorPoint:CGPointMake(0.5, 0.5)];
        [uiNode setPosition:musicSelectPoint[i]];
        [self addChild:uiNode];
        
        [self.uiNodeCounterArray addObject:[NSNumber numberWithInt:i]];
    }
}

- (void)resetUINodeByCurrentSongNumber:(int)number
{
    for (P2_UINode * uiNode in self.uiNodeArray) {
        int currentIndex = [self.uiNodeArray indexOfObject:uiNode];
        [uiNode setPosition:CGPointMake(musicSelectPoint[currentIndex].x - number * kXDistanceBetweenSongs, musicSelectPoint[currentIndex].y)];
    }
}

- (void)p2UILabelFadeInAnimation:(CCLabelTTF *)label
{
    CCFadeIn * fadeIn = [CCFadeIn actionWithDuration:0.5];
    [label runAction:fadeIn];
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer{
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [recognizer velocityInView:[[CCDirector sharedDirector] view]];
        CGPoint currentLocation = [recognizer locationInView:[[CCDirector sharedDirector] view]];

        if (recognizer.state == UIGestureRecognizerStateBegan) {

        }
        else if (recognizer.state == UIGestureRecognizerStateChanged) {
            float rate = velocity.x >= 0 ? 1 : -1;
            BOOL couldDrag = NO;
            if ([[self.uiNodeCounterArray objectAtIndex:0] intValue] + rate * 1 <= 0 &&
                [[self.uiNodeCounterArray lastObject] intValue]  + rate * 1 >= 0) {
                couldDrag = YES;
            }
            
            for (P2_UINode * uiNode in self.uiNodeArray) {
                
                if (uiNode.isAnimationFinished && couldDrag) {
                    int currentIndex = [self.uiNodeArray indexOfObject:uiNode];
                    CGPoint nextXPosition = CGPointMake(uiNode.position.x + currentLocation.x - self.touchLastLocation.x , uiNode.position.y);
                    CGPoint finalPosition = CGPointMake(musicSelectPoint[currentIndex].x + ([[self.uiNodeCounterArray objectAtIndex:currentIndex] intValue] - currentIndex) * kXDistanceBetweenSongs +kXDistanceBetweenSongs * rate,
                                                        uiNode.position.y);
                    
                    if ( fabsf(nextXPosition.x - (musicSelectPoint[currentIndex].x +  ([[self.uiNodeCounterArray objectAtIndex:currentIndex] intValue] - currentIndex) * kXDistanceBetweenSongs))
                        <  kXDistanceBetweenSongs / 3.0)
                    {
                        [uiNode setPosition:nextXPosition];
                    }
                    else if (uiNode.position.x != finalPosition.x){
                        
                        BOOL isToRight = rate < 0 ? NO : YES;
                        [uiNode setToFinalPosition:finalPosition andIsToRight:isToRight];
                        int formerCounter = [[self.uiNodeCounterArray objectAtIndex:currentIndex] intValue];
                        [self.uiNodeCounterArray setObject:[NSNumber numberWithInt:formerCounter + rate * 1] atIndexedSubscript:currentIndex];
                        
                        if ([[NSNumber numberWithInt:formerCounter + rate * 1]intValue] == 0) {
                            if ([self.delegate respondsToSelector:@selector(changeCurrentSongByNumber:)])
                            {
                                [self.delegate changeCurrentSongByNumber:currentIndex + 1];
                            }
                        }
                    }
                }
            }
            self.touchLastLocation = currentLocation;

        }
        else if (recognizer.state == UIGestureRecognizerStateEnded){
            for (P2_UINode * uiNode in self.uiNodeArray) {
                if (uiNode.isAnimationFinished) {
                    int currentIndex = [self.uiNodeArray indexOfObject:uiNode];
                    CGPoint finalPosition = CGPointMake(musicSelectPoint[currentIndex].x + ([[self.uiNodeCounterArray objectAtIndex:currentIndex] intValue] - currentIndex) * kXDistanceBetweenSongs,uiNode.position.y);
                    BOOL isToRight = uiNode.position.x < finalPosition.x ? YES : NO;
                    if (uiNode.position.x != finalPosition.x) {
                        [uiNode setToFinalPosition:finalPosition andIsToRight:isToRight];
                    }
                }
            }
        }
    }

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:[[CCDirector sharedDirector] view]];
        if (fabs(translation.y) < fabs(translation.x)) {
            return YES;
        }
        else
            return NO;
    }
    return YES;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    self.touchBeganLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    self.touchLastLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    return YES;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - UINode delegate
- (void)clickUIPlayButtonByMusicNumber:(int)number
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"UILittleButton.mp3"];
    [_shadowLayer fadeOut];

    for (int i = 0; i < [self.uiNodeArray count]; ++ i) {
        P2_UINode * uiNode = [self.uiNodeArray objectAtIndex:i];
        [uiNode runAction:[self uiNodeScaleAnimation]];
    }
    
    [self performSelector:@selector(removeLayerFromGameScene) withObject:self
               afterDelay:[self.uiNodeArray count] * 0.15 + 0.1];
}

- (void)removeLayerFromGameScene
{
    [self.parent removeChild:self cleanup:YES];
    [self.delegate selectLayerRemoveFromeGameScene];
}

- (CCSequence * )uiNodeScaleAnimation
{
    CCScaleTo * scaleTo = [CCScaleTo actionWithDuration:0.1 scale:1.2];
    CCScaleTo * scaleDisappera = [CCScaleTo actionWithDuration:0.2 scale:0.0];
    return [CCSequence actions:scaleTo,scaleDisappera, nil];
}

- (void)dealloc
{
    [[[CCDirector sharedDirector]view] removeGestureRecognizer:self.panRecognizer];
    self.panRecognizer = nil;
    self.shadowLayer = nil;
    
    [self.uiNodeArray removeAllObjects];
    self.uiNodeArray = nil;
    [self.uiNodeCounterArray removeAllObjects];
    self.uiNodeCounterArray = nil;
    
    [super dealloc];

}
@end
