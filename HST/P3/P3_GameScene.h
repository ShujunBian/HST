//
//  P3_GameScene.h
//  HST
//
//  Created by Emerson on 14-7-10.
//  Copyright 2013年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBReader.h"
#import "CCBAnimationManager.h"
#import "P3_Monster.h"

@interface P3_GameScene : CCLayer<P3_MonsterDelegate> {
    
}

@property (nonatomic, assign) CCLayer * monsterLayer;

@end
