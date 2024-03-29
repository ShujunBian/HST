//
//  SkyLayer.h
//  town
//
//  Created by Emerson on 13-7-28.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface P2_SkyLayer : CCLayer
{
    ccTime totalTime;
    CCSprite *background;
}

@property (nonatomic, assign) CCSprite *upperCloud;
@property (nonatomic, assign) CCSprite *upperCloud2;
@property (nonatomic) BOOL isWaitingForSelect;

@end
