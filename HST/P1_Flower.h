//
//  P1_Flower.h
//  HST
//
//  Created by Emerson on 14-12-4.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@interface P1_Flower : CCNode<CCBAnimationManagerDelegate>

@property (nonatomic, assign) CCSprite *flowerBody;
@property (nonatomic, assign) CCSprite *flowerHead;
@property (nonatomic, assign) CCSprite *flowerEyes;

@end
