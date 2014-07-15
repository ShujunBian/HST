//
//  P4Bottle.m
//  hst_p4
//
//  Created by wxy325 on 1/18/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "P4Bottle.h"
#import "P4WaterLayer.h"
#import "cocos2d.h"
#import "CCBAnimationManager.h"
#import "CCSprite+getRect.h"
#import "P4Monster.h"

#import "P4GameLayer.h"

#define FOOT_SCALE_DURATION 0.3f

@interface P4Bottle ()
@property (strong, nonatomic) CCBAnimationManager* animationManager;

- (void)leftEarPressed;
- (void)rightEarPressed;
- (void)renewButtonPressed;

- (void)beginAddWater:(P4Monster*)monster;
- (void)endAddWater;

@property (strong, nonatomic) CCRepeatForever* leftEarRepeat;
@property (strong, nonatomic) CCRepeatForever* rightEarRepeat;

@property (assign, nonatomic) int addCount;

@end

@implementation P4Bottle

@dynamic isFull;
- (BOOL)isFull
{
    return self.addCount >= 6;
}

#pragma mark - Life Cycle
- (void) didLoadFromCCB
{
    self.animationManager = self.userObject;
    
    [self.waterIn stopSystem];
    [self.waterOut1 stopSystem];
    [self.waterOut2 stopSystem];
    self.addCount = 0;
    self.waterLayer.delegate = self;
    
    self.waterOut1.scaleX = -1;
}

#pragma mark - Gesture
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCDirector* director = [CCDirector sharedDirector];
//    CGRect leftEarRect = [self.leftEar getRect];
//    CGRect rightEarRect = [self.rightEar getRect];
    CGRect renewButtonRect = [self.renewButton getRect];
    for(UITouch* touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:director.view];
        CGPoint locationGL = [director convertToGL:touchLocation];
        CGPoint locationInNodeSpace = [self convertToNodeSpace:locationGL];

//        if (CGRectContainsPoint(leftEarRect, locationInNodeSpace))
//        {
//            [self leftEarPressed];
//        }
//        else if (CGRectContainsPoint(rightEarRect, locationInNodeSpace))
//        {
//            [self rightEarPressed];
//        }
//        else
        if (CGRectContainsPoint(renewButtonRect, locationInNodeSpace))
        {
            [self renewButtonPressed];
        }
    }
    
}

#pragma mark - IBAction
- (void)startEarAnimation
{
    if (!self.leftEarRepeat)
    {
        CCScaleTo* leftBig = [[CCScaleTo alloc] initWithDuration:1/3.f scaleX:1.2f scaleY:0.85f];
        CCScaleTo* leftSmall = [[CCScaleTo alloc] initWithDuration:1/3.f scaleX:1.f scaleY:1.f];
        CCSequence* leftSequence = [[CCSequence alloc] initOne:leftBig two:leftSmall];
        self.leftEarRepeat = [[CCRepeatForever alloc] initWithAction:leftSequence];
        [self.leftEar runAction:self.leftEarRepeat];
    }
    if (!self.rightEarRepeat)
    {
        CCScaleTo* rightBig = [[CCScaleTo alloc] initWithDuration:1/3.f scaleX:1.2f scaleY:0.85f];
        CCScaleTo* rightSmall = [[CCScaleTo alloc] initWithDuration:1/3.f scaleX:1.f scaleY:1.f];
        CCSequence* rightSequence = [[CCSequence alloc] initOne:rightBig two:rightSmall];
        self.rightEarRepeat = [[CCRepeatForever alloc] initWithAction:rightSequence];
        [self.rightEar runAction:self.rightEarRepeat];

    }
}

- (void)stopEarAnimation
{
    [self.leftEar stopAction:self.leftEarRepeat];
    self.leftEarRepeat = nil;
    [self.rightEar stopAction:self.rightEarRepeat];
    self.rightEarRepeat = nil;
}

- (void)leftEarPressed
{
    [self.animationManager runAnimationsForSequenceNamed:@"leftEarAnimation"];
}
- (void)rightEarPressed
{
    [self.animationManager runAnimationsForSequenceNamed:@"rightEarAnimation"];
}
- (void)renewButtonPressed
{
    self.addCount = 0;
    [self.animationManager runAnimationsForSequenceNamed:@"renewButtonRotate"];
    [self.gameLayer monstersRenew];
    [self.waterLayer beginReleaseWater];
}
- (void)capOpen
{
    [self.animationManager runAnimationsForSequenceNamed:@"capOpenAnimation"];
}
- (void)capClose
{
    [self.animationManager runAnimationsForSequenceNamed:@"capCloseAnimation"];
}

