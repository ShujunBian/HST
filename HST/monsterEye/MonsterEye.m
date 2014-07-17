//
//  MonsterEye.m
//  HST
//
//  Created by wxy325 on 7/16/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "MonsterEye.h"
#import "CCSprite+getRect.h"

#define BLINK_DURATION 0.15f
#define MOVE_DURATION 0.1f
#define MOVE_DELAY_DURATION 0.2f
#define MOVE_RATE 0.5f

@interface MonsterEye ()


@property (strong, nonatomic) CCSprite* eyeWhite; //眼眶
@property (strong, nonatomic) CCSprite* eyeBall;  //眼球
//眼皮
@property (strong, nonatomic) CCSprite* topEyelid;
@property (strong, nonatomic) CCSprite* bottomEyelid;

@property (assign, nonatomic) CGSize eyeWhiteSize;
@property (assign, nonatomic) float eyeBallRadius;

@end


@implementation MonsterEye
- (id)initWithEyeWhiteName:(NSString *)eyeWhiteName eyeballName:(NSString *)eyeballName eyelidColor:(ccColor3B)eyelidColor
{
    self = [super init];
    if (self)
    {
        //资源加载
        self.eyeWhite = [CCSprite spriteWithFile:eyeWhiteName];
        self.eyeBall = [CCSprite spriteWithFile:eyeballName];
        
        CGRect eyeWhiteRect = [self.eyeWhite getRect];
        self.eyeWhiteSize = eyeWhiteRect.size;
        self.eyeBallRadius= [self.eyeBall getRect].size.height / 2.f;
        
        self.eyeWhite.anchorPoint = ccp(0.5,0.5);
        self.eyeBall.anchorPoint = ccp(0.5,0.5);
        
        
        //眼皮
        CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:eyeWhiteRect.size.width height:eyeWhiteRect.size.height / 2.f + 1];
        [rt beginWithClear:1.f g:1.f b:1.f a:0.f];
        self.eyeWhite.position = ccp(eyeWhiteRect.size.width/2, 0);
        [self.eyeWhite visit];
        [rt end];
        CCSprite* top = [CCSprite spriteWithTexture:rt.sprite.texture];
        top.anchorPoint = ccp(0.5,0.5);
        top.position = ccp(0, 0);
        top.color = eyelidColor;
        top.flipY = YES;
        self.topEyelid = top;
        
        rt = [CCRenderTexture renderTextureWithWidth:eyeWhiteRect.size.width height:eyeWhiteRect.size.height / 2.f + 1];
        [rt beginWithClear:1.f g:1.f b:1.f a:0.f];
        self.eyeWhite.position = ccp(eyeWhiteRect.size.width/2, eyeWhiteRect.size.height / 2);
        [self.eyeWhite visit];
        [rt end];
        CCSprite* bottom = [CCSprite spriteWithTexture:rt.sprite.texture];
        bottom.anchorPoint = ccp(0.5,0.5);
        bottom.position = ccp(0, 0);
        bottom.color = eyelidColor;
        bottom.flipY = YES;
        self.bottomEyelid = bottom;
        
        
        //眼眶 眼球

        self.eyeWhite.position = ccp(0,0);
        self.eyeBall.position = ccp(0,0);

        [self addChild:self.eyeWhite];
        [self addChild:self.eyeBall];
        
        self.topEyelid.anchorPoint = ccp(0.5, 1);
        self.bottomEyelid.anchorPoint = ccp(0.5, 0);
        self.topEyelid.position = ccp(0, self.eyeWhiteSize.height / 2);
        self.bottomEyelid.position = ccp(0, -self.eyeWhiteSize.height / 2);
        [self addChild:self.topEyelid];
        [self addChild:self.bottomEyelid];
        self.topEyelid.visible = NO;
        self.bottomEyelid.visible = NO;
    }
    return self;
}

- (void)blink
{
    __weak MonsterEye* weakSelf = self;
    self.topEyelid.scale = 0.f;
    self.topEyelid.visible = YES;
    
    self.bottomEyelid.scale = 0.f;
    self.bottomEyelid.visible = YES;
    
    //Top
    NSArray* topActionArray =
  @[
    [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.42f scaleY:0.15f],
    [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.62f scaleY:0.30f],
    [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.8f scaleY:0.45f],
    [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:0.88f scaleY:0.60f],
    [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:1.f scaleY:0.85f],
    [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:1.f scaleY:1.f],
    [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:1.f scaleY:0.85f],
    [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:0.88f scaleY:0.60f],
    [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:0.8f scaleY:0.45f],
    [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.62f scaleY:0.30f],
    [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.42f scaleY:0.15f],
    [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.f scaleY:0.f],
    [CCCallBlock actionWithBlock:^{weakSelf.topEyelid.visible = NO;}]
    ];
    CCSequence* topSequence = [CCSequence actionWithArray:topActionArray];
    
    //Bottom
    NSArray* bottomActionArray =
    @[
      [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.42f scaleY:0.15f],
      [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.60f scaleY:0.30f],
      [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.8f scaleY:0.45f],
      [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:0.85f scaleY:0.60f],
      [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:0.97f scaleY:0.85f],
      [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:1.f scaleY:1.f],
      [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:0.97f scaleY:0.85f],
      [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:0.85f scaleY:0.60f],
      [CCScaleTo actionWithDuration:2.f/9.f * BLINK_DURATION scaleX:0.8f scaleY:0.45f],
      [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.60f scaleY:0.30f],
      [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.42f scaleY:0.15f],
      [CCScaleTo actionWithDuration:1.f/9.f * BLINK_DURATION scaleX:0.f scaleY:0.f],
      [CCCallBlock actionWithBlock:^{weakSelf.bottomEyelid.visible = NO;}]
      ];
    CCSequence* bottomSequence = [CCSequence actionWithArray:bottomActionArray];
    
    [self.topEyelid runAction:topSequence];
    [self.bottomEyelid runAction:bottomSequence];
}

- (void)eyeMoveAngle:(float)angle
{
    float whiteLength = MIN(self.eyeWhiteSize.height, self.eyeWhiteSize.width) / 2;
    float blackLength = self.eyeBallRadius;
    float moveLength = (whiteLength - blackLength) * MOVE_RATE;
    
    double radius = angle * M_PI / 180.f;
    float moveX = moveLength * cos(radius);
    float moveY = moveLength * sin(radius);
    
    CCMoveTo* moveTo = [CCMoveTo actionWithDuration:MOVE_DURATION position:ccp(moveX, moveY)];
    CCDelayTime* moveDelay = [CCDelayTime actionWithDuration:MOVE_DELAY_DURATION];
    CCMoveTo* moveBack = [CCMoveTo actionWithDuration:MOVE_DURATION position:ccp(0,0)];

    [self.eyeBall runAction:[CCSequence actions:moveTo, moveDelay, moveBack, nil]];
}
- (void)eyeMoveRandom
{
    [self eyeMoveAngle:CCRANDOM_0_1() * 360.f];
}
@end
