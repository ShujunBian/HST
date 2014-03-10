//
//  GameScene.m
//  town
//
//  Created by Song on 13-7-25.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_GameScene.h"
#import "cocos2d.h"
#import "CCBAnimationManager.h" 
#import "SimpleAudioEngine.h"
#import "P2_GrassLayer.h"
#import "P2_Monster.h"
#import "P2_LittleMonster.h"
#import "P2_LittleFlyObjects.h"
#import "P2_CalculateHelper.h"
#import "SimpleAudioEngine.h"
#import "P2_LittleFlyBoom.h"

#define EVERYDELTATIME 0.016667

@implementation P2_GameScene
@synthesize grassLayer;
@synthesize monster;
@synthesize firstLittleMonster;
@synthesize secondLittleMonster;


- (id)init
{
    if ((self = [super init])) {
//        self.frameToShowCurrentFrame = [[NSArray alloc]initWithObjects:@"34",@"36",@"38",@"42",@"44",
//                                        @"46",@"50",@"52",@"54",@"56",@"58",@"60",@"62",@"66",@"68",@"70",@"74",@"76",@"78",@"84",
//                                        @"86",@"88",@"90",@"98",@"100",@"102",@"104",@"106",@"108",@"110",@"114",@"116",@"118",@"120",
//                                        @"122",@"124",@"126",@"130",@"132",@"134",@"138",@"140",@"142",@"146",@"148",@"150",@"152",@"154",nil];
        
//        self.frameToShowCurrentFrame = [[NSArray alloc]initWithObjects:@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24",@"26",@"28",
//                                        @"30",@"32",@"34",@"36",@"38",@"40",@"42",@"44",@"46",@"48",@"50",@"52",@"54",@"56",@"58",@"60",
//                                        @"62",@"64",@"66",@"68",@"70",@"72",@"74", nil];
        if (frameToShowCurrentFrame == nil) {
            frameToShowCurrentFrame = [[NSArray alloc]initWithObjects:@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",
                                            @"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
                                            @"31",@"32",@"33",@"34",@"35",@"36",@"37", nil];
        }
//        self.musicTypeInFrame = [[NSArray alloc]initWithObjects:@"5",@"3",@"3",@"4",@"2",@"2",@"1",@"2",@"3",@"4",@"5",@"5",@"5",@"5",@"3",@"3",
//                                 @"4",@"2",@"2",@"1",@"3",@"5",@"5",@"3",@"2",@"2",@"2",@"2",@"2",@"3",@"4",@"3",@"3",@"3",@"3",@"3",@"4",
//                                 @"5",@"5",@"3",@"3",@"4",@"2",@"2",@"1",@"3",@"5",@"5",nil];

        if (musicTypeInFrame == nil) {
            musicTypeInFrame = [[NSArray alloc]initWithObjects:@"3",@"2",@"1",@"7",@"6",@"5",@"6",@"7",@"3",@"2",@"1",@"7",
                                     @"6",@"5",@"6",@"7",@"3",@"2",@"1",@"7",@"6",@"5",@"6",@"7",@"3",@"2",@"1",@"7",@"6",@"5",@"6",@"7",@"1", nil];
        }
    }
    return  self;
}

