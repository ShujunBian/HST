//
//  CircleTransitionLayer.h
//  HST
//
//  Created by wxy325 on 8/9/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"

typedef void (^VoidBlock)();

@interface CircleTransitionLayer : CCLayer
+ (CircleTransitionLayer*)layer;
- (id)init;

- (void)showSceneWithDuration:(float)duration onCompletion:(VoidBlock)block;
- (void)hideSceneWithDuration:(float)duration onCompletion:(VoidBlock)block;
@end
