//
//  P5_GameScene.m
//  Dig
//
//  Created by Emerson on 14-1-24.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P5_GameScene.h"
#import "P5_GrassLayer.h"
#import "P5_Monster.h"
#import "P5_SkyLayer.h"

#define kHoleCoverTag 1

@implementation P5_GameScene

@synthesize monsterUpground;
@synthesize monsterUnderground;
@synthesize grassLayer;
@synthesize undergrounScene;

@synthesize skyLayer;
@synthesize mountain1;
@synthesize mountain2;

- (void) didLoadFromCCB
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    CCLayerColor * background = [CCLayerColor layerWithColor:ccc4(183,255,226,255)];
    [self addChild:background z:-10];
    
    grassLayer = (P5_GrassLayer *)[CCBReader nodeGraphFromFile:@"P5_GrassLayer.ccbi"];
    [self addChild:grassLayer z:2];
    
    undergrounScene = (P5_UndergroundScene *)[CCBReader nodeGraphFromFile:@"P5_UndergroundScene.ccbi"];
    undergrounScene.position = CGPointMake(0.0 , -720.0);
    [self addChild:undergrounScene z:3];
    [undergrounScene createUndergroundWorld];
    undergrounScene.delegate = self;
    
    monsterUpground = (P5_Monster *)[CCBReader nodeGraphFromFile:@"P5_Monster.ccbi"];
    [self addChild:monsterUpground z:0];
    monsterUpground.position = CGPointMake(700.0 , 53.0);
    
    monsterUnderground = (P5_Monster *)[CCBReader nodeGraphFromFile:@"P5_MonsterUnderground.ccbi"];
    [undergrounScene addChild:monsterUnderground z:5];
    monsterUnderground.position = CGPointMake(900.0, 650.0);
    [monsterUnderground setVisible:NO];
    monsterUnderground.delegate = undergrounScene;
    undergrounScene.monsterUnderground = monsterUnderground;
    
    CCSprite * caveCover = [CCSprite spriteWithFile:@"P5_cave_cover.png"];
    [caveCover setPosition:CGPointMake(859.0, 65.0)];
    [self addChild:caveCover z:1];
    CCSprite * holeCover = [CCSprite spriteWithFile:@"P5_hole_cover.png"];
    holeCover.position = CGPointMake(900.5, 612);
    [undergrounScene addChild:holeCover z:6 tag:kHoleCoverTag];
    
    [self setScale:2.0];
    [self setPosition:CGPointMake(-winSize.width / 2 + 60.0, winSize.height /2)];
    
    [self performSelector:@selector(moveToUnderground) withObject:self afterDelay:0.3];
}

- (void)moveToUnderground
{
    CCBAnimationManager* animationManager = monsterUpground.userObject;
    animationManager.delegate = self;
    [animationManager runAnimationsForSequenceNamed:@"Jump"];
    [self performSelector:@selector(changeCameraCenter) withObject:self afterDelay:0.3];
}

- (void)changeCameraCenter
{
    CCMoveTo * moveDown = [CCMoveTo actionWithDuration:1.75 position:CGPointMake(0.0, 720.0)];
    CCEaseInOut * moveEaseInout = [CCEaseInOut actionWithAction:moveDown rate:3.0];
    CCScaleTo * scaleBack = [CCScaleTo actionWithDuration:1.75 scale:1.0];
    CCEaseInOut * scaleEaseInout = [CCEaseInOut actionWithAction:scaleBack rate:3.0];
    CCSpawn * spawn = [CCSpawn actions:moveEaseInout,scaleEaseInout, nil];
    [self runAction:spawn];

}

- (void)completedAnimationSequenceNamed:(NSString *)name
{
    if ([name isEqualToString:@"Jump"]) {
        [monsterUnderground setVisible:YES];
        [monsterUnderground moveToUnderground];
    }
}

#pragma mark - 清除纹理中的缓存图片 undergroundSceneDelegate
- (void)releaseTheCacheInTexture
{
    [monsterUpground removeFromParentAndCleanup:YES];
    [skyLayer removeFromParentAndCleanup:YES];
    [mountain2 removeFromParentAndCleanup:YES];
    
    [[CCTextureCache sharedTextureCache]removeTextureForKey:@"P5_cave_cover.png"];
    [[CCTextureCache sharedTextureCache]removeTextureForKey:@"P5_hole_cover.png"];
    [[CCTextureCache sharedTextureCache]removeTextureForKey:@"P5_clouds.png"];
    [[CCTextureCache sharedTextureCache]removeTextureForKey:@"P5_mountain2.png"];
}

@end
