//
//  CircleTransitionLayer.m
//  HST
//
//  Created by wxy325 on 8/9/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CircleTransitionLayer.h"

#define CIRCLE_Z_ORDER 3
static ccColor3B s_colorArray[5] = {
    {90, 198, 255},
    {242, 222, 88},
    {255, 130, 130},
    {9, 187, 68},
    {192, 83, 255}
};

ccColor3B s_color;

@interface CircleTransitionLayer ()

@property (assign, nonatomic) float circleMaxRadius;
@property (assign, nonatomic) float radiusSpeed;
@property (strong, nonatomic) CCSprite* circleSprite;

@property (strong, nonatomic) CCSprite* leftSprite;
@property (strong, nonatomic) CCSprite* rightSprite;
@property (strong, nonatomic) CCSprite* topSprite;
@property (strong, nonatomic) CCSprite* bottomSprite;

@end


@implementation CircleTransitionLayer

//static CircleTransitionLayer* s_circleTransitionLayer;

+ (CircleTransitionLayer*)layer
{
    CircleTransitionLayer* s_circleTransitionLayer = [[[CircleTransitionLayer alloc] init] autorelease];
    return  s_circleTransitionLayer;
}
- (void)onExit
{
    [super onExit];
    self.circleSprite = nil;
    self.leftSprite = nil;
    self.rightSprite = nil;
    self.topSprite = nil;
    self.bottomSprite = nil;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        
        
        self.circleSprite = nil;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.circleMaxRadius = sqrtf(winSize.width * winSize.width + winSize.height * winSize.height) / 2;
        
        CCRenderTexture* texture = [CCRenderTexture renderTextureWithWidth:self.circleMaxRadius * 2 height:self.circleMaxRadius * 2];
        [texture beginWithClear:1 g:1 b:1 a:1.f];
        
        
        glBlendFunc(GL_ZERO, GL_SRC_ALPHA);
        ccDrawColor4B(0, 0, 0, 0);
        ccDrawSolidCircle(ccp(self.circleMaxRadius, self.circleMaxRadius), self.circleMaxRadius , 720);
        [texture end];
        
        self.circleSprite = [CCSprite spriteWithTexture:texture.sprite.texture];
        self.circleSprite.anchorPoint = ccp(0.5f, 0.5f);
        self.circleSprite.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:self.circleSprite z:CIRCLE_Z_ORDER];
        
        
        CCRenderTexture* squareTexture = [CCRenderTexture renderTextureWithWidth:1 height:1];
        [squareTexture beginWithClear:1 g:1 b:1 a:1];
        [squareTexture end];
        self.leftSprite = [CCSprite spriteWithTexture:squareTexture.sprite.texture];
        self.rightSprite = [CCSprite spriteWithTexture:squareTexture.sprite.texture];
        self.topSprite = [CCSprite spriteWithTexture:squareTexture.sprite.texture];
        self.bottomSprite = [CCSprite spriteWithTexture:squareTexture.sprite.texture];
        
        //Left
        self.leftSprite.anchorPoint = ccp(0, 0);
        self.leftSprite.position = ccp(0,0);
        self.leftSprite.scaleX = 0.f;
        self.leftSprite.scaleY = winSize.height;
        [self addChild:self.leftSprite z:CIRCLE_Z_ORDER];

        //right
        self.rightSprite.anchorPoint = ccp(1, 0);
        self.rightSprite.position = ccp(winSize.width,0);
        self.rightSprite.scaleX = 0.f;
        self.rightSprite.scaleY = winSize.height;
        [self addChild:self.rightSprite z:CIRCLE_Z_ORDER];
        
        //Bottom
        self.bottomSprite.anchorPoint = ccp(0, 0);
        self.bottomSprite.position = ccp(0,0);
        self.bottomSprite.scaleX = winSize.width;
        self.bottomSprite.scaleY = 0;
        [self addChild:self.bottomSprite z:CIRCLE_Z_ORDER];
        
        //Top
        self.topSprite.anchorPoint = ccp(0, 1);
        self.topSprite.position = ccp(0,winSize.height);
        self.topSprite.scaleX = winSize.width;
        self.topSprite.scaleY = 0;
        [self addChild:self.topSprite z:CIRCLE_Z_ORDER];
        
    }
    return self;
}


