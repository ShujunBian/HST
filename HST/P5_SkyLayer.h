//
//  P5_SkyLayer.h
//  Dig
//
//  Created by Emerson on 14-1-25.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface P5_SkyLayer : CCLayer
{
    ccTime totalTime;
    CCSprite *background;
}

@property (nonatomic, assign) CCSprite *upperCloud;
@property (nonatomic, assign) CCSprite *upperCloud2;

@end
