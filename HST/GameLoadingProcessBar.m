//
//  GameLoadingProcessBar.m
//  HST
//
//  Created by wxy325 on 8/5/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "GameLoadingProcessBar.h"

#define BAR_BACKGROUND_COLOR ccc3(127, 219, 67)
#define BAR_COLOR ccc3(219, 255, 195)


#define BAR_HEIGHT 25
#define BAR_WIDTH 163
#define BAR_BASE_X (-(BAR_WIDTH - BAR_HEIGHT) / 2)
#define BAR_RECT_WIDTH (BAR_WIDTH - BAR_HEIGHT)
@interface GameLoadingProcessBar ()

@property (strong, nonatomic) CCSprite* barLeftCircle;
@property (strong, nonatomic) CCSprite* barRightCircle;
@property (strong, nonatomic) CCSprite* barRect;

@end

@implementation GameLoadingProcessBar

- (id)init
{
    self = [super init];
    if (self)
    {
        CCRenderTexture* texture = [CCRenderTexture renderTextureWithWidth:BAR_WIDTH height:BAR_HEIGHT];
        texture.anchorPoint = ccp(0,0);

        //Background
        [texture beginWithClear:1 g:1 b:1 a:0.f];
        ccDrawSolidCircle(ccp(BAR_HEIGHT / 2, BAR_HEIGHT / 2), BAR_HEIGHT / 2, 720);
        
        ccDrawSolidCircle(ccp(BAR_WIDTH - BAR_HEIGHT / 2, BAR_HEIGHT / 2), BAR_HEIGHT / 2, 720);
        ccDrawSolidRect(ccp(BAR_HEIGHT / 2, 0), ccp(BAR_WIDTH - BAR_HEIGHT / 2, BAR_HEIGHT - 1), ccc4f(1, 1, 1, 1));
        [texture end];
        CCSprite* backgroundSprite = [CCSprite spriteWithTexture:texture.sprite.texture];
        backgroundSprite.position = ccp(0, 0);
        backgroundSprite.anchorPoint = ccp(0.5,0.5);
        backgroundSprite.color = BAR_BACKGROUND_COLOR;
        [self addChild:backgroundSprite];
        
        
        texture = [CCRenderTexture renderTextureWithWidth:BAR_HEIGHT / 2 height:BAR_HEIGHT];
        texture.anchorPoint = ccp(0,0);
        [texture beginWithClear:1 g:1 b:1 a:0.f];
        ccDrawSolidCircle(ccp(BAR_HEIGHT / 2, BAR_HEIGHT / 2), BAR_HEIGHT / 2, 7200);
        [texture end];
        self.barLeftCircle = [CCSprite spriteWithTexture:texture.sprite.texture];
        self.barLeftCircle.color = BAR_COLOR;
        self.barLeftCircle.anchorPoint = ccp(1, 0.5);
        
        texture = [CCRenderTexture renderTextureWithWidth:BAR_HEIGHT / 2 height:BAR_HEIGHT];
        texture.anchorPoint = ccp(0,0);
        [texture beginWithClear:1 g:1 b:1 a:0.f];
        ccDrawSolidCircle(ccp(0, BAR_HEIGHT / 2), BAR_HEIGHT / 2, 7200);
        [texture end];
        self.barRightCircle = [CCSprite spriteWithTexture:texture.sprite.texture];
        self.barRightCircle.color = BAR_COLOR;
        self.barRightCircle.anchorPoint = ccp(0, 0.5);
        
        texture = [CCRenderTexture renderTextureWithWidth:1 height:BAR_HEIGHT];
        texture.anchorPoint = ccp(0,0);
        [texture beginWithClear:1 g:1 b:1 a:0.f];
        ccDrawSolidRect(ccp(0, 0), ccp(1, BAR_HEIGHT - 1), ccc4f(1, 1, 1, 1));
        [texture end];
        self.barRect = [CCSprite spriteWithTexture:texture.sprite.texture];
        self.barRect.color = BAR_COLOR;
        self.barRect.anchorPoint = ccp(0, 0.5);
        
        self.barLeftCircle.position = ccp(BAR_BASE_X,0);
        self.barRightCircle.position = ccp(BAR_BASE_X,0);
        self.barRect.position = ccp(BAR_BASE_X, 0);
//        self.barRect.scaleX = 30;
        [self addChild:self.barLeftCircle];
        [self addChild:self.barRightCircle];
        [self addChild:self.barRect];
        self.percentage = 0.5f;
    }
    return self;
}

- (void)setPercentage:(float)percentage
{
    percentage = percentage < 0.f? 0.f : percentage;
    percentage = percentage > 1.f? 1.f : percentage;
    
    _percentage = percentage;
    
    float width = BAR_RECT_WIDTH * percentage;
    self.barRightCircle.position = ccp(BAR_BASE_X + width, 0);
    self.barRect.scaleX = width;
}

@end
