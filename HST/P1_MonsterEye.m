//
//  MonsterEye.m
//  town
//
//  Created by Song on 13-7-28.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P1_MonsterEye.h"

@implementation P1_MonsterEye

- (void) didLoadFromCCB
{
    mask = [CCSprite spriteWithFile:@"monster_eyelid_mask.png"];
    upperlid = [CCSprite spriteWithFile:@"monster_eye_upperlid.png"];
    lowerlid = [CCSprite spriteWithFile:@"monster_eye_lowerlid.png"];
    
    upperlid.flipY = YES;
    lowerlid.flipY = YES;
    mask.flipY = YES;
    
    //composite = [self maskedSpriteWithUpperY:0 lowerY:50];// eye close
    
    composite = [self maskedSpriteWithUpperY:-20 lowerY:80];// eye open
    composite.anchorPoint = self.eyeWhite.anchorPoint;
    composite.position = ccpAdd(self.eyeWhite.position, ccp(-2,4));
    
    //composite.position = ccp(50, 50);
    
    [self addChild:composite];
    
    
    mask.visible = NO;
    upperlid.visible = NO;
    lowerlid.visible = NO;
    [self addChild:mask];
    [self addChild:upperlid];
    [self addChild:lowerlid];
    
    [self scheduleUpdate];
    
}



- (CCSprite *)composedSpirteWithUpperY:(double)upperY lowerY:(double)lowerY
{
    upperlid.visible = YES;
    lowerlid.visible = YES;
    
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:mask.contentSize.width height:mask.contentSize.height];
    
    CCLayerColor *t = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 0)];
    
    // 2
    upperlid.position = ccp(upperlid.contentSize.width/2, upperY);
    lowerlid.position = ccp(lowerlid.contentSize.width/2, lowerY);
    
    
    // 3
    //[mask setBlendFunc:(ccBlendFunc){GL_ONE, GL_SRC_ALPHA}];
    [upperlid setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
    [lowerlid setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
    [t setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
    
    // 4
    [rt begin];
    [t visit];
    [upperlid visit];
    [lowerlid visit];
    [rt end];
    
    composite.texture = rt.sprite.texture;
    
    upperlid.visible = NO;
    lowerlid.visible = NO;
    
    // 5
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    return retval;
}


- (CCSprite *)maskedSpriteWithUpperY:(double)upperY lowerY:(double)lowerY
{
    mask.visible = YES;
    // 1
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:mask.contentSize.width height:mask.contentSize.height];
    
    CCSprite *composed = [self composedSpirteWithUpperY:upperY lowerY:lowerY];
    
    // 2
    mask.position = ccp(mask.contentSize.width/2, mask.contentSize.height/2);
    composed.position = ccp(composed.contentSize.width/2, composed.contentSize.height/2);
    composed.visible = YES;
    
    // 3
    [mask setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
    [composed setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ZERO}];
    
    // 4
    [rt begin];
    [mask visit];
    [composed visit];
    [rt end];
    
    mask.visible = NO;
    
    composite.texture = rt.sprite.texture;
    
    // 5
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    return retval;
}


-(void) update:(ccTime)delta
{
//    static ccTime t = 0;
//    t += delta;
//    if(t > 5 + arc4random() % 2)
//    {
//        [self blink];
//        t = 0;
//    }
}


-(void) updateBlink:(ccTime)delta
{
    totalBlinkTime += delta;
    ccTime totalTime = 0.25;
    
    if(totalBlinkTime > totalTime)
    {
        //composite.visible = NO;
        [self unschedule:@selector(updateBlink:)];
    }
    
    double upperPositionY = fabs(totalTime / 2 - totalBlinkTime) / totalTime * -35 + -20;//15->-20
    double lowerPositionY = fabs(totalTime / 2 - totalBlinkTime) / totalTime * 35 + 50;  //50-->80
    
    if(totalBlinkTime < totalTime / 2)
    {
        lowerPositionY = 80 - 30 * totalBlinkTime / (totalTime / 2);
        upperPositionY = -20 +35 * totalBlinkTime / (totalTime / 2);
    }
    else
    {
        lowerPositionY = 50 + 30 * (totalBlinkTime - totalTime / 2) / (totalTime / 2);
        upperPositionY = 15 - 35 * (totalBlinkTime - totalTime / 2) / (totalTime / 2);
    }
    
    //NSLog(@"l:%f u:%f",lowerPositionY,upperPositionY);
    
    [self maskedSpriteWithUpperY:upperPositionY lowerY:lowerPositionY];
}

- (void)blink
{
    totalBlinkTime = 0;
    [self schedule:@selector(updateBlink:)];
}


@end
