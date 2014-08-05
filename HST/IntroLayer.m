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

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@interface IntroLayer ()
@property (assign, nonatomic) int loadingCount;
@property (strong, nonatomic) NSArray* loadingImageNameArray;

@property (strong, nonatomic) GameLoadingProcessBar* processBar;

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
        
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
    
    self.loadingCount = 0;
    self.loadingImageNameArray =
    @[
      @"cloud.png",
      @"monster_teeth.png",
      @"mountion.png",
      @"upper_cloud.png",
      @"p2_cloud.png",
      @"p2_firstmonster_eyewhite.png",
      @"p2_flower_head.png",
      @"p2_ground.png",
      @"p2_monster_body.png",
      @"p2_monster_eye_closed.png",
      @"p2_monster_eyewhite.png",
      @"p2_mountain1.png",
      @"p2_mountain2.png",
      @"p2_secondmonster_eyewhite.png",
      @"p2_upper_cloud.png",
      @"P3_bell.png",
      @"P3_cloud.png",
      @"P3_eye_Skin_down.png",
      @"P3_eye_Skin_up.png",
      @"P3_flower_head.png",
      @"P3_grass.png",
      @"P3_grassBehind.png",
      @"P3_GrassPSQ.png",
      @"P3_Monster1_Eye_background.png",
      @"P3_Monster1_Eye_point.png",
      @"P3_monster1_face.png",
      @"P3_monster1_mouth.png",
      @"P3_monster1_tail.png",
      @"P3_monster1_tail_flower.png",
      @"P3_monster2_mouth.png",
      @"P3_monster3_face.png",
      @"P3_monster3_mouth.png",
      @"P3_monster4_face.png",
      @"P3_monster5_face.png",
      @"P3_Monster_body_mouth.png",
      @"P3_monster_body_sing.png",
      @"P3_Monster_Eye.png",
      @"P3_Monster_Mouth.png",
      @"P3_monster_sing.png",
      @"P3_MonsterBody_SingMouth.png",
      @"P3_mushroom.png",
      @"P3_staticScenery.png",
      @"P3_windChime.png",
      @"P4water_particle.png",
      @"p4_background.png",
      @"p4_ground.png",
      @"P4_bottle_glass.png",
      @"P4_bottle_left_cap.png",
      @"P4_bottle_left_ear.png",
      @"P4_bottle_left_foot.png",
      @"P4_bottle_light.png",
      @"P4_bottle_main.png",
      @"P4_bottle_mask.png",
      @"P4_bottle_renew_button.png",
      @"P4_bottle_right_cap.png",
      @"P4_bottle_right_ear.png",
      @"P4_bottle_right_foot.png",
      @"P4_bottleFoot.png",
      @"p4_cloud_1.png",
      @"p4_cloud_2.png",
      @"p4_cloud_3.png",
      @"p4_cloud_top.png",
      @"P4_blue_monster.png",
      @"P4_blue_monster_light.png",
      @"P4_brown_monster.png",
      @"P4_brown_monster_light.png",
      @"P4_green_monster.png",
      @"P4_green_monster_light.png",
      @"P4_purple_monster.png",
      @"P4_purple_monster_light.png",
      @"P4_yellow_monster.png",
      @"P4_yellow_monster_light.png",
      @"P4_blue_eyeball_1.png",
      @"P4_blue_eyeball_2.png",
      @"P4_blue_eyewhite_1.png",
      @"P4_blue_eyewhite_2.png",
      @"P4_green_eyeball_1.png",
      @"P4_green_eyeball_2.png",
      @"P4_green_eyewhite_1.png",
      @"P4_green_eyewhite_2.png",
      @"P4_purple_eyeball_1.png",
      @"P4_purple_eyewhite_1.png",
      @"P4_red_eyeball_1.png",
      @"P4_red_eyeball_2.png",
      @"P4_red_eyewhite_1.png",
      @"P4_red_eyewhite_2.png",
      @"P4_yellow_eyeball_1.png",
      @"P4_yellow_eyeball_2.png",
      @"P4_yellow_eyewhite_1.png",
      @"P4_yellow_eyewhite_2.png",
      @"P4_monster1_mask.png",
      @"P4_monster2_mask.png",
      @"P4_monster3_mask.png",
      @"P4_monster4_mask.png",
      @"P4_monster5_mask.png",
      @"water1.png",
      @"water2.png",
      @"MainMap_GreenFlowerHead.png",
      @"P5_BellLight.png",
      @"P5_BigCircleUI_Choosen.png",
      @"P5_clouds.png",
      @"p5_flower_head.png",
      @"p5_grass.png",
      @"p5_hole.png",
      @"P5_homeBackground.png",
      @"P5_homePhoto.png",
      @"p5_houses.png",
      @"P5_monsterBigShadow.png",
      @"P5_monsterBody.png",
      @"P5_monsterLeg.png",
      @"P5_monsterLittleShadow.png",
      @"P5_mountain1.png",
      @"P5_mountain2.png",
      @"P5_SmallCircleUI.png",
      @"P5_underground.png",
      @"P5_undergroundHole.png",
      @"MainMapP3_mask.png",
      @"world_background.png",
      @"world_background_cloud.png",
      @"world_background_floor.png",
      @"world_background_mountain_left.png",
      @"world_background_mountain_right.png",
      @"world_background_tree1.png",
      @"world_background_tree2.png",
      @"world_background_tree3.png",
      @"world_background_tree4.png",
      @"world_background_tree5.png",
      @"world_cloud_background.png",
      @"world_full.png",
      @"world_p1_dialog.png",
      @"world_p2_dialog.png",
      @"world_p3_dialog.png",
      @"world_p4_dialog.png",
      @"world_p5_dialog.png",
      @"world_p1_cloud1.png",
      @"world_p1_cloud2.png",
      @"world_p1_grass1.png",
      @"world_p1_mountain1.png",
      @"world_p1_mountain2.png",
      @"world_p1_mountain3.png",
      @"world_p1_tree1.png",
      @"world_p2_grass.png",
      @"world_p2_tree.png",
      @"world_p3_back_house.png",
      @"world_p3_grass.png",
      @"world_p3_house.png",
      @"world_p3_tree.png",
      @"world_p4_car.png",
      @"world_p4_shadow.png",
      @"world_p4_stone.png",
      @"world_p5_grass.png",
      @"world_p5_holl.png",
      @"world_p5_mask.png",
      @"world_p5_mushroom_shadow.png",
      @"world_p5_stone.png",
      //      @"",
      ];

    [self performSelector:@selector(playBgMusic) withObject:nil afterDelay:1.f];
    
    CCTextureCache* textureCache = [CCTextureCache sharedTextureCache];

    for (NSString* imageName in self.loadingImageNameArray)
    {
        [textureCache addImageAsync:imageName target:self selector:@selector(loadCallBack)];
    }
    
}
- (void)playBgMusic
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"world.mp3" loop:YES];
}
- (void)loadCallBack
{
    ++self.loadingCount;
    float percentage = (float)self.loadingCount / (self.loadingImageNameArray.count + 1);
    self.processBar.percentage = percentage;
    
    if (self.loadingCount == self.loadingImageNameArray.count)
    {
        CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"world.ccbi"];
        self.processBar.percentage = 1.f;
        [[CCDirector sharedDirector] replaceScene:[CircleTransition transitionWithDuration:1.0 scene:scene ]];
    }
    
    
}
@end
