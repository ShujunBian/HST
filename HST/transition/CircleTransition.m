//
//  CircleTransition.m
//  HST
//
//  Created by wxy325 on 7/22/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CircleTransition.h"

//#define CIRCLE_DRAW_RADIU 50.f
//#define CIRCLE_MIN_RADIU 50.f

#define IN_TEXTURE_Z_ORDER 1
#define OUT_TEXTURE_Z_ORDER 2
#define CIRCLE_Z_ORDER 3


@interface CircleTransition ()

@property (assign, nonatomic) float circleMaxRadius;
@property (assign, nonatomic) float radiusSpeed;
@property (strong, nonatomic) CCSprite* circleSprite;

@property (strong, nonatomic) CCRenderTexture* inTexture;
@property (strong, nonatomic) CCRenderTexture* outTexture;

@property (strong, nonatomic) CCLayer* colorLayer;

@end

@implementation CircleTransition
- (void)draw
{

}
#pragma mark - Init
- (id)initWithDuration:(ccTime)t scene:(CCScene *)s
{
    self = [super initWithDuration:t scene:s];
    if (self)
    {
        
    }
    return self;
}
+ (id)transitionWithDuration:(ccTime)t scene:(CCScene *)s
{
    return [[[self alloc] initWithDuration:t scene:s] autorelease];
}

#pragma mark - Life Cycle

- (void)onEnter
{
    [super onEnter];
    
    self.colorLayer = [CCLayerColor layerWithColor:ccc4(0,0,0,0)];
    [self addChild:self.colorLayer];
    
    self.circleSprite = nil;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.circleMaxRadius = sqrtf(winSize.width * winSize.width + winSize.height * winSize.height) / 2;
    self.radiusSpeed = self.circleMaxRadius * 2 / _duration;
    
    // create the first render texture for _inScene
	CCRenderTexture *inTexture = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
	inTexture.sprite.anchorPoint= ccp(0.5f,0.5f);
	inTexture.position = ccp(winSize.width/2, winSize.height/2);
	inTexture.anchorPoint = ccp(0.5f,0.5f);
    
	// render _inScene to its texturebuffer
	[inTexture begin];
	[_inScene visit];
	[inTexture end];
    
	// create the second render texture for _outScene
	CCRenderTexture *outTexture = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
	outTexture.sprite.anchorPoint= ccp(0.5f,0.5f);
	outTexture.position = ccp(winSize.width/2, winSize.height/2);
	outTexture.anchorPoint = ccp(0.5f,0.5f);
    
	// render _outScene to its texturebuffer
	[outTexture begin];
	[_outScene visit];
	[outTexture end];
    self.outTexture = outTexture;
    self.inTexture = inTexture;
    
	// add render textures to the layer
//	[self addChild:outTexture];
	[self.colorLayer addChild:self.outTexture z:IN_TEXTURE_Z_ORDER];
    

//    float width = winSize.width * CIRCLE_DRAW_RADIU / CIRCLE_MIN_RADIU;
//    float height = winSize.height * CIRCLE_DRAW_RADIU / CIRCLE_MIN_RADIU;
    CCRenderTexture* texture = [CCRenderTexture renderTextureWithWidth:self.circleMaxRadius * 2 height:self.circleMaxRadius * 2];
    //    texture.anchorPoint = ccp(0.5, 0.5);
    //    texture.position = ccp(self.winSize.width / 2, self.winSize.height / 2);
    [texture beginWithClear:0 g:0 b:0 a:1.f];
    
    glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_ALPHA);
    ccDrawColor4B(0, 0, 0, 255);
    ccDrawSolidCircle(ccp(self.circleMaxRadius, self.circleMaxRadius), self.circleMaxRadius , 720);
    [texture end];
    
    self.circleSprite = [CCSprite spriteWithTexture:texture.sprite.texture];
    self.circleSprite.anchorPoint = ccp(0.5f, 0.5f);
    self.circleSprite.position = ccp(winSize.width / 2, winSize.height / 2);
    [self.colorLayer addChild:self.circleSprite z:CIRCLE_Z_ORDER];

    
