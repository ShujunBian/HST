//
//  P4Monster.m
//  hst_p4
//
//  Created by wxy325 on 1/18/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "P4Monster.h"
#import "CCSprite+getRect.h"
#import "cocos2d.h"

#define WATER_DECREASE_SPEED 0.01f

@interface P4Monster ()

@property (assign, nonatomic) CGPoint maskPosition;
@property (assign, nonatomic) int maskIndex;
@property (strong, nonatomic) CCSprite* waterSprite;

- (void)updateWaterSprite;

@property (assign, nonatomic) float waterPercentageTo;

@property (assign, nonatomic) BOOL isPercentageChange;
@end

@implementation P4Monster

@synthesize eye1 = _eye1;
@synthesize eye2 = _eye2;
@synthesize mask = _mask;
@dynamic isEmpty;

- (BOOL)isEmpty
{
    return self.waterPercentage < 0.1f;
}

- (void) didLoadFromCCB
{
    for (CCNode* c in self.children)
    {
        [self reorderChild:c z:c.tag];
    }

    self.maskPosition = self.mask.position;
    self.maskIndex = self.mask.zOrder;
    [self.mask retain];
    [self.mask removeFromParent];
    self.waterPercentage = 1.f;
    self.waterPercentageTo = self.waterPercentage;
    self.isPercentageChange = NO;
//    self.rotation = 100.f;
}
- (void)onEnter
{
    [super onEnter];
    [self updateWaterSprite];
}
- (void)prePositionInit
{
    self.prePosition = self.position;
}

- (CGRect)getRect
{
    CGPoint location = self.position;
    CGPoint anchorPoint = self.body.anchorPoint;
    CGSize size = self.body.texture.contentSize;
    CGFloat left = location.x - anchorPoint.x * size.width;
    CGFloat top = location.y - anchorPoint.y * size.height;
    return CGRectMake(left, top, size.width, size.height);
}

#pragma mark - Update Water
- (void)beginUpdateWater
{
    [self schedule:@selector(updateWaterSprite)];
}
- (void)endUpdateWater
{
    [self unschedule:@selector(updateWaterSprite)];
}

- (void)updateWaterSprite
{
    if (self.waterSprite)
    {
        [self.waterSprite removeFromParentAndCleanup:YES];
        self.waterSprite = nil;
    }
    self.waterSprite = [self makeWaterSprite];
    self.waterSprite.position = self.maskPosition;
    self.waterSprite.color = self.waterColor;
    self.waterSprite.rotation = -self.rotation;
    [self addChild:self.waterSprite z:self.maskIndex];

}
- (CCSprite *)makeWaterSprite
{
    CCSprite* maskSprite = self.mask;
    float spriteWidth = maskSprite.texture.contentSize.width;
    float spriteHeight = maskSprite.texture.contentSize.height;

    float radius = 0;
    if (self.rotation < 90)
    {
        radius = self.rotation * M_PI / 180.f;
    }
    else
    {
        radius = (self.rotation - 90) * M_PI / 180.f;
    }

    float width = spriteWidth * cos(radius) + spriteHeight * sin(radius);
    float height = spriteWidth * sin(radius) + spriteHeight * cos(radius);
    
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:width height:height];
    
    maskSprite.anchorPoint = ccp(0.5,0.5);
    maskSprite.position = ccp(width/2,height/2);
//    if (self.rotation < 90)
//    {
//        maskSprite.position = ccp(0,spriteWidth * sin(radius));
//    }
//    else
//    {
//        maskSprite.position = ccp(spriteWidth * sin(radius), height);
//    }

    maskSprite.rotation = self.rotation;
    
    [maskSprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
    
    [rt begin];
    [maskSprite visit];
    
    float percentage = 0;
    percentage = self.waterPercentage * 0.9f;
    
    ccDrawSolidRect(ccp( 0, height * percentage), ccp(width, height), ccc4f(0, 0, 0, 0));

    [rt end];
    
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    retval.flipY = YES;
    return retval;
    
}

#pragma mark - Water Change
- (void)startWaterDecrease
{
    if (!self.isPercentageChange)
    {
        self.isPercentageChange = YES;
        if (self.waterPercentageTo > 0.9f)
        {
            self.waterPercentageTo = 2 / 3.f;
        }
        else if (self.waterPercentageTo > 0.4)
        {
            self.waterPercentageTo = 1 / 3.f;
        }
        else
        {
            self.waterPercentageTo = 0.001f;
        }
        //    [self beginUpdateWater];
        [self schedule:@selector(waterDecreaseUpdate:)];
    }
    
}
- (void)waterDecreaseUpdate:(float)dt
{
    self.waterPercentage -= WATER_DECREASE_SPEED;
    if (self.waterPercentage <= self.waterPercentageTo)
    {
        self.waterPercentageTo = self.waterPercentageTo;
        [self unschedule:@selector(waterDecreaseUpdate:)];
        self.isPercentageChange = NO;
    }

}
- (void)startWaterFull
{
    if (!self.isPercentageChange)
    {
        self.waterPercentageTo = 1.f;
        [self beginUpdateWater];
        [self schedule:@selector(waterFullUpdate:)];
        self.isPercentageChange = YES;
    }

}
- (void)waterFullUpdate:(float)dt
{
    self.waterPercentage += 2 * WATER_DECREASE_SPEED;
    if (self.waterPercentage >= 1.f)
    {
        self.waterPercentage = 1.f;
        [self endUpdateWater];
        [self unschedule:@selector(waterFullUpdate:)];
        self.isPercentageChange = NO;
    }
    
}
@end
