//
//  HelloWorldLayer.m
//  HST
//
//  Created by Emerson on 14-3-10.
//  Copyright Emerson 2014年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import "CCBReader.h"
#import "MonsterEyeTestLayer.h"

#import "CircleTransition.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {

		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCMenuItem *P1_Item = [CCMenuItemFont itemWithString:@"P1_Item" block:^(id sender) {
            ((CCMenuItem *)sender).isEnabled = NO;

            CCScene* p1Scene = [CCBReader sceneWithNodeGraphFromFile:@"P1_GameScene.ccbi"];
			[[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p1Scene]];
		}];
		// Leaderboard Menu Item using blocks
		CCMenuItem *P2_Item = [CCMenuItemFont itemWithString:@"P2_Item" block:^(id sender) {
            ((CCMenuItem *)sender).isEnabled = NO;

            CCScene* p2Scene = [CCBReader sceneWithNodeGraphFromFile:@"P2_GameScene.ccbi"];
            [self preloadMusicAndEffect];
			[[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p2Scene]];
		}];

        CCMenuItem *P3_Item = [CCMenuItemFont itemWithString:@"P3_Item" block:^(id sender) {
            ((CCMenuItem *)sender).isEnabled = NO;

			CCScene * p3Scene = [CCBReader sceneWithNodeGraphFromFile:@"P3_GameScene.ccbi"];
            [[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p3Scene]];
		}];
        
        CCMenuItem *P4_Item = [CCMenuItemFont itemWithString:@"P4_Item" block:^(id sender) {
            ((CCMenuItem *)sender).isEnabled = NO;
            
			CCScene * p4Scene = [CCBReader sceneWithNodeGraphFromFile:@"P4GameLayer.ccbi"];
            [[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p4Scene]];
		}];
        
        CCMenuItem *P5_Item = [CCMenuItemFont itemWithString:@"P5_Item" block:^(id sender) {
            ((CCMenuItem *)sender).isEnabled = NO;

            CCScene* p5Scene = [CCBReader sceneWithNodeGraphFromFile:@"P5_GameScene.ccbi"];
			[[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:p5Scene]];
		}];
        

        /*
        CCMenuItem *monsterEyeTestScene = [CCMenuItemFont itemWithString:@"Monster Eye Test" block:^(id sender) {
            CCScene* scene = [MonsterEyeTestLayer scene];
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];
		}];
        */
        
        CCMenuItem *mainMapScene = [CCMenuItemFont itemWithString:@"MainMap" block:^(id sender) {
            ((CCMenuItem *)sender).isEnabled = NO;

            CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"world.ccbi"];
			[[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:scene]];
		}];
        
		CCMenu *menu = [CCMenu menuWithItems:P1_Item, P2_Item,P3_Item,P4_Item,P5_Item,/* monsterEyeTestScene,*/ mainMapScene, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		[self addChild:menu];

	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark - 预加载音效
- (void)preloadMusicAndEffect
{
    for (int i = 0; i < 7; ++ i) {
        NSString * boomMusicFilename = [NSString stringWithFormat:@"P2_%d.mp3",i + 1];
        [[SimpleAudioEngine sharedEngine]preloadEffect:boomMusicFilename];
    }
}
@end
