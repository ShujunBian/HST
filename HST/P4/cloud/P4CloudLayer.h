//
//  P4CloudLayer.h
//  hst_p4
//
//  Created by wxy325 on 1/17/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "CCNode.h"
#import "P4Cloud.h"


@interface P4CloudLayer : CCNode

//@property (strong, nonatomic) P4Cloud* cloudTop;
@property (strong, nonatomic) P4Cloud* cloud1;
@property (strong, nonatomic) P4Cloud* cloud2;
@property (strong, nonatomic) P4Cloud* cloud3;

- (void)startAnimation;

@end
