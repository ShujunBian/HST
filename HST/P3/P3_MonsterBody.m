//
//  P3_MonsterBody.m
//  HST
//
//  Created by Emerson on 14-7-17.
//  Copyright 2014年 Emerson. All rights reserved.
//

#import "P3_MonsterBody.h"
#import "cocos2d.h"

#define ARC4RANDOM_MAX 0x100000000
#define kBlinkTexture @"blinkTexture"
#define kNormalTexture @"normaltexture"
@implementation P3_MonsterBody
{
    int timeCounter;
    CCTexture2D * blinkTexture;
    CCTexture2D * normaltexture;
}
@synthesize body;

- (id)init
{
    if (self = [super init]) {
        timeCounter = 0;
//        UIImage * image = [[UIImage imageNamed:@"P3_MonsterBodyEye_Blink.png"]autorelease];
//        [[CCTextureCache sharedTextureCache]addCGImage:image.CGImage forKey:kBlinkTexture];
//        
//        UIImage * imageChoosen = [[UIImage imageNamed:@"P3_MonsterBodyEye.png"]autorelease];
//        [[CCTextureCache sharedTextureCache]addCGImage:imageChoosen.CGImage forKey:kNormalTexture];
//        
//        
//        blinkTexture = [[CCTextureCache sharedTextureCache]textureForKey:kBlinkTexture];
//        normaltexture = [[CCTextureCache sharedTextureCache]textureForKey:kNormalTexture];
        
//        [self schedule:@selector(monsterEyeMovingUpdate) interval:3.0 repeat:YES delay:0.0];
//        [self schedule:@selector(monsterEyeBlinkUpdate) interval:2.0 repeat:YES delay:1.0 * CCRANDOM_0_1()];
        [self scheduleUpdate];
    }
    return self;
}

- (void)initMonsterBodyEyesAndMouth
{
    _leftEye = [CCSprite spriteWithFile:@"P3_MonsterBodyEye.png"];
    _rightEye = [CCSprite spriteWithFile:@"P3_MonsterBodyEye.png"];
    _mouth = [CCSprite spriteWithFile:@"P3_Monster_body_mouth.png"];

//    [_leftEye setTexture:blinkTexture];
    
    CGPoint centerPosition = CGPointMake(self.contentSize.width / 2.0, self.contentSize.height / 2.0);
    [_leftEye setPosition:CGPointMake(centerPosition.x - (15.0 + 10.0 * CCRANDOM_0_1()), centerPosition.y)];
    [_rightEye setPosition:CGPointMake(centerPosition.x + (15.0 + 10.0 * CCRANDOM_0_1()), centerPosition.y)];
    
    float randomScaleRate;

    if (self.monsterType == PurpMonster ||
        self.monsterType == CeruleanMonster) {
        randomScaleRate = 0.6 + 0.3 * CCRANDOM_0_1();
    }
    else {
        randomScaleRate = 0.8 + 0.3 * CCRANDOM_0_1();
    }
    
    [_mouth setScale:randomScaleRate];
    [_mouth setPosition:CGPointMake(centerPosition.x, self.contentSize.height / 2.0 - 20.0 - 5.0 * CCRANDOM_0_1())];
    
    [self addChild:_leftEye];
    [self addChild:_rightEye];
    [self addChild:_mouth];
    [self startMouthAnimation];
}

- (void)update:(ccTime)delta
{
    ++ timeCounter;
    if (timeCounter > 120) {
        [self monsterEyeBlinkUpdate];
        timeCounter = 0;
    }
}

- (void)monsterEyeMovingUpdate
{
    [self performSelector:@selector(monsterEyeMovingAnimation) withObject:self afterDelay:3.0 * CCRANDOM_0_1()];
}

