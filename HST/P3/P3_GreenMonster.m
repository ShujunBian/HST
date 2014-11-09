//
//  greenMonster.m
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P3_GreenMonster.h"
#import "P3_MonsterEye.h"

@interface P3_GreenMonster ()

@property (strong, nonatomic) CCSprite* circleMask;
@property (strong, nonatomic) CCSprite* maskedMouth;
@property (assign, nonatomic) CGPoint mouthPos;
@property (assign, nonatomic) float mouthRadio;

@property (strong, nonatomic) NSDate* initDate;
@property (assign, nonatomic) BOOL fShouldUpdate;
@end

@implementation P3_GreenMonster

- (id)init
{
    if (self = [super init]) {
        self.fShouldUpdate = YES;
    }
    return self;
}

- (void)createMonsterWithType:(MonsterType)monsterType
{
    [super createMonsterWithType:monsterType];
    
    for (int i = 0; i < monsterEyeCounters[monsterType]; ++ i) {
        [self.monsterEye.monsterEyePositions addObject:
         [NSValue valueWithCGPoint:monsterGreenEyePos[i]]];
    }
}

- (void)initMonsterEyes
{
    self.initDate = [NSDate date];
    [self initCircleMask];
    self.mouthPos = self.monsterMouth.position;
    self.mouthRadio = 1.f;
    if (self.fShouldUpdate) {
        [self.monsterMouth removeFromParentAndCleanup:YES];
        [self schedule:@selector(mouthUpdate) interval:1.f/30];
    }

    [super initMonsterEyes];
}
- (void)initCircleMask
{
    float radius = 80;
    CCRenderTexture* texture = [CCRenderTexture renderTextureWithWidth:radius * 2 height:radius * 2];
    [texture beginWithClear:0 g:0 b:0 a:0.f];
//    glBlendFunc(GL_ZERO, GL_SRC_ALPHA);
    ccDrawColor4B(84, 249, 46, 255);
    ccDrawSolidCircle(ccp(radius, radius), radius , 720 * 2);
    [texture end];
    
    CCSprite* circleSprite = [CCSprite spriteWithTexture:texture.sprite.texture];
    circleSprite.anchorPoint = ccp(0.5f, 0.5f);
    circleSprite.position = self.monsterMouth.position;
//    [self addChild:circleSprite];
    self.circleMask = circleSprite;
}

- (CCSprite *)generateMaskSpriteMouth
{
    
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:self.circleMask.texture.contentSize.width height:self.circleMask.texture.contentSize.height];
    self.monsterMouth.position = ccp(80,80);
    self.monsterMouth.anchorPoint = ccp(0.5, 0.5);
    self.circleMask.position = ccp(80,80);
    self.circleMask.scale = self.mouthRadio;
    
    [rt beginWithClear:1 g:0 b:0 a:0];
    [self.circleMask setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
    [self.circleMask visit];
    
    [self.monsterMouth setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ZERO}];
    [self.monsterMouth visit];
    
    [rt end];
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    retval.flipY = YES;
    return retval;
}
- (void)mouthUpdate
{
    NSDate* date = [NSDate date];
    NSTimeInterval deltaTime = [date timeIntervalSinceDate:self.initDate];
    deltaTime = deltaTime - (int)deltaTime;
    if (deltaTime < 0.1f) {
        self.mouthRadio = deltaTime * 10;
    } else if (deltaTime > 0.9f) {
        self.mouthRadio = (1 - deltaTime) * 10;
    } else {
        self.mouthRadio = 1;
    }
    
    
    if (self.maskedMouth) {
        [self.maskedMouth removeFromParentAndCleanup:YES];
        self.maskedMouth = nil;
    }

    
    CCSprite* s = [self generateMaskSpriteMouth];
    s.position = self.mouthPos;
    [self addChild:s z:4];
    self.maskedMouth = s;
}
- (void)mainMapInit
{
    [self unschedule:@selector(mouthUpdate)];
    self.fShouldUpdate = NO;
//    self.mouthRadio = 1.f;
//    [self mouthUpdate];
}
@end
