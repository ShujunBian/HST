//
//  HelloWorldLayer.h
//  hst_p4
//
//  Created by wxy325 on 1/17/14.
//  Copyright cdi 2014. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class P4CloudLayer;
@class P4Monster;
@class P4Bottle;

@interface P4GameLayer : CCLayer 


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@property (strong, nonatomic) CCSprite* backgroundSprite;

@property (strong, nonatomic) P4CloudLayer* cloudLayer;

@property (strong, nonatomic) P4Monster* greenMonster;
@property (strong, nonatomic) P4Monster* brownMonster;
@property (strong, nonatomic) P4Monster* purpleMonster;
@property (strong, nonatomic) P4Monster* blueMonster;
@property (strong, nonatomic) P4Monster* yellowMonster;
@property (strong, nonatomic) P4Bottle* bottle;

- (void)monstersRenew;


@end