- (void)monsterEyeMovingAnimation
{
    NSLog(@"%f",CCRANDOM_0_1());
    if (CCRANDOM_0_1() > 0.5) {
        float yDistance;
        float xDistance;
        if (CCRANDOM_0_1() > 0.5) {
            yDistance = 5.0 * CCRANDOM_0_1();
            xDistance = 5.0 + 3.0 * CCRANDOM_0_1();
        }
        else {
            yDistance = - 5.0 * CCRANDOM_0_1();
            xDistance = - 5.0 - 3.0 * CCRANDOM_0_1();
        }
        
        CCMoveBy * moveLeft = [CCMoveBy actionWithDuration:0.5 position:CGPointMake(-xDistance, -yDistance)];
        CCMoveBy * moveRight = [CCMoveBy actionWithDuration:0.5 position:CGPointMake(xDistance, yDistance)];
        CCSequence * seq = [CCSequence actions:moveLeft, moveRight, nil];
        [_leftEye runAction:seq];
        
        CCMoveBy * moveLeft2 = [CCMoveBy actionWithDuration:0.5 position:CGPointMake(-xDistance, -yDistance)];
        CCMoveBy * moveRight2 = [CCMoveBy actionWithDuration:0.5 position:CGPointMake(xDistance, yDistance)];
        CCSequence * seq2 = [CCSequence actions:moveLeft2, moveRight2, nil];
        [_rightEye runAction:seq2];
        
    }
}

- (void)monsterEyeBlinkUpdate
{
    if (CCRANDOM_0_1() > 0.5) {
        float timeDistance = 1.0 * CCRANDOM_0_1();
        [self performSelector:@selector(monsterEyeBlinkAnimation) withObject:self afterDelay:timeDistance];
        [self performSelector:@selector(monsterEyeBlinkBackAnimation) withObject:self afterDelay:timeDistance + 0.2];
    }
    else {
        float timeDistance = 1.0 * CCRANDOM_0_1();
        [self performSelector:@selector(monsterEyeBlinkAnimation) withObject:self afterDelay:timeDistance];
        [self performSelector:@selector(monsterEyeBlinkBackAnimation) withObject:self afterDelay:timeDistance + 0.2];
        [self performSelector:@selector(monsterEyeBlinkAnimation) withObject:self afterDelay:timeDistance + 0.4];
        [self performSelector:@selector(monsterEyeBlinkBackAnimation) withObject:self afterDelay:timeDistance + 0.6];
    }
}

- (void)monsterEyeBlinkAnimation
{
    CGPoint leftPoint = _leftEye.position;
    CGPoint rightPoint = _rightEye.position;
    
    [_leftEye removeFromParentAndCleanup:YES];
    [_rightEye removeFromParentAndCleanup:YES];
    
    _leftEye = [CCSprite spriteWithFile:@"P3_MonsterBodyEye_Blink.png"];
    _leftEye.position = leftPoint;
    [self addChild:_leftEye];
    
    _rightEye = [CCSprite spriteWithFile:@"P3_MonsterBodyEye_Blink.png"];
    _rightEye.position = rightPoint;
    [self addChild:_rightEye];
    
//    [_leftEye setTexture:blinkTexture];
//    [_rightEye setTexture:blinkTexture];
    
}

- (void)monsterEyeBlinkBackAnimation
{
    CGPoint leftPoint = _leftEye.position;
    CGPoint rightPoint = _rightEye.position;
    
    [_leftEye removeFromParentAndCleanup:YES];
    [_rightEye removeFromParentAndCleanup:YES];
    
    _leftEye = [CCSprite spriteWithFile:@"P3_MonsterBodyEye.png"];
    _leftEye.position = leftPoint;
    [self addChild:_leftEye];
    
    _rightEye = [CCSprite spriteWithFile:@"P3_MonsterBodyEye.png"];
    _rightEye.position = rightPoint;
    [self addChild:_rightEye];
    
//    [_leftEye setTexture:normaltexture];
//    [_rightEye setTexture:normaltexture];
}

- (void)startMouthAnimation
{
    CCRepeatForever* mouthAction = [CCRepeatForever actionWithAction:[CCSequence actionWithArray:@[[CCScaleTo actionWithDuration:0.2 scaleX:1 scaleY:0], [CCScaleTo actionWithDuration:0.2 scaleX:1 scaleY:1], [CCDelayTime actionWithDuration:0.4]]]];
    [self.mouth runAction:mouthAction];
}
- (void)stopMouthAnimation
{
    [self.mouth stopAllActions];
}
@end
