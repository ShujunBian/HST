//
//  Bubble.m
//  town
//
//  Created by Song on 13-8-4.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P1_Bubble.h"
#import "cocos2d.h"
#import "CCBReader.h"
#import "P1_BubbleBomb.h"
#import "SimpleAudioEngine.h"
#import "NSNotificationCenter+Addition.h"


#define REMOVE_ACTION_TAG 288

@interface P1_Bubble ()
@property (assign, nonatomic) BOOL f1;
@property (assign, nonatomic) BOOL f2;
@property (assign, nonatomic) BOOL f3;
@property (assign, nonatomic) BOOL f4;
@end

@implementation P1_Bubble


static ccColor3B bubbleColors[] = {
    {255,255,255},  //白色 占位
    {255,229,55},   //黄色 do
    {255,188,248},  //粉色 re
    {91,222,255},   //蓝色 mi
    {111,255,141},  //绿色 fa
    {255,169,175},  // so
    {213,176,255},  // la
    {255,192,111}    // xi
};

static NSString * bubbleMusicalScale[] = {
    @"NONE",
    @"do",
    @"re",
    @"mi",
    @"fa",
    @"sol",
    @"la",
    @"xi"
};

- (id)init
{
    if (self = [super init]) {
        self.f1 = NO;
        self.f2 = NO;
        self.f3 = NO;
        self.f4 = NO;
    }
    return self;
}

- (ccColor3B)colorAtIndex:(NSUInteger)index
{
    return bubbleColors[index];
}

- (void)setBodyColor:(ccColor3B)color
{
    _body.color = color;
    _blowAnimator.color = color;
}


- (void)setTargetPosition:(CGPoint)targetPosition
{
    _targetPosition = targetPosition;
    originalPosition = self.position;
    movingTime = -0.25;
    mySineCycle = M_PI * (2 + 0.5 * CCRANDOM_MINUS1_1());
    [self unschedule:@selector(updatePosition:)];
    [self schedule:@selector(updatePosition:)];
}

- (void)updatePosition:(ccTime)delta
{
    double movingTimeTotal = 3;
    
    movingTime += delta;
    float movingPercent = movingTime / movingTimeTotal;
    if(movingPercent < 0)
        return;
    self.scale = tobeSize;
    float x,t,b,c,d,t1;//ease out func
    x = movingPercent;
    t = movingTime;
    b = 0;
    c = 1;
    d = movingTimeTotal;
    t1 = t /= d;
    float quardPercent = -c * t1 * ( t1 - 2) + b;
    
    CGFloat sinPointY = sin(quardPercent * mySineCycle) * 50;
    
    //NSLog(@"%@ moving percent:%f sinpy:%f",self, quardPercent,sinPointY);
    
    CGPoint distance = ccp(_targetPosition.x - originalPosition.x, _targetPosition.y- originalPosition.y + sinPointY);
    self.position = ccp(originalPosition.x + distance.x * quardPercent, originalPosition.y + distance.y * quardPercent);
    if(movingTime > movingTimeTotal)
    {
        movingTime = 0;
        if(self.position.y > 800)
        {
            _isReadyRelease = YES;
            [NSNotificationCenter postShouldReleseRestBubbleNotification];
        }
        else
        {
            [self unschedule:@selector(updatePosition:)];
            if ([self.delegate respondsToSelector:@selector(bubbleDidArrivePosition:)])
            {
                [self.delegate bubbleDidArrivePosition:self];
            }
        }
    }
}

- (void)randomASize:(float)size
{
    tobeSize = size;// - (arc4random() % 100 / 100.0) * 0.05;
}

- (int)countOfColor
{
    return sizeof(bubbleColors) / sizeof(ccColor3B);
}

- (void) didLoadFromCCB
{
    CCBAnimationManager * animationManager = self.userObject;
    animationManager.delegate = self;
    _isReadyForboom = NO;
    _isReadyRelease = NO;
    _body.rotation = arc4random() % 100;
    if(arc4random() % 2 == 0)
    {
        _body.texture = [[CCSprite spriteWithFile:@"bubble-normal2.png"] texture];
    }

}


