//
//  CCLayer+CircleTransitionExtension.h
//  HST
//
//  Created by wxy325 on 8/9/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"

typedef CCScene* (^SceneBlock)();
typedef void (^VoidBlock)();

@interface CCLayer (CircleTransitionExtension)
- (void)showScene;
- (void)showSceneOnCompletion:(VoidBlock)completion;

- (void)changeToScene:(SceneBlock)sceneBlock;
- (void)changeToScene:(SceneBlock)sceneBlock onCompletion:(VoidBlock)completion;

- (void)changeToLoadedScene:(CCScene*)scene;
- (void)changeToLoadedScene:(CCScene*)scene onCompletion:(VoidBlock)completion;



@end
