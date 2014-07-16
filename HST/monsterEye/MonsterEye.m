//
//  MonsterEye.m
//  HST
//
//  Created by wxy325 on 7/16/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "MonsterEye.h"
#import "CCSprite+getRect.h"

@interface MonsterEye ()


@property (strong, nonatomic) CCSprite* eyeWhite; //眼眶
@property (strong, nonatomic) CCSprite* eyeBall;  //眼球
//眼皮
@property (strong, nonatomic) CCSprite* topEyelid;
@property (strong, nonatomic) CCSprite* bottomEyelid;

@property (assign, nonatomic) float eyeWhiteRadius;
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
        self.eyeWhiteRadius = eyeWhiteRect.size.height / 2.f;
        self.eyeBallRadius= [self.eyeBall getRect].size.height / 2.f;
        
        self.eyeWhite.anchorPoint = ccp(0.5,0.5);
        self.eyeBall.anchorPoint = ccp(0.5,0.5);
        
        
        //眼皮
        CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:eyeWhiteRect.size.width height:eyeWhiteRect.size.height / 2.f];
        [rt beginWithClear:1.f g:1.f b:1.f a:0.f];
        self.eyeWhite.position = ccp(eyeWhiteRect.size.width/2, 0);
        [self.eyeWhite visit];
        [rt end];
        CCSprite* bottom = [CCSprite spriteWithTexture:rt.sprite.texture];
        bottom.anchorPoint = ccp(0.5,0.5);
        bottom.position = ccp(0, 0);
        bottom.color = eyelidColor;
        self.bottomEyelid = bottom;
//        [self addChild:bottom];
        
        
        rt = [CCRenderTexture renderTextureWithWidth:eyeWhiteRect.size.width height:eyeWhiteRect.size.height / 2.f];
        [rt beginWithClear:1.f g:1.f b:1.f a:0.f];
        self.eyeWhite.position = ccp(eyeWhiteRect.size.width/2, eyeWhiteRect.size.height / 2);
        [self.eyeWhite visit];
        [rt end];
        CCSprite* top = [CCSprite spriteWithTexture:rt.sprite.texture];
        top.anchorPoint = ccp(0.5,0.5);
        top.position = ccp(0, 0);
        top.color = eyelidColor;
//        [self addChild:top];
        self.topEyelid = top;
        //眼眶 眼球

        self.eyeWhite.position = ccp(0,0);
        self.eyeBall.position = ccp(0,0);

        [self addChild:self.eyeWhite];
        [self addChild:self.eyeBall];
    }
    return self;
}

@end
