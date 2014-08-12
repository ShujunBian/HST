//
//  CircleTransitionLayer.m
//  HST
//
//  Created by wxy325 on 8/9/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CircleTransitionLayer.h"

#define CIRCLE_Z_ORDER 3

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
        [texture beginWithClear:0 g:0 b:0 a:1.f];
        
        
        glBlendFunc(GL_ZERO, GL_SRC_ALPHA);
        ccDrawColor4B(0, 0, 0, 0);
        ccDrawSolidCircle(ccp(self.circleMaxRadius, self.circleMaxRadius), self.circleMaxRadius , 720);
        [texture end];
        
        self.circleSprite = [CCSprite spriteWithTexture:texture.sprite.texture];
        self.circleSprite.anchorPoint = ccp(0.5f, 0.5f);
        self.circleSprite.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:self.circleSprite z:CIRCLE_Z_ORDER];
        
        
        CCRenderTexture* squareTexture = [CCRenderTexture renderTextureWithWidth:1 height:1];
        [squareTexture beginWithClear:0 g:0 b:0 a:1];
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
        //self.topSprite.visible = NO;
        //self.leftSprite.visible = NO;
        //self.rightSprite.visible = NO;
        //self.bottomSprite.visible = NO;
    }
    return self;
}


- (void)hideSceneWithDuration:(float)duration onCompletion:(VoidBlock)block
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.radiusSpeed = self.circleMaxRadius / duration;
    
    CCCallBlock* call = [CCCallBlock actionWithBlock:^{
//        self.leftSprite.scaleX = winSize.width;
        if (block) {
            block();
        }
    }];
    
    //circle
    self.circleSprite.scale = 1;
    [self.circleSprite runAction:[CCSequence actions:[CCScaleTo actionWithDuration:duration scale:0],[CCDelayTime actionWithDuration:0.05],call, nil]];
    
    //left
    self.leftSprite.scaleX = 0.f;
    float delayTime = ((self.circleMaxRadius - winSize.width / 2) / self.radiusSpeed);
    [self.leftSprite runAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:delayTime],
        [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:winSize.width / 2 scaleY:winSize.height],
        [CCScaleTo actionWithDuration:0 scale:winSize.width]]]];
    
    
    //right
    self.rightSprite.scaleX = 0.f;
    [self.rightSprite runAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.width / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:winSize.width / 2 scaleY:winSize.height]]]];
    
    //top
    self.topSprite.scaleY = 0;
    [self.topSprite runAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.height / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:winSize.height / 2],
        ]]];
    
    //bottom
    self.bottomSprite.scaleY = 0;
    [self.bottomSprite runAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.height / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:winSize.height / 2],
        ]]];
}

- (void)showSceneWithDuration:(float)duration onCompletion:(VoidBlock)block
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.radiusSpeed = self.circleMaxRadius / duration;

    CCCallBlock* call = [CCCallBlock actionWithBlock:^{
        if (block) {
            block();
        }
    }];
    //circle
    self.circleSprite.scale = 0;
    [self.circleSprite runAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:duration scale:1] two:call]];
    
    
    //left
    self.leftSprite.scaleX = winSize.width / 2;
    [self.leftSprite runAction: [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:0 scaleY:winSize.height]];
    
    //right
    self.rightSprite.scaleX = winSize.width / 2;
    [self.rightSprite runAction: [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:0 scaleY:winSize.height]];
    
    //top
    self.topSprite.scaleY = winSize.height / 2;
    [self.topSprite runAction:
     [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:0]];
    
    //bottom
    self.bottomSprite.scaleY = winSize.height / 2;
    [self.bottomSprite runAction:
     [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:0]];

}
@end
