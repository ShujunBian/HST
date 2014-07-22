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

@implementation P1_Bubble

static ccColor3B bubbleColors[] = {
    {255,229,55},//黄色
    {255,188,248},//紫色
    {91,222,255},//蓝色
    {111,255,141},//绿色
    {131,255,245},//蓝绿
    {135,246,203},
    {151,255,28},
    {255,169,175},
    {255,200,33},
    {213,176,255}
};

- (id)init
{
    if (self = [super init]) {
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
            [self unschedule:@selector(updatePosition:)];
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
    int soundID = 1 + arc4random()%11;
    for(int i = 0 ; i < [self countOfColor]; i++)
    {
        ccColor3B color = self.body.color;
        if([self isccColor3B:color theSame:[self colorAtIndex:i]])
        {
            soundID = i + 1;
            break;
        }
    }
    
    [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"P1_b%d.wav",soundID]];
    [[SimpleAudioEngine sharedEngine] performSelector:@selector(unloadEffect:)
                                           withObject:[NSString stringWithFormat:@"P1_b%d.wav",soundID] afterDelay:1.0];
    
    
    CCScaleBy *scale = [CCScaleBy actionWithDuration:0.1 scale:0.5];
    CCCallBlock * removeBubble = [CCCallBlock actionWithBlock:^{
#warning 查询是否cocosbuilder引起问题
        [self removeBubbleAndBomb];
    }];
    
    CCSequence *seq = [CCSequence actions:scale,removeBubble, nil];
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

#pragma mark - P1_BubbleBoomDelegate
- (void)removeBubbleFromParent
{
    [self removeFromParentAndCleanup:YES];
    [self release];
}
@end
