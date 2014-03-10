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

@interface P2_Mushroom : P2_GameObjects

-(BOOL)isSamePositionWithFlower:(P2_Flower *)flower;

-(void)resetFlowerPosition:(P2_Flower *)flower;

@end
