//
//  HelloWorldLayer.m
//  HST
//
//  Created by Emerson on 14-3-10.
//  Copyright Emerson 2014年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "CCBReader.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {

		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCMenuItem *P1_Item = [CCMenuItemFont itemWithString:@"P1_Item" block:^(id sender) {
            CCScene* p1Scene = [CCBReader sceneWithNodeGraphFromFile:@"P1_GameScene.ccbi"];
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:p1Scene]];
		}];
		
		// Leaderboard Menu Item using blocks
		CCMenuItem *P2_Item = [CCMenuItemFont itemWithString:@"P2_Item" block:^(id sender) {
            CCScene* p1Scene = [CCBReader sceneWithNodeGraphFromFile:@"P2_GameScene.ccbi"];
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:p1Scene]];
		}];

        CCMenuItem *P3_Item = [CCMenuItemFont itemWithString:@"P3_Item" block:^(id sender) {
			
		}];
        
        CCMenuItem *P4_Item = [CCMenuItemFont itemWithString:@"P4_Item" block:^(id sender) {
			
		}];
        
        CCMenuItem *P5_Item = [CCMenuItemFont itemWithString:@"P5_Item" block:^(id sender) {
            CCScene* p1Scene = [CCBReader sceneWithNodeGraphFromFile:@"P5_GameScene.ccbi"];
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:p1Scene]];
		}];
        
		CCMenu *menu = [CCMenu menuWithItems:P1_Item, P2_Item,P3_Item,P4_Item,P5_Item, nil];
		
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

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
