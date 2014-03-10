//
//  MonsterEye.h
//  town
//
//  Created by Song on 13-7-28.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "CCNode.h"

@interface P1_MonsterEye : CCNode
{
    CCSprite *mask;
    CCSprite *upperlid;
    CCSprite *lowerlid;
    
    CCSprite *composite;
    
    ccTime totalBlinkTime;
}

@property (nonatomic,retain) CCSprite *eyeWhite;

- (void)blink;

@end