- (void) didLoadFromCCB
{
    [CDAudioManager configure:kAMM_PlayAndRecord];
    [[CDAudioManager sharedManager] playBackgroundMusic:@"rhythm.mp3" loop:NO];
    
    CCLayerColor * background = [CCLayerColor layerWithColor:ccc4(183,255,225,255)];
    [self addChild:background z:-10];
    
    grassLayer = (P2_GrassLayer *)[CCBReader nodeGraphFromFile:@"P2_Grass.ccbi"];
    [self addChild:grassLayer z:1];
    
    monster = (P2_Monster *)[CCBReader nodeGraphFromFile:@"P2_Monster.ccbi"];
    [self addChild:monster z:0];
    monster.position = CGPointMake(512, -5);
    CCBAnimationManager* animationManager = monster.userObject;
    [animationManager runAnimationsForSequenceNamed:@"LittleJump"];
    
    firstLittleMonster = (P2_LittleMonster *)[CCBReader nodeGraphFromFile:@"P2_FirstLittlemonster.ccbi"];
    [self addChild:firstLittleMonster z:0];
    firstLittleMonster.position = CGPointMake(370, 0);
    [self performSelector:@selector(letFirstLittleMonsterJump) withObject:self afterDelay:0.2];
    
    secondLittleMonster = (P2_LittleMonster *)[CCBReader nodeGraphFromFile:@"P2_SecondLittlemonster.ccbi"];
    [self addChild:secondLittleMonster z:0];
    secondLittleMonster.position = CGPointMake(260, 0);
    [self performSelector:@selector(letSecondLittleMonsterJump) withObject:self afterDelay:0.4];

    
    flyObjectsOnScreen = [@[] mutableCopy];
    
    isFrameCounterShowed = NO;
    self.frameCounter = 1;
    isMusicToShow = YES;
    deltaCounter = 0;
    
    [self schedule:@selector(updateEveryDeltaTime:) interval:0.104325 - 0.016667];
    [self scheduleUpdate];
}

- (void)letFirstLittleMonsterJump
{
    CCBAnimationManager* firanimationManager = firstLittleMonster.userObject;
    firanimationManager.delegate = firstLittleMonster;
    [firanimationManager runAnimationsForSequenceNamed:@"LittleJump"];
}

- (void)letSecondLittleMonsterJump
{
    CCBAnimationManager* secanimationManager = secondLittleMonster.userObject;
    secanimationManager.delegate = secondLittleMonster;
    [secanimationManager runAnimationsForSequenceNamed:@"LittleJump"];
}

- (void)update:(ccTime)delta
{
//    CCNode* child;
//    NSMutableArray* objectsToRemove = [NSMutableArray array];
//    CCARRAY_FOREACH(self.children, child)
//    {
//        if ([child isKindOfClass:[P2_LittleFlyBoom class]])
//        {
//            P2_LittleFlyBoom* boom = (P2_LittleFlyBoom*)child;
//            if (boom.isScheduledForRemove)
//            {
//                [objectsToRemove addObject:boom];
//            }
//        }
//    }
//    for (P2_LittleFlyBoom* boom in objectsToRemove)
//    {
//        [self removeChild:boom cleanup:YES];
//        [boom release];
//    }
    
    int currentJumpFrame = [P2_CalculateHelper getMonsterCurrentJumpFrameBy:monster.currentJumpTime];
    float collisionHeight = [P2_CalculateHelper getTheMonsterCollisionHeightFrom:currentJumpFrame];
    for (P2_LittleFlyObjects * tempObjects in flyObjectsOnScreen) {
        if ( (fabsf((monster.position.x - tempObjects.position.x)) < 50 &&
              fabsf(monster.position.y - tempObjects.position.y) < collisionHeight + 50) ||
            (fabsf((monster.position.x - tempObjects.position.x)) < 125 &&
             fabsf(monster.position.y - tempObjects.position.y) < collisionHeight)) {
                
            [flyObjectsOnScreen removeObject:tempObjects];
            [tempObjects handleCollision];
            [monster handleCollision];
            break;
        }
    }
}

-(void)updateEveryDeltaTime:(ccTime)delta
{
    deltaCounter ++;
    if (deltaCounter == 10) {
        _frameCounter ++;
        deltaCounter = 0;
        isFrameCounterShowed = NO;
    }
    
    
    NSString * currentFrame = [NSString stringWithFormat:@"%d",_frameCounter];
//    NSLog(@"currentFrame is %@",currentFrame);

    
    if (_frameCounter == 41) {
        [[CDAudioManager sharedManager] rewindBackgroundMusic];
         _frameCounter = 1;
    }
    else if ([frameToShowCurrentFrame containsObject:currentFrame] && !isFrameCounterShowed){
        isFrameCounterShowed = YES;
        NSInteger musicType = [[musicTypeInFrame objectAtIndex:[frameToShowCurrentFrame indexOfObject:currentFrame]] integerValue];
        
//        NSLog(@"currentFrame is %@",currentFrame);
//        NSLog(@"musictype is %d",musicType);
        if (isMusicToShow) {
//        float isShowLittleFly = (float)arc4random() / 0x100000000;
//        if (isShowLittleFly > 0.5) {
            [self updateForAddingLittleFly:musicType];
//        }
            isMusicToShow = NO;
        }
        else {
//            NSString * boomMusicFilename = [NSString stringWithFormat:@"%d.mp3",musicType];
            isMusicToShow = YES;
//            [self performSelector:@selector(playMusic:) withObject:boomMusicFilename afterDelay:1.04];
        }
    }
}

