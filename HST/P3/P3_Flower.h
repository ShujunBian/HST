//
//  P3_Flower.h
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright 2014年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"

@interface P3_Flower : CCNode<CCBAnimationManagerDelegate>

@property (nonatomic, assign) CCSprite *flowerBody;
@property (nonatomic, assign) CCSprite *flowerHead;
@property (nonatomic, assign) CCSprite *flowerEyes;

@end
