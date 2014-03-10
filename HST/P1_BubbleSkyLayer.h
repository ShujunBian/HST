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

@property (nonatomic,retain) CCSprite *upperCloud;
@property (nonatomic,retain) CCSprite *lowerCloud;

@property (nonatomic,retain) CCSprite *upperCloud2;
@property (nonatomic,retain) CCSprite *lowerCloud2;

@end