- (void)playMusic:(NSString *)boomMusicFilename
{
    [[SimpleAudioEngine sharedEngine] playEffect:boomMusicFilename];
}

-(void)updateForAddingLittleFly:(NSInteger)musicType
{
//    if ([flyObjectsOnScreen count] < 5) {
        P2_LittleFlyObjects * littleFly = (P2_LittleFlyObjects *)[CCBReader nodeGraphFromFile:@"P2_LittleFly.ccbi"];
        littleFly.delegate = self;
        [littleFly setObjectFirstPosition];
        [self addChild:littleFly z:0];
        
//        static int colorIndex = 0;
//        colorIndex++;
//        if(colorIndex == [littleFly countOfColor])
//        {
//            colorIndex = 0;
//        }
        
        littleFly.musicType = musicType;
        
        ccColor3B color = [littleFly colorAtIndex:musicType];
        [littleFly setBodyColor:color];
        [flyObjectsOnScreen addObject:littleFly];
//    }
}


-(void)firstLittleMonsterJump
{
    firstLittleMonster.isFinishJump = NO;
    CCBAnimationManager* firstLittleMonsterAnimationManager = firstLittleMonster.userObject;
    [firstLittleMonsterAnimationManager runAnimationsForSequenceNamed:@"ReadyToJump"];
}

-(void)secondLittleMonsterJump
{
    secondLittleMonster.isFinishJump = NO;
    CCBAnimationManager* secondLittleMonsterAnimationManager = secondLittleMonster.userObject;
    [secondLittleMonsterAnimationManager runAnimationsForSequenceNamed:@"ReadyToJump"];
}

#pragma mark - Touch

-(void) ccTouchesBegan:(NSSet*)touches withEvent:(id)event
{
    //CCDirector* director = [CCDirector sharedDirector];
    for(UITouch* touch in touches)
    {
        if (monster.isFinishJump) {
            monster.isFinishJump = NO;
            CCBAnimationManager* animationManager = monster.userObject;
            [animationManager runAnimationsForSequenceNamed:@"ReadyToJump"];
            [monster monsterCloseEyesWhenReadyToJump];
            
            [self performSelector:@selector(firstLittleMonsterJump) withObject:nil afterDelay:0.2];
            [self performSelector:@selector(secondLittleMonsterJump) withObject:nil afterDelay:0.4];
        }
        //CGPoint touchLocation = [touch locationInView:director.openGLView];
        //CGPoint locationGL = [director convertToGL:touchLocation];
        //CGPoint locationInNodeSpace = [self convertToNodeSpace:locationGL];
        
    }
}

#pragma mark - LittleFlyDelegate

-(void)removeFromOnScreenArray:(P2_LittleFlyObjects *)littleFlyObject
{
    [flyObjectsOnScreen removeObject:littleFlyObject];
}

-(BOOL)isSamePositionWithOtherFlyObjects:(P2_LittleFlyObjects *)littleFlyObject
{
//    for (P2_LittleFlyObjects * tempLittleFly in flyObjectsOnScreen) {
//        if ( fabsf(tempLittleFly.position.x - littleFlyObject.position.x) < 100 ) {
//            NSLog(@"LittleFly position is same first is %f second is %f",tempLittleFly.position.x , littleFlyObject.position.x);
//            return YES;
//        }
//    }
    return NO;
}


@end
