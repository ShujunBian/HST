//
//  CCLayer+CircleTransitionExtension.h
//  HST
//
//  Created by wxy325 on 8/9/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"

typedef CCScene* (^SceneBlock)();

@interface CCLayer (CircleTransitionExtension)
- (void)showScene;
- (void)changeToScene:(SceneBlock)sceneBlock;
- (void)changeToLoadedScene:(CCScene*)scene;
@end
