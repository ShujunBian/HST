//
//  P3_MonsterEye.h
//  HST
//
//  Created by Emerson on 14-7-11.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P3_MonsterEye : NSObject

@property (nonatomic) NSInteger monsterEyeCounter;
@property (nonatomic, strong) NSMutableArray * monsterEyeSprites;
@property (nonatomic, strong) NSMutableArray * monsterEyeBlackSprites;
@property (nonatomic, strong) NSMutableArray * monsterEyePositions;

@end
