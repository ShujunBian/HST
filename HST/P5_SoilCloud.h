//
//  P5_SoilCloud.h
//  Dig
//
//  Created by Emerson on 14-2-26.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"

@interface P5_SoilCloud : CCNode

@property (nonatomic, assign) CCSpriteBatchNode * soilCloudBatchNode;
@property (nonatomic) BOOL isReadyToMove;

- (void) createRandomSoilCloud;

@end
