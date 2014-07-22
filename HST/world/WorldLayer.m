//
//  WorldLayer.m
//  HST
//
//  Created by wxy325 on 7/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WorldLayer.h"

@interface WorldLayer ()
//@property (assign, nonatomic) float currentRadius;
//@property (strong, nonatomic) CCRenderTexture* renderTexture;
@property (assign, nonatomic) CGSize winSize;
@end

@implementation WorldLayer

- (void)onEnter
{
    [super onEnter];
//    self.winSize = [CCDirector sharedDirector].winSize;
//    CCRenderTexture* texture = [CCRenderTexture renderTextureWithWidth:self.winSize.width height:self.winSize.height];
    //    texture.anchorPoint = ccp(0.5, 0.5);
    //    texture.position = ccp(self.winSize.width / 2, self.winSize.height / 2);
//    [texture beginWithClear:0 g:0 b:0 a:1.f];
//    ccDrawColor4B(0, 0, 0, 0);
//    ccDrawSolidCircle(ccp(self.winSize.width / 2, self.winSize.height / 2), 500, 360);
//    [texture end];
//    
//    CCSprite* circleSprite = [CCSprite spriteWithTexture:texture.sprite.texture];
//    circleSprite.anchorPoint = ccp(0.5f, 0.5f);
//    circleSprite.position = ccp(self.winSize.width / 2, self.winSize.height / 2);
//    [self addChild:circleSprite];
}



@end
