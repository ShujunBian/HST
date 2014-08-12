//
//  IntroLayer.m
//  HST
//
//  Created by Emerson on 14-3-10.
//  Copyright Emerson 2014年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "CCBReader.h"
#import "GameLoadingProcessBar.h"
#import "CircleTransition.h"
#import "SimpleAudioEngine.h"
#import "CCLayer+CircleTransitionExtension.h"
#import "MonsterEye.h"
#import "MonsterEyeUpdateObject.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@interface IntroLayer ()
@property (assign, nonatomic) int loadingCount;
@property (strong, nonatomic) NSArray* loadingImageNameArray;

@property (strong, nonatomic) GameLoadingProcessBar* processBar;
@property (strong, nonatomic) MonsterEyeUpdateObject* updateObj;

@property (strong, nonatomic) NSDate* startDate;

@end

@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default.png"];
		}
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
        GameLoadingProcessBar* bar = [[[GameLoadingProcessBar alloc] init] autorelease];
        bar.position = ccp(size.width/2, size.height/2 - 200);
        bar.percentage = 0.f;
        [self addChild:bar];
        self.processBar = bar;
        
        
        self.updateObj = [[[MonsterEyeUpdateObject alloc] init] autorelease];
        self.updateObj.mode = MonsterEyeUpdateObjectModeLaunchImage;
        self.updateObj.firstDelay = 0.7f;
        MonsterEye* eye = [[[MonsterEye alloc] initWithEyeWhiteName:@"launch_eye_white.png" eyeballName:@"launch_eye_ball.png" eyelidColor:ccc3(221, 161, 255)] autorelease];
        eye.position = ccp(433, 428);
        eye.eyeBallBasePosition = ccp(-5 ,1);
        [self addChild:eye];
        [self.updateObj addMonsterEye:eye];
	}
	return self;
}

-(void) onEnter
{
	[super onEnter];
    self.startDate = [NSDate date];
    
    
    [self.updateObj beginUpdate];
    
    self.loadingCount = 0;
    self.loadingImageNameArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"world_resource" ofType:@"plist"]];

    [self performSelector:@selector(playBgMusic) withObject:nil afterDelay:1.f];
    
    CCTextureCache* textureCache = [CCTextureCache sharedTextureCache];

    for (NSString* imageName in self.loadingImageNameArray)
    {
        [textureCache addImageAsync:imageName target:self selector:@selector(loadCallBack)];
    }
}
- (void)onExit
{
    [super onExit];
    [self.updateObj endUpdate];
    self.updateObj = nil;
    self.startDate = nil;
}
- (void)playBgMusic
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"world.mp3" loop:YES];
}
- (void)loadCallBack
{
    ++self.loadingCount;
    float percentage = (float)self.loadingCount / (self.loadingImageNameArray.count + 4);
    self.processBar.percentage = percentage;
    
    if (self.loadingCount == self.loadingImageNameArray.count)
    {
        NSDate* date = [NSDate date];

        NSTimeInterval interval = [date timeIntervalSinceDate:self.startDate];
        [self performSelector:@selector(introEnd) withObject:nil afterDelay:2 - interval];
    }
}
- (void)introEnd
{
    self.processBar.percentage = 1.f;
    [self changeToScene:^CCScene *{
        CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"world.ccbi"];
        return scene;
    }];
}
@end
