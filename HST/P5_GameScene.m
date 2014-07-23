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
#import "MainMapHelper.h"
#import "HelloWorldLayer.h"
#import "NSNotificationCenter+Addition.h"

#define kHoleCoverTag 1

@interface P5_GameScene ()

@property (strong, nonatomic) MainMapHelper* mainMapHelper;
@end

@implementation P5_GameScene
//{
//    MainMapHelper * mainMapHelper;
//}
@synthesize monsterUpground;
@synthesize monsterUnderground;
@synthesize grassLayer;
@synthesize undergrounScene;

@synthesize skyLayer;
@synthesize mountain1;
@synthesize mountain2;

- (void) didLoadFromCCB
{
    self.mainMapHelper = [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 7.0)];

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
    monsterUpground.isUpground = YES;
    
    monsterUnderground = (P5_Monster *)[CCBReader nodeGraphFromFile:@"P5_MonsterUnderground.ccbi"];
    [undergrounScene addChild:monsterUnderground z:5];
    monsterUnderground.position = CGPointMake(900.0, 650.0);
    [monsterUnderground setVisible:NO];
    monsterUnderground.delegate = undergrounScene;
    monsterUnderground.isUpground = NO;
    undergrounScene.monsterUnderground = monsterUnderground;
    
    CCSprite * caveCover = [CCSprite spriteWithFile:@"P5_cave_cover.png"];
    [caveCover setPosition:CGPointMake(859.0, 65.0)];
    [self addChild:caveCover z:1];
    CCSprite * holeCover = [CCSprite spriteWithFile:@"P5_hole_cover.png"];
    holeCover.position = CGPointMake(900.5, 612);
    [undergrounScene addChild:holeCover z:6 tag:kHoleCoverTag];
    
    [self setScale:2.0];
    [self setPosition:CGPointMake(-winSize.width / 2 + 60.0, winSize.height /2)];

    [self performSelector:@selector(moveToUnderground) withObject:self afterDelay:1.3];
}

- (void)moveToUnderground
{
    [monsterUpground rollUpground];
//    CCBAnimationManager* animationManager = monsterUpground.userObject;
//    animationManager.delegate = self;
//    [animationManager runAnimationsForSequenceNamed:@"Jump"];
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
    
    [self performSelector:@selector(monsterMoveToUnderground) withObject:self afterDelay:1.8];

}

- (void)monsterMoveToUnderground
{
    [monsterUnderground setVisible:YES];
    [monsterUnderground moveToUnderground];
}

//- (void)completedAnimationSequenceNamed:(NSString *)name
//{
//    if ([name isEqualToString:@"Jump"]) {
//        [monsterUnderground setVisible:YES];
//        [monsterUnderground moveToUnderground];
//    }
//}

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

#pragma mark - 菜单键调用函数
- (void)restartGameScene
{
    [undergrounScene restartUndergroundWorld];
}

- (void)returnToMainMap
{
//    [mainMapHelper release];
    self.mainMapHelper = nil;
    [self unscheduleAllSelectors];
    for (CCNode * child in [self children]) {
        [child stopAllActions];
        [child unscheduleAllSelectors];
    }
    
    [undergrounScene releaseBellAndDrawArray];
    [NSNotificationCenter unregister:undergrounScene];

    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFade transitionWithDuration:1.0
                                        scene:[HelloWorldLayer scene]]];
}

#pragma mark - 退出时释放内存
- (void)dealloc
{
    [super dealloc];
    [[CCTextureCache sharedTextureCache]removeAllTextures];
}

@end
