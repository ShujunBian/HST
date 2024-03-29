//
//  P5_Flower.h
//  Dig
//
//  Created by Emerson on 14-1-24.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@interface P5_Flower : CCNode<CCBAnimationManagerDelegate>

@property (nonatomic, assign) CCSprite *flowerBody;
@property (nonatomic, assign) CCSprite *flowerHead;
@property (nonatomic, assign) CCSprite *flowerEyes;

@end
