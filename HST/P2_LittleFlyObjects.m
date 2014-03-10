//
//  LittleFly.m
//  jump
//
//  Created by Emerson on 13-9-2.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_LittleFlyObjects.h"
#import "P2_LittleFlyBoom.h"
#import "CCBReader.h"
#import "SimpleAudioEngine.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation P2_LittleFlyObjects
@synthesize body;
@synthesize wing;
@synthesize musicType;

//    {131,255,245},//蓝绿

static ccColor3B littleFlyColors[] = {
    {255,229,55},//黄色
    {255,188,248},//紫色
    {91,222,255},//蓝色
    {111,255,141},//绿色
    {135,246,203},
    {151,255,28},
    {255,169,175},
    {255,200,33},
    {213,176,255}
};


- (id)init
{
	if( (self=[super init]))
    {
        objectMovingSpeed = 1024.0f / 140.0f;
	}
	return self;
}

- (void)didLoadFromCCB
{
    CCRotateBy * wingRotate = [CCRotateBy actionWithDuration:2.0 angle:360.0];
    CCRepeatForever * rotateForevr = [CCRepeatForever actionWithAction:wingRotate];
    [wing runAction:rotateForevr];
    
    
    CCSequence * littleFlySeq = [CCSequence actions:
                                 [CCMoveBy actionWithDuration:0.5 position:ccp(0, 30.0)],
                                 [CCMoveBy actionWithDuration:0.5 position:ccp(0, -30.0)],
                                 [CCMoveBy actionWithDuration:0.5 position:ccp(0, -30.0)],
                                 [CCMoveBy actionWithDuration:0.5 position:ccp(0, 30.0)],
                                 nil];
    
    CCRepeatForever * littleFlyMoveForever = [CCRepeatForever actionWithAction:littleFlySeq];
    [self runAction:littleFlyMoveForever];
}


- (ccColor3B)colorAtIndex:(NSUInteger)index
{
    return littleFlyColors[index];
}

- (void)setBodyColor:(ccColor3B)color
{
    body.color = color;
    ccColor3B wingColor;
    wingColor.r = color.r + 30 > 255 ? 255 : color.r + 30;
    wingColor.g = color.g + 30 > 255 ? 255 : color.g + 30;
    wingColor.b = color.b + 30 > 255 ? 255 : color.b + 30;
    wing.color = wingColor;
}

- (int)countOfColor
{
    return sizeof(littleFlyColors) / sizeof(ccColor3B);
}

- (void)handleCollision
{
    NSString * boomMusicFilename = [NSString stringWithFormat:@"%d.mp3",musicType];
    [[SimpleAudioEngine sharedEngine] playEffect:boomMusicFilename];
    [self performSelector:@selector(unloadMusicEffect) withObject:self afterDelay:1.0];
    
    P2_LittleFlyBoom * littleFlyBoom = (P2_LittleFlyBoom *)[CCBReader nodeGraphFromFile:@"P2_LittleFlyOut.ccbi"];
    littleFlyBoom.position = self.position;
    [littleFlyBoom setTintColor:self.body.color];
    [self.parent addChild:littleFlyBoom];
    
    [self stopAllActions];
    [self flyOut];
    
}

- (void)unloadMusicEffect
{
    NSString * boomMusicFilename = [NSString stringWithFormat:@"%d.mp3",musicType];
    [[SimpleAudioEngine sharedEngine] unloadEffect:boomMusicFilename];
}

- (void)update:(ccTime)delta
{
    if (self.position.x < - 100) {
        [self actionWhenOutOfScreen];
    }
    self.position = CGPointMake(self.position.x - objectMovingSpeed, self.position.y);
}

- (void)flyOut
{
    ccBezierConfig bezier;
    bezier.controlPoint_1 = ccp(-400, 150);
    bezier.controlPoint_2 = ccp(-350, 450);
    bezier.endPosition = ccp(-600, 600);
    
    float x_pointRange = (float)arc4random() / ARC4RANDOM_MAX * 600;
    float x_point = x_pointRange * (-1);
    if ((float)arc4random() / ARC4RANDOM_MAX > 0.55) {
        x_point = x_point * -1;
    }
    CCSequence * littleFlyReadyToFlyOutSeq = [CCSequence actions:
                                              [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:0.2 position:ccp(0, 60.0)] rate:3.0] ,
                                              [CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0, -30.0)] rate:2.0],
                                              [CCEaseIn actionWithAction:[CCMoveBy actionWithDuration:1.0 position:ccp(x_point, 600)] rate:2],
                                              nil];
    
    
    
    [self runAction:littleFlyReadyToFlyOutSeq];
}

- (void)setObjectFirstPosition
{
    //    objectPostionX = 1024.0 + (float)arc4random() / ARC4RANDOM_MAX * 1024.0;
    objectPostionX = 1024.0 + 100.0;
    //    objectPostionY = 450.0;
    objectPostionY = (float)arc4random() / ARC4RANDOM_MAX * 120.0;
    self.position = CGPointMake(objectPostionX, self.contentSize.height / 2 + 400.0 + objectPostionY);
    
    //    while ([self.delegate isSamePositionWithOtherFlyObjects:self]) {
    //        self.position = CGPointMake(self.position.x + 200.0, self.position.y);
    //    }
}

- (void)actionWhenOutOfScreen
{
    [self.delegate removeFromOnScreenArray:self];
    [self removeFromParentAndCleanup:YES];
}


@end
