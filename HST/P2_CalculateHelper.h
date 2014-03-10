//
//  CalculateHelper.h
//  jump
//
//  Created by Emerson on 13-9-3.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P2_CalculateHelper : NSObject

+ (float)getTheRestFrameForMonsterMoveWith:(float)height;
+ (float)getTheMonsterCollisionHeightFrom:(int)frame;
+ (int)getMonsterCurrentJumpFrameBy:(float)currentJumpTime;

@end
