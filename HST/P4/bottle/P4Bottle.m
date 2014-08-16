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

@property (strong, nonatomic) NSMutableArray* soundObjArray;

- (void)leftEarPressed;
- (void)rightEarPressed;
- (void)renewButtonPressed;

- (void)beginAddWater:(P4Monster*)monster;
- (void)endAddWater;

@property (strong, nonatomic) CCRepeatForever* leftEarRepeat;
@property (strong, nonatomic) CCRepeatForever* rightEarRepeat;


//@property (assign, nonatomic) float waterInOriginLife;

@end

@implementation P4Bottle

@dynamic isFull;
@dynamic isAboutToFull;
- (BOOL)isFull
{
    return self.addCount >= 6;
}
- (BOOL)isAboutToFull
{
    return self.addCount >= 5;
}

#pragma mark - Life Cycle
- (void) didLoadFromCCB
{
    //cocosbuilder retain
    [self.leftEar retain];
    [self.rightEar retain];
    [self.leftFoot retain];
    [self.rightFoot retain];
    [self.bottleMain retain];
    [self.waterLayer retain];
    [self.leftCap retain];
    [self.rightCap retain];
    [self.waterInLeft retain];
    [self.waterInRight retain];
    [self.waterOut1 retain];
    [self.waterOut2 retain];
    [self.renewButton retain];
    
    
    self.animationManager = self.userObject;
//    [self.userObject release];
//    self.userObject = nil;
    
    
    [self.waterInLeft stopSystem];
    [self.waterInRight stopSystem];
    [self.waterOut1 stopSystem];
    [self.waterOut2 stopSystem];
    _addCount = 0;
    self.waterLayer.delegate = self;
    
    self.waterInRight.scaleX = -1;
    self.waterOut1.scaleX = -1;
    
//    self.waterInOriginLife = self.waterInLeft.life;
    self.soundObjArray = [NSMutableArray array];
}
- (void)onExit
{
    [super onExit];
    self.bottleMain = nil;
    self.leftCap = nil;
    self.rightCap = nil;
    self.leftEar = nil;
    self.rightEar = nil;
    self.leftFoot = nil;
    self.rightFoot = nil;
    self.renewButton = nil;
    self.waterLayer = nil;
    self.waterInLeft = nil;
    self.waterInRight = nil;
    self.waterOut1 = nil;
    self.waterOut2 = nil;
    self.animationManager = nil;
    self.soundObjArray = nil;
//    [self.leftFoot stopAllActions];
//    [self.rightFoot stopAllActions];

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
        CCScaleTo* leftBig = [[[CCScaleTo alloc] initWithDuration:1/3.f scaleX:1.2f scaleY:0.85f] autorelease];
        CCScaleTo* leftSmall = [[[CCScaleTo alloc] initWithDuration:1/3.f scaleX:1.f scaleY:1.f] autorelease];
        CCSequence* leftSequence = [[[CCSequence alloc] initOne:leftBig two:leftSmall] autorelease];
        self.leftEarRepeat = [[[CCRepeatForever alloc] initWithAction:leftSequence] autorelease];
        [self.leftEar runAction:self.leftEarRepeat];
    }
    if (!self.rightEarRepeat)
    {
        CCScaleTo* rightBig = [[[CCScaleTo alloc] initWithDuration:1/3.f scaleX:1.2f scaleY:0.85f] autorelease];
        CCScaleTo* rightSmall = [[[CCScaleTo alloc] initWithDuration:1/3.f scaleX:1.f scaleY:1.f] autorelease];
        CCSequence* rightSequence = [[[CCSequence alloc] initOne:rightBig two:rightSmall] autorelease];
        self.rightEarRepeat = [[[CCRepeatForever alloc] initWithAction:rightSequence] autorelease];
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
- (void)updateRenewButton
{
    if (self.gameLayer.someMonsterAnimated)
    {
        if (self.renewButton.opacity == 255)
        {
//            [self stopAllActions];
            [self.renewButton runAction:[CCFadeTo actionWithDuration:0.3f opacity:128]];
        }

//        [self.renewButton runAction:[CCMoveBy actionWithDuration:0.5f position:ccp(100,100)]];
//        self.renewButton.opacity = 128;
    }
    else
    {
        if (self.renewButton.opacity == 128) {
            [self.renewButton runAction:[CCFadeTo actionWithDuration:0.3f opacity:255]];
        }

//        self.renewButton.opacity = 255;
    }
}
- (void)renewButtonPressed
{
    if (self.gameLayer.someMonsterAnimated)
    {
        return;
    }
    [self.animationManager runAnimationsForSequenceNamed:@"renewButtonRotate"];
    [self.gameLayer monstersRenew];
    [self.waterLayer beginReleaseWater];
    _addCount = 0;
}
- (void)capOpen
{
    [self.leftCap stopAllActions];
    [self.rightCap stopAllActions];
    self.leftCap.position = ccp(508.f,597.f);
    self.rightCap.position = ccp(507.f,597.f);
    [self.leftCap runAction:[CCMoveTo actionWithDuration:1.f position:ccp(425.f, 597.f)]];
    [self.rightCap runAction:[CCMoveTo actionWithDuration:1.f position:ccp(590.f, 597.f)]];
    
//    [self.animationManager runAnimationsForSequenceNamed:@"capOpenAnimation"];
}
- (void)capClose
{
//    [self.animationManager runAnimationsForSequenceNamed:@"capCloseAnimation"];
    [self.leftCap stopAllActions];
    [self.rightCap stopAllActions];
    self.leftCap.position = ccp(425.f, 597.f);
    self.rightCap.position = ccp(590.f, 597.f);
    [self.leftCap runAction:[CCMoveTo actionWithDuration:1.f position:ccp(508.f,597.f)]];
    [self.rightCap runAction:[CCMoveTo actionWithDuration:1.f position:ccp(507.f,597.f)]];
}

#pragma mark - Add Water
- (void)beginAddWater:(P4Monster*)monster
{
//    [self beginBottleSound];
    P4MonsterSoundObj* obj = [[[P4MonsterSoundObj alloc] initWithMonster:monster] autorelease];
    obj.delegate = self;
//    [obj beginSound];
    [self.soundObjArray addObject:obj];
    
    ++_addCount;
    
    BOOL fIsRight = YES;
    switch (monster.type) {
        case P4MonsterTypeGreen:
        case P4MonsterTypeYellow:
        case P4MonsterTypePurple:
        {
            fIsRight = NO;
            break;
        }
        case P4MonsterTypeBlue:
        case P4MonsterTypeRed:
        default:
        {
            fIsRight = YES;
            break;
        }
    }
    
    [self.waterLayer beginAddWater:monster.waterColor isRight:fIsRight];
}
- (void)endAddWater
{
    [self.waterLayer endAddWater];
}


- (void)startWaterIn:(P4Monster*)monster
{
    [monster startWaterDecrease];
    
    
    BOOL fIsRight = NO;
    switch (monster.type)
    {
        case P4MonsterTypeGreen:
        case P4MonsterTypeYellow:
        case P4MonsterTypePurple:
        {
            fIsRight = NO;
            break;
        }
        case P4MonsterTypeBlue:
        case P4MonsterTypeRed:
        default:
        {
            fIsRight = YES;
            break;
        }
    }
    
    if (fIsRight)
    {
        [self.waterInRight resetSystem];
    }
    else
    {
        [self.waterInLeft resetSystem];
    }
    
    float deltaX = fIsRight? 100 : -100;
    CGRect bottleRect = [self.bottleMain getRect];
    CGPoint pourWaterPoint = CGPointMake(bottleRect.origin.x + bottleRect.size.width / 2 + deltaX, bottleRect.origin.y + bottleRect.size.height + 50);
    
    if (fIsRight)
    {
        self.waterInRight.position = ccp(pourWaterPoint.x - [monster getRect].size.height / 2 + 4, pourWaterPoint.y);
        self.waterInRight.startColor = ccc4f(monster.waterColor.r / 255.f, monster.waterColor.g / 255.f, monster.waterColor.b / 255.f, 1.f);
        self.waterInRight.endColor = self.waterInRight.startColor;
    }
    else
    {
        self.waterInLeft.position = ccp(pourWaterPoint.x + [monster getRect].size.height / 2 - 4, pourWaterPoint.y);
        
        self.waterInLeft.startColor = ccc4f(monster.waterColor.r / 255.f, monster.waterColor.g / 255.f, monster.waterColor.b / 255.f, 1.f);
        self.waterInLeft.endColor = self.waterInLeft.startColor;
    }
    
    [self performSelector:@selector(beginAddWater:) withObject:monster afterDelay:self.waterInLeft.life];
}
- (void)stopWaterIn
{
    [self.waterInLeft stopSystem];
    [self.waterInRight stopSystem];
    [self performSelector:@selector(endAddWater) withObject:nil afterDelay:self.waterInLeft.life];
}

- (CGRect)getRect
{
    return [self.bottleMain getRect];
}


- (void)bottleMoveWithDeltaX:(float)deltaX deltaY:(float)deltaY
{
    [self beginBottleSound];
    
    [self.waterLayer mergeWater];
    [self.waterLayer waterMoveWithDeltaX:deltaX deltaY:deltaY];
    [self startEarAnimation];
}
- (void)bottleMoveBack:(float)delay
{
    [self performSelector:@selector(stopEarAnimation) withObject:nil afterDelay:delay];
//    [self performSelector:@selector(endBottleSound) withObject:nil afterDelay:delay];

//    [self stopEarAnimation];
}

#pragma mark - P4WaterLayer Delegate
- (void)startWaterOut:(ccColor3B)color
{
    CCScaleTo* lScale1 = [[[CCScaleTo alloc] initWithDuration:FOOT_SCALE_DURATION scaleX:0.9 scaleY:1.2] autorelease];
    CCScaleTo* lScale2 = [[[CCScaleTo alloc] initWithDuration:FOOT_SCALE_DURATION scaleX:1 scaleY:1.] autorelease];
    CCRepeatForever* lForever = [[[CCRepeatForever alloc] initWithAction:[CCSequence actionOne:lScale1 two:lScale2]] autorelease];

    CCScaleTo* rScale1 = [[[CCScaleTo alloc] initWithDuration:FOOT_SCALE_DURATION scaleX:0.9 scaleY:1.2] autorelease];
    CCScaleTo* rScale2 = [[[CCScaleTo alloc] initWithDuration:FOOT_SCALE_DURATION scaleX:1 scaleY:1.] autorelease];
    CCRepeatForever* rForever = [[[CCRepeatForever alloc] initWithAction:[CCSequence actionOne:rScale1 two:rScale2]] autorelease];
    
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
    [self endBottleSound];
    [self.soundObjArray removeAllObjects];
    
    [self.waterOut1 stopSystem];
    [self.waterOut2 stopSystem];
    [self.leftFoot stopAllActions];
    [self.rightFoot stopAllActions];
}

- (void)waterHeightChange:(float)height
{
    //调整waterIn life
    CCParticleSystemQuad* waterIn = self.gameLayer.shakeSpray;
    
    float deltaHeight = waterIn.position.y - self.waterLayer.sprayLeft.position.y;
    float speedY = waterIn.speed * sin(ABS(waterIn.angle / 180.f * M_PI));
    
    float aY = ABS(waterIn.gravity.y);
    
    float time = (-speedY + sqrt(speedY * speedY + 4 * 1 / 2 * aY * deltaHeight)) / aY;
    time -= 0.1;
    self.waterInLeft.life = time;
    self.waterInRight.life = time;
    
}

- (void)worldSceneConfigure
{
    self.renewButton.visible = NO;
    [self.waterLayer worldSceneConfigure];
}

#pragma mark - Sound
- (void)beginBottleSound
{
    for (P4MonsterSoundObj* obj in self.soundObjArray)
    {
        [obj performSelector:@selector(beginSound) withObject:nil afterDelay:CCRANDOM_0_1() * 1.f];
//        [obj beginSound];
    }
}
- (void)endBottleSound
{
    for (P4MonsterSoundObj* obj in self.soundObjArray)
    {
        [obj endSound];
    }
}

#pragma mark - P4MonsterSoundObjDelegate
- (float)getMaxDelayTime
{
    float scale = self.waterLayer.averageWaterScale;   //0.2~1.f
    
    return 2 / scale;
}
- (void)soundWillPlay:(P4MonsterSoundObj*)obj delay:(float)delay
{
    float rate = (4 - delay) / 3 + 1;
    [self.waterLayer makeNewBubbleScaleRate:rate speedRate:rate * 1.2];
}
@end