- (void)goAway
{
    [self setTargetPosition:ccpAdd(self.position, ccp(-30 + CCRANDOM_0_1() * 5, 900 - self.position.y + 300 * CCRANDOM_0_1()))];
}


-(BOOL)isccColor3B:(ccColor3B)color1 theSame:(ccColor3B)color2{
    if ((color1.r == color2.r) && (color1.g == color2.g) && (color1.b == color2.b)){
        return YES;
    } else {
        return NO;
    }
}

- (void)boom
{

//    [self stopAllActions];
//    return;
    self.f1 = YES;
//    int soundID = 1 + arc4random()%11;
//    for(int i = 0 ; i < [self countOfColor]; i++)
//    {
//        ccColor3B color = self.body.color;
//        if([self isccColor3B:color theSame:[self colorAtIndex:i]])
//        {
//            soundID = i + 1;
//            break;
//        }
//    }
    
    [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"P1_%d.mp3",_currentBubbleType]];
    [[SimpleAudioEngine sharedEngine] performSelector:@selector(unloadEffect:) withObject:[NSString stringWithFormat:@"P1_%d.mp3",_currentBubbleType] afterDelay:1.0];
    self.f2 = YES;
    
    CCLabelTTF * musicalScale = [CCLabelTTF labelWithString:bubbleMusicalScale[_currentBubbleType] fontName:@"Kankin" fontSize:30.0];
    musicalScale.position = CGPointMake(self.position.x, self.position.y + 80);
    [musicalScale setColor:bubbleColors[_currentBubbleType]];
    [self.parent addChild:musicalScale];
    
    CCMoveBy * musicalScaleMoveBy = [CCMoveBy actionWithDuration:0.8 position:CGPointMake(0.0, 100.0)];
    CCFadeOut * musicalScaleFadeOut = [CCFadeOut actionWithDuration:0.8];
    CCSpawn * musicalScaleSpawn = [CCSpawn actions:musicalScaleMoveBy,musicalScaleFadeOut, nil];
    CCCallBlock * musicalScaleCallBlock = [CCCallBlock actionWithBlock:^{
        [musicalScale removeFromParentAndCleanup:YES];
    }];
    CCSequence * musicalScaleSeq = [CCSequence actions:musicalScaleSpawn,musicalScaleCallBlock, nil];
    [musicalScale runAction:musicalScaleSeq];
    
    CCScaleBy *scale = [CCScaleBy actionWithDuration:0.1f scale:0.5f];
    self.f3 = YES;
    CCCallBlock * removeBubble = [CCCallBlock actionWithBlock:^{
        [self removeBubbleAndBomb];
        self.f4 = YES;
    }];
    
    CCSequence *seq = [CCSequence actions:scale,removeBubble, nil];
//    seq.tag = REMOVE_ACTION_TAG;
    CCBAnimationManager * animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"stop"];   //Stop CCBAnimation Manager Animation
    [self runAction:seq];
}



- (void) completedAnimationSequenceNamed:(NSString *)name
{
    if ([name isEqualToString:@"blow2"]) {
        _isReadyForboom = YES;
    }
}

- (void)removeBubbleAndBomb
{
    self.visible = NO;
    
    P1_BubbleBomb *n = (P1_BubbleBomb *)[CCBReader nodeGraphFromFile:@"P1_BubbleBoom.ccbi"];
    n.position = self.position;
    n.scale = self.scale * 1.2;
    n.tintColor = self.body.color;
    n.delegate = self;
    [self.parent addChild:n];
}

- (void)onExit
{
    [super onExit];
    CCBAnimationManager * animationManager = self.userObject;
    animationManager.delegate = nil;
}


#pragma mark - P1_BubbleBoomDelegate
- (void)removeBubbleFromParent
{
    [self removeFromParentAndCleanup:YES];
//    [self release];
}
@end
