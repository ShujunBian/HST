//
//  P5_SoilCloud.m
//  Dig
//
//  Created by Emerson on 14-2-26.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P5_SoilCloud.h"

@implementation P5_SoilCloud


- (id)init
{
    if (self = [super init]) {
        self.anchorPoint = CGPointMake(0.5, 0.0);
        self.isReadyToMove = NO;
    }
    return self;
}

- (void) createRandomSoilCloud
{
    self.soilCloudBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"P5_SoilCloud.png" capacity:5];
    [self addChild:_soilCloudBatchNode];
    NSInteger cloudCounter = 3 + (NSInteger)(2 * CCRANDOM_0_1());
    for (int i = 0; i < cloudCounter; ++ i) {
        [self performSelector:@selector(createSingleSoilCloud) withObject:self afterDelay:CCRANDOM_0_1() * i / 2 * 0.5];
    }
    
    [self performSelector:@selector(removeBySetFlag) withObject:self afterDelay:3.0];
}

- (void) createSingleSoilCloud
{
    CCSprite * soilCloud = [CCSprite spriteWithFile:@"P5_SoilCloud.png"];
    [soilCloud setPosition:CGPointMake(CCRANDOM_MINUS1_1() * 40, 30 * CCRANDOM_0_1())];
    soilCloud.scale = 0.1;
    [_soilCloudBatchNode addChild:soilCloud];
    
    float randomDuration = CCRANDOM_0_1() * 1.0 + 0.5;
    CCScaleTo * scale = [CCScaleTo actionWithDuration:randomDuration scale:(1.0 + 1.0 * CCRANDOM_0_1())];
    CCFadeOut * fadeOut = [CCFadeOut actionWithDuration:randomDuration];
    CCSpawn * spawn = [CCSpawn actions:scale,fadeOut, nil];
    [soilCloud runAction:spawn];
}

- (void) removeBySetFlag
{
    self.isReadyToMove = YES;
}
@end
