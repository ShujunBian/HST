//
//  Mushroom.h
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"
#import "P2_GameObjects.h"
#import "P2_Flower.h"
#import "CCBAnimationManager.h"

@interface P2_Mushroom : P2_GameObjects<CCBAnimationManagerDelegate>

@property (nonatomic, assign) CCSprite *mushroomBody1;
@property (nonatomic, assign) CCSprite *mushroomHead1;
@property (nonatomic, assign) CCSprite *mushroomEyes1;
@property (nonatomic, assign) CCSprite *mushroomBody2;
@property (nonatomic, assign) CCSprite *mushroomHead2;
@property (nonatomic, assign) CCSprite *mushroomEyes2;

-(BOOL)isSamePositionWithFlower:(P2_Flower *)flower;
-(void)resetFlowerPosition:(P2_Flower *)flower;

@end
