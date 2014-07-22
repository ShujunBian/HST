//
//  Monster.m
//  town
//
//  Created by Song on 13-7-28.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P1_Monster.h"
#import "CCBAnimationManager.h" 

@implementation P1_Monster

- (void) didLoadFromCCB
{
    maskedMouth = [CCSprite spriteWithFile:@"monster_mouth_mask.png"];
    mouthBlack = [CCSprite spriteWithFile:@"monster_mouth_mask.png"];
    //mouthSmall = [CCSprite spriteWithFile:@"monster_small_mouth_mask.png"];
    
    maskedMouth.anchorPoint = self.mouthMask.anchorPoint;
    maskedMouth.position = self.mouthMask.position;
    mouthBlack.anchorPoint = self.mouthMask.anchorPoint;
    mouthBlack.position = self.mouthMask.position;
    mouthSmall.anchorPoint = self.mouthMask.anchorPoint;
    mouthSmall.position = ccpAdd(self.mouthMask.position, ccp(0,-10)) ;
    [self addChild:mouthBlack];
    //[self addChild:mouthSmall];
    _mouthMask.visible = NO;
    mouthSmall.visible = NO;
    [self maskedSprite];
    [self addChild:maskedMouth];

    
//    [self schedule:@selector(updateLeftHand:)];
}


- (void)dealloc
{
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    static ccTime t = 0;
    static int count;
    t += delta;
    if(t > 2)
    {
        t = 0;
        count++;
        if(count % 2 == 0)
        {
            [self bigMouth];
        }
        else
        {
            [self smallMouth];
        }
    }
}

- (CCSprite *)maskedSprite
{
    // 1
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:_mouthMask.contentSize.width height:_mouthMask.contentSize.height];
    
    // 2
    _mouthMask.position = ccp(_mouthMask.contentSize.width/2, _mouthMask.contentSize.height/2);
    _teeth.position = ccp(_teeth.contentSize.width/2, _teeth.contentSize.height/2);
    _teeth.visible = YES;
    _mouthMask.visible = YES;
    _teeth.flipY = YES;
    _mouthMask.flipY = YES;
    
    // 3
    [_mouthMask setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
    [_teeth setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ZERO}];
    
    // 4
    [rt begin];
    [_mouthMask visit];
    [_teeth visit];
    [rt end];
    
    _teeth.visible = NO;
    _mouthMask.visible = NO;
    
    maskedMouth.texture = rt.sprite.texture;
    
    // 5
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    return retval;
}

-(void) updateSmallMouth:(ccTime)delta
{
    totalBlinkTime += delta;
    ccTime totalTime = 0.05;
    
    if(totalBlinkTime > totalTime)
    {
        [self unschedule:@selector(updateSmallMouth:)];
        
        maskedMouth.visible = NO;
        mouthBlack.visible = NO;
        mouthSmall.visible = YES;
        
        CCMoveBy *move = [CCMoveBy actionWithDuration:2 position:ccp(-20,0)];
        
        [mouthSmall runAction:move];
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"blow"];
        [self.delegate monsterMouthStartBlow:self];
        return;
    }

    _mouthMask.scale = 1 - 0.5 * (totalBlinkTime / totalTime);
    mouthBlack.scale = _mouthMask.scale;
    [self maskedSprite];
    
}

-(void) updateBigMouth:(ccTime)delta
{
    totalBlinkTime += delta;
    ccTime totalTime = 0.05;
    
    if(totalBlinkTime > totalTime)
    {
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"idle"];
        [self.delegate monsterMouthEndBlow:self];
        [self unschedule:@selector(updateBigMouth:)];
        return;
    }
    
    _mouthMask.scale = 0.7 + 0.3 * (totalBlinkTime / totalTime);
    mouthBlack.scale = _mouthMask.scale;
    [self maskedSprite];
}

- (void)smallMouth
{
    totalBlinkTime = 0;
    [self unschedule:@selector(updateBigMouth:)];
    [self schedule:@selector(updateSmallMouth:)];
}

- (void)bigMouth
{
    totalBlinkTime = 0;
    //_mouthMask = [CCSprite spriteWithFile:@"monster_mouth_mask.png"];
    mouthSmall.visible = NO;
    mouthBlack.visible = YES;
    maskedMouth.visible = YES;
    CCMoveBy *move = [CCMoveBy actionWithDuration:0 position:ccp(20,0)];
    [mouthSmall runAction:move];
    
    [self unschedule:@selector(updateSmallMouth:)];
    [self schedule:@selector(updateBigMouth:)];
}





- (void)updateLeftHand:(ccTime)delta
{
#warning 解决性能问题
//    static double time = 0;
//    time += delta;
//    if(time > 0.01)
//    {
//        time = 0;
//        [leftHandReal removeFromParentAndCleanup:YES];
//        leftHandReal = [self maskedLeftHand];
//        leftHandReal.position = self.body.position;
//        [self addChild:leftHandReal];
//    }
}


- (CCSprite*)maskedLeftHandPrivate
{
    // 1
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:_body.contentSize.width  height:_body.contentSize.height];
    
    CCLayerColor *bodyButtom = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 0)];
    
    self.lefthand.visible = YES;
    CCSprite *lefthand = [CCSprite spriteWithTexture:self.lefthand.texture];
    
    lefthand.position = self.lefthand.position;
    lefthand.rotation = self.lefthand.rotation;
    lefthand.anchorPoint = self.lefthand.anchorPoint;
    // 3
    [lefthand setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
    [bodyButtom setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
    
    // 4
    [rt begin];
    [bodyButtom visit];
    [lefthand visit];
    [rt end];
    
    _lefthand.visible = NO;
    
    // 5
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    retval.flipY  = YES;
    return retval;
}


- (CCSprite*)maskedLeftHand
{
    // 1
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:_body.contentSize.width  height:_body.contentSize.height];
    
    CCSprite *bodyMask = [CCSprite spriteWithTexture:self.body.texture];
    
    CCSprite *hand = [self maskedLeftHandPrivate];
    
    hand.position = ccp(0,0);
    hand.anchorPoint = ccp(0,0);
    bodyMask.position = ccp(bodyMask.contentSize.width/2, bodyMask.contentSize.height/2);
    //_lefthand.position = ccp(_lefthand.contentSize.width/2, _lefthand.contentSize.height/2);
    
    // 3
    [bodyMask setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
    [hand setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ZERO}];
    
    // 4
    [rt begin];
    [bodyMask visit];
    [hand visit];
    [rt end];

    _lefthand.visible = NO;
    
    // 5
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    retval.flipY  = YES;
    return retval;
}

@end
