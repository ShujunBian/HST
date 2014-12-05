//
//  P3_Mushroom.h
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright 2014年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"

@interface P3_Mushroom : CCNode<CCBAnimationManagerDelegate>

@property (nonatomic, assign) CCSprite *mushroomBody;
@property (nonatomic, assign) CCSprite *mushroomEye;

@end
