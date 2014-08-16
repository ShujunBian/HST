//
//  GrassLayer.m
//  Jump
//
//  Created by Emerson on 13-8-29.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_GrassLayer.h"
#import "P2_Flower.h"
#import "CCBReader.h"
#import "P2_Mushroom.h"

#define GRASS_MOVINGSPEED 1024.0 / 8.0
#define EVERYDELTATIME 0.016667

@implementation P2_GrassLayer
@synthesize flower;
@synthesize mushroom;
@synthesize grass;
@synthesize grass2;

-(id) init
{
	if( (self=[super init]))
    {
        self.isWaitingForSelect = YES;
        flower = (P2_Flower *)[CCBReader nodeGraphFromFile:@"P2_Flower.ccbi"];
        [flower setObjectFirstPosition];
        mushroom = (P2_Mushroom *)[CCBReader nodeGraphFromFile:@"P2_Mushrooms.ccbi"];
        [mushroom setObjectFirstPosition];
        if ([mushroom isSamePositionWithFlower:flower]) {
            [mushroom resetFlowerPosition:flower];
        }
        [self addChild:mushroom z:1];
        [self addChild:flower z:1];
        [self scheduleUpdate];
        
	}
	return self;
}

- (void) didLoadFromCCB
{
    
}


-(void) update:(ccTime)delta
{
    if (!_isWaitingForSelect) {
        if ([mushroom isSamePositionWithFlower:flower]) {
            //        NSLog(@"mushroom position is %f and flower position is %f",mushroom.position.x,flower.position.x);
            [mushroom resetFlowerPosition:flower];
        }
        self.grass.position = CGPointMake(self.grass.position.x - GRASS_MOVINGSPEED * EVERYDELTATIME, self.grass.position.y);
        self.grass2.position = CGPointMake(self.grass2.position.x - GRASS_MOVINGSPEED * EVERYDELTATIME, self.grass2.position.y);
        if(self.grass.position.x + self.grass.boundingBox.size.width < 512)
        {
            self.grass.position = CGPointMake(self.grass2.position.x + self.grass2.boundingBox.size.width, self.grass.position.y);
        }
        else if(self.grass2.position.x + self.grass2.boundingBox.size.width < 512)
        {
            self.grass2.position = CGPointMake(self.grass.position.x + self.grass.boundingBox.size.width, self.grass2.position.y);
        }
    }
}

@end
