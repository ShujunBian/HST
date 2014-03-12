//
//  BubbleSkyLayer.h
//  town
//
//  Created by Song on 13-7-28.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCLayer.h"

@interface P1_BubbleSkyLayer : CCLayer
{
    ccTime totalTime;
    
    CCSprite *background;
}

@property (nonatomic, assign) CCSprite *upperCloud;
@property (nonatomic, assign) CCSprite *lowerCloud;

@property (nonatomic, assign) CCSprite *upperCloud2;
@property (nonatomic, assign) CCSprite *lowerCloud2;

@end