//    [self.circleSprite runAction:[CCScaleTo actionWithDuration:1.f scale:self.circleMaxRadius / 50.f]];
    //圆形动画
    [self.circleSprite runAction:
     [CCSequence actionWithArray:
      @[
        [CCScaleTo actionWithDuration:_duration / 2 scale:0],
        [CCCallFunc actionWithTarget:self selector:@selector(changeScene)],
        [CCScaleTo actionWithDuration:_duration / 2 scale:1],
        [CCCallFunc actionWithTarget:self selector:@selector(hideOutShowIn)],
        [CCCallFunc actionWithTarget:self selector:@selector(finish)]
        ]]];
    
    CCRenderTexture* squareTexture = [CCRenderTexture renderTextureWithWidth:1 height:1];
    [squareTexture beginWithClear:0 g:0 b:0 a:1];
    [squareTexture end];
    CCSprite* leftSprite = [CCSprite spriteWithTexture:squareTexture.sprite.texture];
    CCSprite* rightSprite = [CCSprite spriteWithTexture:squareTexture.sprite.texture];
    CCSprite* topSprite = [CCSprite spriteWithTexture:squareTexture.sprite.texture];
    CCSprite* bottomSprite = [CCSprite spriteWithTexture:squareTexture.sprite.texture];
    
    //Left
    leftSprite.anchorPoint = ccp(0, 0);
    leftSprite.position = ccp(0,0);
    leftSprite.scaleX = 0.f;
    leftSprite.scaleY = winSize.height;
    [self.colorLayer addChild:leftSprite z:CIRCLE_Z_ORDER];
    [leftSprite runAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.width / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:winSize.width / 2 scaleY:winSize.height],
        [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:0 scaleY:winSize.height]
        ]]];
    
    //right
    rightSprite.anchorPoint = ccp(1, 0);
    rightSprite.position = ccp(winSize.width,0);
    rightSprite.scaleX = 0.f;
    rightSprite.scaleY = winSize.height;
    [self.colorLayer addChild:rightSprite z:CIRCLE_Z_ORDER];
    [rightSprite runAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.width / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:winSize.width / 2 scaleY:winSize.height],
        [CCScaleTo actionWithDuration:winSize.width / 2 / self.radiusSpeed scaleX:0 scaleY:winSize.height]
        ]]];
    
    //Bottom
    bottomSprite.anchorPoint = ccp(0, 0);
    bottomSprite.position = ccp(0,0);
    bottomSprite.scaleX = winSize.width;
    bottomSprite.scaleY = 0;
    [self.colorLayer addChild:bottomSprite z:CIRCLE_Z_ORDER];
    [bottomSprite runAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.height / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:winSize.height / 2],
        [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:0]
        ]]];
    
    //Top
    topSprite.anchorPoint = ccp(0, 1);
    topSprite.position = ccp(0,winSize.height);
    topSprite.scaleX = winSize.width;
    topSprite.scaleY = 0;
    [self.colorLayer addChild:topSprite z:CIRCLE_Z_ORDER];
    [topSprite runAction:
     [CCSequence actionWithArray:
      @[[CCDelayTime actionWithDuration:((self.circleMaxRadius - winSize.height / 2) / self.radiusSpeed)],
        [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:winSize.height / 2],
        [CCScaleTo actionWithDuration:winSize.height / 2 / self.radiusSpeed scaleX:winSize.width scaleY:0]
        ]]];
    
}
- (void)onExit
{
    [self.colorLayer removeAllChildrenWithCleanup:YES];
    [self removeAllChildrenWithCleanup:YES];
    self.inTexture = nil;
    self.outTexture = nil;
    self.circleSprite = nil;
    self.colorLayer = nil;
    [super onExit];
}

- (void)changeScene
{
    [self.outTexture removeFromParentAndCleanup:YES];
    [self.colorLayer addChild:self.inTexture z:OUT_TEXTURE_Z_ORDER];
}

@end
