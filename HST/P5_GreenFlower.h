//
//  P5_GreenFlower.h
//  HST
//
//  Created by Emerson on 14-12-5.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCNode.h"
#import "CCBAnimationManager.h"

@interface P5_GreenFlower : CCNode<CCBAnimationManagerDelegate>

@property (nonatomic, assign) CCSprite *flowerBody;
@property (nonatomic, assign) CCSprite *flowerHead;
@property (nonatomic, assign) CCSprite *flowerEyes;

@end