#pragma mark - Add Water
- (void)beginAddWater:(P4Monster*)monster
{
    ++self.addCount;
    [self.waterLayer beginAddWater:monster.waterColor];
}
- (void)endAddWater
{
    [self.waterLayer endAddWater];
}


- (void)startWaterIn:(P4Monster*)monster
{
    [monster startWaterDecrease];
    [self.waterIn resetSystem];

    
    CGRect bottleRect = [self.bottleMain getRect];
    CGPoint pourWaterPoint = CGPointMake(bottleRect.origin.x + bottleRect.size.width / 2 - 100, bottleRect.origin.y + bottleRect.size.height + 50);
    
    self.waterIn.position = ccp(pourWaterPoint.x + [monster getRect].size.height / 2 - 4, pourWaterPoint.y);
    
    self.waterIn.startColor = ccc4f(monster.waterColor.r / 255.f, monster.waterColor.g / 255.f, monster.waterColor.b / 255.f, 1.f);
    self.waterIn.endColor = self.waterIn.startColor;
    
    [self performSelector:@selector(beginAddWater:) withObject:monster afterDelay:self.waterIn.life];
}
- (void)stopWaterIn
{
    [self.waterIn stopSystem];
    [self performSelector:@selector(endAddWater) withObject:nil afterDelay:self.waterIn.life];
}

- (CGRect)getRect
{
    return [self.bottleMain getRect];
}


- (void)bottleMoveWithDeltaX:(float)deltaX deltaY:(float)deltaY
{
    [self.waterLayer mergeWater];
    [self.waterLayer waterMoveWithDeltaX:deltaX deltaY:deltaY];
    [self startEarAnimation];
}
- (void)bottleMoveBack:(float)delay
{
    [self performSelector:@selector(stopEarAnimation) withObject:nil afterDelay:delay];
//    [self stopEarAnimation];
}

#pragma mark - P4WaterLayer Delegate
- (void)startWaterOut:(ccColor3B)color
{
    CCScaleTo* lScale1 = [[CCScaleTo alloc] initWithDuration:FOOT_SCALE_DURATION scaleX:0.9 scaleY:1.2];
    CCScaleTo* lScale2 = [[CCScaleTo alloc] initWithDuration:FOOT_SCALE_DURATION scaleX:1 scaleY:1.];
    CCRepeatForever* lForever = [[CCRepeatForever alloc] initWithAction:[[CCSequence alloc] initOne:lScale1 two:lScale2]];

    CCScaleTo* rScale1 = [[CCScaleTo alloc] initWithDuration:FOOT_SCALE_DURATION scaleX:0.9 scaleY:1.2];
    CCScaleTo* rScale2 = [[CCScaleTo alloc] initWithDuration:FOOT_SCALE_DURATION scaleX:1 scaleY:1.];
    CCRepeatForever* rForever = [[CCRepeatForever alloc] initWithAction:[[CCSequence alloc] initOne:rScale1 two:rScale2]];
    
    [self.leftFoot runAction:lForever];
    [self.rightFoot runAction:rForever];
    
    [self.waterOut1 resetSystem];
    [self.waterOut2 resetSystem];
    self.waterOut1.startColor = ccc4FFromccc3B(color);
    self.waterOut1.endColor = self.waterOut1.startColor;
    self.waterOut2.startColor = ccc4FFromccc3B(color);
    self.waterOut2.endColor = self.waterOut2.startColor;
}
- (void)waterOutColorChange:(ccColor3B)color
{
    self.waterOut1.startColor = ccc4FFromccc3B(color);
    self.waterOut1.endColor = self.waterOut1.startColor;
    self.waterOut2.startColor = ccc4FFromccc3B(color);
    self.waterOut2.endColor = self.waterOut2.startColor;
}
- (void)endWaterOut
{
    [self.waterOut1 stopSystem];
    [self.waterOut2 stopSystem];
    [self.leftFoot stopAllActions];
    [self.rightFoot stopAllActions];
}

- (void)waterHeightChange:(float)height
{
    
}
@end