- (void)hideSceneWithDuration:(float)duration onCompletion:(VoidBlock)block
{
    ccColor3B c = s_colorArray[time(NULL) % 5];
    s_color = c;
    self.circleSprite.color = c;
    self.leftSprite.color = c;
    self.rightSprite.color = c;
    self.topSprite.color = c;
    self.bottomSprite.color = c;

    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.radiusSpeed = self.circleMaxRadius / duration;
    
    CCCallBlock* call = [CCCallBlock actionWithBlock:^{
//        self.leftSprite.scaleX = winSize.width;
        if (block) {
            block();
        }
    }];
    
    float rate = 0.9f;
    //circle
    self.circleSprite.scale = 1;
    [self.circleSprite runAction:[CCSequence actions:[CCEaseOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:duration scale:0],[CCDelayTime actionWithDuration:0.01], nil] rate:rate],[CCDelayTime actionWithDuration:0.1], call, nil]];
    
    
    //left
    self.leftSprite.scaleX = 0.f;
    float delayTime = ((self.circleMaxRadius - winSize.width / 2) / self.radiusSpeed);
    [self.leftSprite runAction:[CCEaseOut actionWithAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:delayTime],
        [CCScaleTo actionWithDuration:(winSize.width / 2)/ self.radiusSpeed scaleX:(winSize.width / 2 + 1) scaleY:winSize.height],
        [CCScaleTo actionWithDuration:0 scale:winSize.width]]] rate:rate]];
    
    
    //right
    self.rightSprite.scaleX = 0.f;
    [self.rightSprite runAction:[CCEaseOut actionWithAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.width / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:(winSize.width / 2) / self.radiusSpeed scaleX:(winSize.width / 2 + 1) scaleY:winSize.height]]] rate:rate]];
    
    //top
    self.topSprite.scaleY = 0;
    [self.topSprite runAction:[CCEaseOut actionWithAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.height / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:(winSize.height / 2 + 1)],
        ]] rate:rate]];
    
    //bottom
    self.bottomSprite.scaleY = 0;
    [self.bottomSprite runAction:[CCEaseOut actionWithAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.height / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:(winSize.height / 2 + 1)],
        ]] rate:rate]];
}

- (void)showSceneWithDuration:(float)duration onCompletion:(VoidBlock)block
{
    ccColor3B c = s_color;
    self.circleSprite.color = c;
    self.leftSprite.color = c;
    self.rightSprite.color = c;
    self.topSprite.color = c;
    self.bottomSprite.color = c;

    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.radiusSpeed = self.circleMaxRadius / duration;

    CCCallBlock* call = [CCCallBlock actionWithBlock:^{
        if (block) {
            block();
        }
    }];
    
    float rate = .9f;
    //circle
    self.circleSprite.scale = 0;
    [self.circleSprite runAction:[CCEaseOut actionWithAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:duration scale:1] two:call] rate:rate]];
    
    
    //left
    self.leftSprite.scaleX = winSize.width / 2;
    float delayTime = ((self.circleMaxRadius - winSize.width / 2) / self.radiusSpeed);
    [self.leftSprite runAction:
     [CCEaseOut actionWithAction:
      [CCSequence actions:
       [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:0 scaleY:winSize.height],
       [CCDelayTime actionWithDuration:delayTime],
       nil]
       rate:rate]];
    
    //right
    self.rightSprite.scaleX = winSize.width / 2;
    [self.rightSprite runAction:
     [CCEaseOut actionWithAction:
      [CCSequence actions:
       [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:0 scaleY:winSize.height],
       [CCDelayTime actionWithDuration:delayTime],
       nil]
       rate:rate]];
    
    //top
    self.topSprite.scaleY = winSize.height / 2;
    [self.topSprite runAction:
     [CCEaseOut actionWithAction:
      [CCSequence actions:
       [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:0],
       [CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.height / 2) / self.radiusSpeed)], nil] rate:rate]];
    
    //bottom
    self.bottomSprite.scaleY = winSize.height / 2;
    [self.bottomSprite runAction:
     [CCEaseOut actionWithAction:
      [CCSequence actions:
       [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:0],
       [CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.height / 2) / self.radiusSpeed)], nil] rate:rate]];

}
@end
