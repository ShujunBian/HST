//
//  HelloWorldLayer.m
//  hst_p4
//
//  Created by wxy325 on 1/17/14.
//  Copyright cdi 2014. All rights reserved.
//

#import "P4GameLayer.h"
#import "AppDelegate.h"

#import "P4CloudLayer.h"
#import "P4Monster.h"
#import "P4Bottle.h"
#import "P4BottleOffset.h"

#import "CCSprite+getRect.h"

#import "MainMapHelper.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "CCBReader.h"
#import "CircleTransition.h"
#import "CCLayer+CircleTransitionExtension.h"
#import "WXYUtility.h"
#import "VolumnHelper.h"

#import "P4SwipeIndicator.h"
#import "P4HelpUi.h"

#import <CoreMotion/CoreMotion.h>

#define kP4FirstOpenKey @"kP4FirstOpenKey"

//#define BOTTLE_MOVE_DELAY 0.2f
#define BOTTLE_SCALE_X_MAX 1.2f
#define BOTTLE_SCALE_X_MIN 0.5f

#define BOTTLE_SCALE_X_ADD_RATE 1.03f
#define BOTTLE_SCALE_X_DECREASE_RATE 0.995f

#define BOTTLE_SHAKE_X 3.f
#define BOTTLE_SHAKE_Y 3.f
#define BOTTLE_SHAKE_MAX_X 10.f
#define BOTTLE_SHAKE_MAX_Y 10.f
#define BOTTLE_SHAKE_UPDATE_RATE 1.f / 30.f

#define SHAKE_BASE_RATE_X 45.f
#define SHAKE_BASE_RATE_Y 5.f
#define SHAKE_MOVE_BACK_COUNT_INIT 3


enum {
    P4NormalIndexBottle = 1,
    P4NormalIndexGround,
    P4NormalIndexTable,
    P4NormalIndexMonster
}P4NormalIndex;
enum {
    P4HelpShowedIndexUi = 7,
    P4HelpShowedIndexFocus = 8,
    P4HelpShowedIndexSwipe = 9
}P4HelpShowedIndex;

@interface P4GameLayer ()
- (void)monsterPressed:(P4Monster*)monster;


//Bottle Move
- (void)bottleMoveDelta:(P4BottleOffset*)offset;
- (void)bottleMoveBack;
- (void)updateBottlePositionWithAnimation:(BOOL)fAnimate;


@property (strong, nonatomic) CCArray* monstersArray;

@property (assign, nonatomic) CGPoint pourWaterPoint;
@property (assign, nonatomic) CGPoint pourWaterPointLeft;
@property (assign, nonatomic) CGPoint pourWaterPointRight;

@property (assign, nonatomic) BOOL isTouchBottle;
@property (assign, nonatomic) CGPoint bottleTouchPointNow;
@property (assign, nonatomic) CGPoint bottleTouchPoint;
@property (assign, nonatomic) CGPoint bottleTouchPreviousPoint;
@property (assign, nonatomic) CGPoint bottleTouchOriginPoint;


@property (assign, nonatomic) CGPoint bottlePositoinOrigin;


@property (assign, nonatomic) float bottleOffsetX;
@property (assign, nonatomic) float bottleOffsetY;

@property (assign, nonatomic) CGPoint tablePrePosition;


//////////Shake
@property (strong, nonatomic) P4Monster* shakeMonster;
//@property (strong, nonatomic) CCParticleSystemQuad* shakeSpray;
@property (assign, nonatomic) CGPoint sprayOriginPosition;
@property (assign, nonatomic) float shakeX;
@property (assign, nonatomic) float shakeY;

@property (strong, nonatomic) MainMapHelper* helper;



//Sound Effect Name

//@property (strong, nonatomic) NSArray* monsterShakeEffectNames;
@property (assign, nonatomic) ALuint currentShakeEffectId;

//Motion
@property (strong, nonatomic) CMMotionManager* motionManager;
@property (assign, nonatomic) BOOL isShakeDevice;
@property (assign, nonatomic) BOOL disableShakeForMoveBack;
@property (assign, nonatomic) int shakeMoveBackCount;

//UI
@property (strong, nonatomic) P4HelpUi* helpUi;
@property (strong, nonatomic) P4SwipeIndicator* swipeIndicator;
@property (assign, nonatomic) int iUiState;

//Other
@property (strong, nonatomic) CCSprite* groundSprite;

@end


@implementation P4GameLayer

@synthesize backgroundSprite = _backgroundSprite;

- (void)setIsMonsterAnimated:(BOOL)isMonsterAnimated
{
    _isMonsterAnimated = isMonsterAnimated;
}
- (BOOL)someMonsterAnimated
{
    for (P4Monster* m in self.monstersArray)
    {
        if (m.isAnimated)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Static Method
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	P4GameLayer *layer = [P4GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

#pragma mark - Init
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
	}
	return self;
}

#pragma mark - Life Cycle
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    self.helpUi = nil;
    self.swipeIndicator = nil;
    self.groundSprite = nil;
	[super dealloc];
    [WXYUtility clearImageCachedOfPlist:@"p4_resource"];

}

- (void)onEnter
{
    [super onEnter];

    [self.cloudLayer startAnimation];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"p4_background.mp3" loop:YES];
    [VolumnHelper sharedVolumnHelper].isPlayingWordBgMusic = NO;
    
//    CCRenderTexture* te = [[CCRenderTexture alloc] initWithWidth:300 height:300 pixelFormat:kCCTexture2DPixelFormat_Default];
//    [te beginWithClear:255.f g:0 b:0 a:255.f];
//    [te end];
//    CCSprite* s = [CCSprite spriteWithTexture:te.sprite.texture];
//    [self addChild:s];
    [self showScene];
    
    self.motionManager = [[[CMMotionManager alloc] init] autorelease];
    /*
    if (self.motionManager.deviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval = 0.02f;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self handleMotion:motion error:error];
        }];
    }
     */
    self.disableShakeForMoveBack = NO;
     
}

- (void)handleMotion:(CMDeviceMotion*)motion error:(NSError*)error
{
    if (self.disableShakeForMoveBack) {
        return;
    }
    int orientFactor = 1;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        orientFactor = 1;
    }
    else
    {
        orientFactor = -1;
    }

    if ((ABS(motion.userAcceleration.x) > 0.14f || ABS(motion.userAcceleration.y) > 0.14f) && !self.isTouchBottle && !self.someMonsterAnimated )
    {
        self.shakeMoveBackCount = SHAKE_MOVE_BACK_COUNT_INIT;
        self.isShakeDevice = YES;
        NSLog(@"%.2f\t%.2f\t%.2f",motion.userAcceleration.x,motion.userAcceleration.y, motion.userAcceleration.z);
        
        //home键在左边时
        //x 上+ 下-
        //y 左摇- 右摇+
        P4BottleOffset* offset = [[[P4BottleOffset alloc] init] autorelease];
        float limitMotion = 0.15;
        float deltaX = motion.userAcceleration.x > limitMotion? limitMotion : motion.userAcceleration.x;
        deltaX = deltaX < -limitMotion ? -limitMotion : deltaX;
        float deltaY = motion.userAcceleration.y > limitMotion? limitMotion : motion.userAcceleration.y;
        deltaY = deltaY < -limitMotion ? -limitMotion : deltaY;
        offset.deltaX = orientFactor * SHAKE_BASE_RATE_X * deltaY;
        offset.deltaY = orientFactor * SHAKE_BASE_RATE_Y * deltaX;
        [self bottleMoveDelta:offset];
    }
    else
    {
        --self.shakeMoveBackCount;
        if (!self.isTouchBottle && self.isShakeDevice && self.shakeMoveBackCount <= 0 )
        {
            [self bottleMoveBack];
            self.isShakeDevice = NO;
        }
    }
}

- (void)onExit
{
//    [self removeAllChildrenWithCleanup:YES];
//    self.shakeMonster = nil;
    [super onExit];
    
    self.helper = nil;
    [self.monstersArray removeAllObjects];
    self.monstersArray = nil;
    self.cloudLayer = nil;
    self.greenMonster = nil;
    self.yellowMonster = nil;
    self.purpleMonster = nil;
    self.blueMonster = nil;
    self.redMonster = nil;
    self.bottle = nil;
    self.backgroundSprite = nil;
    self.shakeSpray = nil;
    self.shakeMonster = nil;
//    self.monsterShakeEffectNames = nil;
    self.table = nil;
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
    
}

- (void)onExitTransitionDidStart
{
    [super onExitTransitionDidStart];
//    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void) didLoadFromCCB
{
    //cocosbuilder retain
    [self.backgroundSprite retain];
    [self.cloudLayer retain];
    [self.bottle retain];
    [self.greenMonster retain];
    [self.yellowMonster retain];
    [self.purpleMonster retain];
    [self.blueMonster retain];
    [self.redMonster retain];
    [self.table retain];
    [self.helpUi retain];
    [self.swipeIndicator retain];
    [self.groundSprite retain];
    
    self.helper = [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 727.0)];

//Monster Init
    self.monstersArray = [[[CCArray alloc] init] autorelease];
    //设置monsters数组
    [self.monstersArray addObject:self.greenMonster];
    [self.monstersArray addObject:self.yellowMonster];
    [self.monstersArray addObject:self.purpleMonster];
    [self.monstersArray addObject:self.blueMonster];
    [self.monstersArray addObject:self.redMonster];
    
    //设置monster type
    for (int i = 0; i < self.monstersArray.count; i++)
    {
        P4Monster* monster = [self.monstersArray objectAtIndex:i];
        monster.type = (P4MonsterType)i;
    }
    
    for (P4Monster* monster in self.monstersArray)
    {
        [monster prePositionInit];
    }
    self.greenMonster.waterColor = ccc3(68.f, 255.f, 25.f);
    self.greenMonster.selectedSoundEffectName = @"p4_monster1.mp3";
    self.yellowMonster.waterColor = ccc3(255.f, 252.f, 62.f);
    self.yellowMonster.selectedSoundEffectName = @"p4_monster2.mp3";
    self.purpleMonster.waterColor = ccc3(255.f, 97.f, 242.f);
    self.purpleMonster.selectedSoundEffectName = @"p4_monster3.mp3";
    self.blueMonster.waterColor = ccc3(50.f, 248.f, 255.f);
    self.blueMonster.selectedSoundEffectName = @"p4_monster4.mp3";
    self.redMonster.waterColor = ccc3(254.f, 70.f, 100.f);
    self.redMonster.selectedSoundEffectName = @"p4_monster5.mp3";

//    self.monsterShakeEffectNames = @[@"p4_monster_shake.mp3",@"p4_monster_shake2.mp3"];
    self.currentShakeEffectId = 0;
    
    self.isMonsterAnimated = NO;
    self.isTouchBottle = NO;
    self.bottleTouchPoint = CGPointZero;
    
    CGRect bottleRect = [self.bottle.bottleMain getRect];
    
    self.pourWaterPointLeft = CGPointMake(bottleRect.origin.x + bottleRect.size.width / 2 - 100, bottleRect.origin.y + bottleRect.size.height + 70);
    self.pourWaterPointRight = CGPointMake(bottleRect.origin.x + bottleRect.size.width / 2 + 95, bottleRect.origin.y + bottleRect.size.height + 70);

    
    self.bottleOffsetX = 0;
    self.bottleOffsetY = 0;
    self.bottlePositoinOrigin = self.bottle.position;
    
    self.bottle.gameLayer = self;
    
    self.bottleTouchOriginPoint = CGPointZero;
    self.bottleTouchPreviousPoint = CGPointZero;
    self.bottleTouchPoint = CGPointZero;
    self.bottleTouchPointNow = CGPointZero;
 
    self.tablePrePosition = self.table.position;
    
//    [self schedule:@selector(scaleUpdate)];
//    [self schedule:@selector(scaleUpdateHelper) interval:0.018f];
    
    //Reorder
    [self reorderNormalIndex];
    
    //Help Ui
    //FirstOpen
    if ([self checkIsFirstOpen] )
    {
        [self setIsFirstOpen:NO];
        //first open
        self.iUiState = 1;
        [self handleShowUi:self.iUiState withAnimation:NO];
    }
    else
    {
        self.iUiState = 0;
        [self.helpUi hideAllUiWithAnimation:NO];
    }
    [self.swipeIndicator hideWithAnimation:NO];
    [self reorderChild:self.helper.restartMenu z:P4HelpShowedIndexUi - 1];
}

#pragma mark - Gesture
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCDirector* director = [CCDirector sharedDirector];

    for(UITouch* touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:director.view];
        CGPoint locationGL = [director convertToGL:touchLocation];
        CGPoint locationInNodeSpace = [self convertToNodeSpace:locationGL];
        
        for (P4Monster* monster in self.monstersArray)
        {
            if (CGRectContainsPoint([monster getRect], locationInNodeSpace))
            {
                [self monsterPressed:monster];
            }
        }
        if (CGRectContainsPoint([self.bottle getRect], locationInNodeSpace) && !self.someMonsterAnimated && (self.iUiState != 1) && (self.iUiState != 2))
        {
            self.isTouchBottle = YES;
            self.bottleTouchPoint = locationInNodeSpace;
            self.bottleTouchOriginPoint = locationInNodeSpace;
            self.bottleTouchPointNow = locationInNodeSpace;
        }
    }
}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((self.iUiState == 1) || (self.iUiState == 2))
    {
        return;
    }
    CCDirector* director = [CCDirector sharedDirector];
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:director.view];
    CGPoint locationGL = [director convertToGL:touchLocation];
    CGPoint locationInNodeSpace = [self convertToNodeSpace: locationGL];
    if (self.isTouchBottle)
    {
        if (self.iUiState == 3)
        {
            self.iUiState = 0;
            [self.swipeIndicator hideWithAnimation:YES];
            [self.helpUi showShadow:NO withAnimation:YES];
        }
        
        P4BottleOffset* offset = [self getOffsetByTouchPoint:locationInNodeSpace];
        /*
        //Move
        float offsetX = locationInNodeSpace.x - self.bottleTouchOriginPoint.x;
        float offsetY = locationInNodeSpace.y - self.bottleTouchOriginPoint.y;
        if (offsetX >= 0)
        {
            offsetX = sqrtf(offsetX);
        }
        else
        {
            offsetX = -sqrtf(-offsetX);
        }
        if (offsetY >= 0)
        {
            offsetY = sqrtf(offsetY);
        }
        else
        {
            offsetY = -sqrtf(-offsetY);
        }
        offsetX = 5 * offsetX;
        offsetY = 2 * offsetY;
        
        P4BottleOffset* offset = [[P4BottleOffset alloc] init];
//        offset.deltaX = locationInNodeSpace.x - self.bottleTouchPoint.x;
//        offset.deltaY = locationInNodeSpace.y - self.bottleTouchPoint.y;
//        [self bottleMoveDelta:offset];
        offset.deltaX = offsetX - self.bottleOffsetX;
        offset.deltaY = offsetY - self.bottleOffsetY;
        */
        [self bottleMoveDelta:offset];
        
//        [self performSelector:@selector(bottleMoveDelta:) withObject:offset afterDelay:BOTTLE_MOVE_DELAY];
        
        //Update Touch Point
        self.bottleTouchPreviousPoint = self.bottleTouchPoint;
        self.bottleTouchPoint = self.bottleTouchPointNow;
        self.bottleTouchPointNow = locationInNodeSpace;
    }
    else
    {
        if (CGRectContainsPoint([self.bottle getRect], locationInNodeSpace) && !self.someMonsterAnimated)
        {
            
            self.isTouchBottle = YES;
            self.bottleTouchPoint = locationInNodeSpace;
            self.bottleTouchOriginPoint = locationInNodeSpace;
            self.bottleTouchPointNow = locationInNodeSpace;
        }
    }
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    if (self.isTouchBottle)
    {
        self.isTouchBottle = NO;
        [self bottleMoveBack];

//        [self performSelector:@selector(bottleMoveBack) withObject:nil afterDelay:BOTTLE_MOVE_DELAY];
        [[self.bottle runAction:[[CCScaleTo alloc] initWithDuration:0.2f scale:1.f]] autorelease];
        
        self.bottleTouchOriginPoint = CGPointZero;
        self.bottleTouchPreviousPoint = CGPointZero;
        self.bottleTouchPoint = CGPointZero;
        self.bottleTouchPointNow = CGPointZero;
    }
}

#pragma mark - Action
- (void)hideMonstersExcept:(P4Monster*)monster
{
    
    
    for (P4Monster* m in self.monstersArray)
    {
        if (m != monster)
        {
            CGPoint toPosition = ccp(m.position.x, m.position.y - 150);
            CCActionInterval* moveTo = [CCMoveTo actionWithDuration:1.f position:toPosition];
            CCActionInterval* easeTo = [CCEaseExponentialOut actionWithAction:moveTo];
            CCCallBlock* callBlock = [CCCallBlock actionWithBlock:^{
                m.isHideBelow = YES;
            }];
            
            [m runAction:[CCSequence actionWithArray:@[callBlock, easeTo]]];
        }
    }
    CGPoint toPosition = ccp(self.tablePrePosition.x, self.tablePrePosition.y - 150);
    CCActionInterval* moveTo = [CCMoveTo actionWithDuration:1.f position:toPosition];
    CCActionInterval* easeTo = [CCEaseExponentialOut actionWithAction:moveTo];
    [self.table runAction:easeTo];
    
}
- (void)showMonstersExcept:(P4Monster*)monster totalDuration:(float)duration
{
    for (P4Monster* m in self.monstersArray)
    {
        if (m != monster && !m.isAnimated)
        {
            float moveDuration = 1.f;
            
            float delayDuration = duration > moveDuration? (duration - moveDuration) : 0;
            moveDuration = duration - delayDuration;
            
            
//            CCDelayTime* delay = [CCDelayTime actionWithDuration:delayDuration];
            CCActionInterval* moveTo = [CCMoveTo actionWithDuration:moveDuration position:m.prePosition];

            CCActionInterval* easeTo = [CCEaseExponentialOut actionWithAction:moveTo];
            
            CCCallBlock* callBlock = [CCCallBlock actionWithBlock:^{
                m.isHideBelow = NO;
            }];
            
            [m runAction:[CCSequence actionWithArray:@[easeTo, callBlock]]];
//            [m runAction:[CCSequence actionWithArray:@[
//                                                       delay,
//                                                       easeTo, callBlock]]];
        }
    }
    float moveDuration = 1.f;
    
    float delayDuration = duration > moveDuration? (duration - moveDuration) : 0;
    moveDuration = duration - delayDuration;
    
    
    //            CCDelayTime* delay = [CCDelayTime actionWithDuration:delayDuration];
    CCActionInterval* moveTo = [CCMoveTo actionWithDuration:moveDuration position:self.tablePrePosition];
    CCActionInterval* easeTo = [CCEaseExponentialOut actionWithAction:moveTo];
    [self.table runAction:easeTo];
    
    
    
    
    CCCallBlock* callBlock = [CCCallBlock actionWithBlock:^{
        self.isMonsterAnimated = NO;
    }];
    
    [self runAction:[CCSequence
                     actionWithArray:
                     @[[CCDelayTime actionWithDuration:.4f],
                       callBlock
                       ]]];
    
}

- (void)monsterPressed:(P4Monster*)monster
{
    if (self.isMonsterAnimated || monster.isEmpty || monster.isAnimated || self.bottle.isFull || self.isTouchBottle || self.iUiState == 3)
    {
        return;
    }
    
    if (self.iUiState == 1 || self.iUiState == 2)
    {
        [self.helpUi hideAllUiWithAnimation:YES];
        ++self.iUiState;
    }
    
    [monster playSelectSoundEffect];
    
    
    __unsafe_unretained P4GameLayer *weakSelf = self;
    self.isMonsterAnimated = YES;
    monster.isAnimated = YES;
    [monster beginUpdateWater];
    [self.bottle updateRenewButton];
    
    CCFiniteTimeAction* callOpen = [[[CCCallBlock alloc] initWithBlock:^{
        [weakSelf.bottle capOpen];
    }] autorelease];
    float rotateRadiu = 105.f;
    switch (monster.type)
    {
        case P4MonsterTypeGreen:
        case P4MonsterTypeYellow:
        case P4MonsterTypePurple:
        {
            self.pourWaterPoint = self.pourWaterPointLeft;
            break;
        }
        case P4MonsterTypeBlue:
        case P4MonsterTypeRed:
        default:
        {
            self.pourWaterPoint = self.pourWaterPointRight;
            rotateRadiu = -105.f;
            break;
        }
    }

    ccBezierConfig config;
    config.endPosition = self.pourWaterPoint;
    
//    int iMonsterIndex = [self.monstersArray indexOfObject:monster];
    float moveDuration = 1.2f;

    switch (monster.type)
    {
        case 0:
        {
            config.controlPoint_1 = ccp(monster.position.x - 200, monster.position.y + 300);
            config.controlPoint_2 = ccp(self.pourWaterPoint.x - 200, self.pourWaterPoint.y + 200);
            break;
        }
        case 1:
        {
            config.controlPoint_1 = ccp(monster.position.x - 250, monster.position.y + 100);
            config.controlPoint_2 = ccp(self.pourWaterPoint.x - 250, self.pourWaterPoint.y + 150);
            break;
        }
        case 2:
        {
            config.controlPoint_1 = ccp(monster.position.x - 300, monster.position.y + 200);
            config.controlPoint_2 = ccp(self.pourWaterPoint.x - 100, self.pourWaterPoint.y + 100);
            break;
        }
        case 3:
        {
            config.controlPoint_1 = ccp(monster.position.x + 250, monster.position.y + 100);
            config.controlPoint_2 = ccp(self.pourWaterPoint.x + 250, self.pourWaterPoint.y + 150);
            break;
        }
        case 4:
        default:
        {
            config.controlPoint_1 = ccp(monster.position.x + 200, monster.position.y + 300);
            config.controlPoint_2 = ccp(self.pourWaterPoint.x + 200, self.pourWaterPoint.y + 200);
            break;
        }
    }
    
    CCActionInterval* bezierTo = [[[CCBezierTo alloc] initWithDuration:moveDuration bezier:config] autorelease];
    CCFiniteTimeAction* callHideMonsters = [[[CCCallBlock alloc] initWithBlock:^{
        [weakSelf hideMonstersExcept:monster];
    }] autorelease];
    float delayDuration = 0.5f;
    
    CCDelayTime* rotateDelay = [CCDelayTime actionWithDuration:delayDuration];
    
    CCActionInterval* rotate = [[[CCRotateTo alloc] initWithDuration:(moveDuration - delayDuration) angle:rotateRadiu] autorelease];
    
    CCActionInterval* spawn = [CCSpawn actionWithArray:@[bezierTo, [CCSequence actionOne:rotateDelay two:rotate]]];
    
    CCCallBlock* outToPlaySound = [CCCallBlock actionWithBlock:^{
//        [[SimpleAudioEngine sharedEngine] playEffect:@"p4_monster_fly.mp3"];
    }];
    
    CCActionInterval* outTo = [CCEaseSineOut actionWithAction:spawn];
    
    
    CCFiniteTimeAction* beginAddWater = [[[CCCallBlock alloc] initWithBlock:^{
        [[SimpleAudioEngine sharedEngine] playEffect:@"p4_water_flow.mp3"];
//        int effectIndex = (int)(CCRANDOM_0_1() * 2);
//        effectIndex = effectIndex != 2? effectIndex : 1;
//        self.currentSHakeEffectId = [[SimpleAudioEngine sharedEngine] playEffect:self.monsterShakeEffectNames[effectIndex]];
        
        [self.bottle startWaterIn:monster];
    }] autorelease];
    
    
    //开始振动
    CCCallBlock* beginShake = [CCCallBlock actionWithBlock:^{
        [weakSelf monsterBeginShake:monster];
    }];
    
    CCFiniteTimeAction* delay2 = [[[CCDelayTime alloc] initWithDuration:0.7f] autorelease];
    
    
    CCFiniteTimeAction* delay2_ = [[[CCDelayTime alloc] initWithDuration:0.3f] autorelease];
    
    //停止振动
    CCCallBlock* endShake = [CCCallBlock actionWithBlock:^{
        [weakSelf monsterEndShake:monster];
    }];
    
    
    CCFiniteTimeAction* endAddWater = [[[CCCallBlock alloc] initWithBlock:^{
        [[SimpleAudioEngine sharedEngine] stopEffect:self.currentShakeEffectId];
        self.currentShakeEffectId = 0;
        
        [self.bottle stopWaterIn];
    }] autorelease];
    

    CCFiniteTimeAction* callClose = [[[CCCallBlock alloc] initWithBlock:^{
        [weakSelf.bottle capClose];
    }] autorelease];
    

//    CCActionInterval* moveBack = [[CCMoveTo alloc] initWithDuration:1.f position:monster.prePosition];
    
    ccBezierConfig configBack;
    if (!self.bottle.isAboutToFull)
    {
        configBack.endPosition = monster.prePosition;
    }
    else
    {
        configBack.endPosition = ccp(monster.prePosition.x, monster.prePosition.y - 150.f);
    }
    
    float moveBackDuration = 1.2f;
    float rotateBackDuration = .5f;
    switch (monster.type)
    {
        case 0:
        {
            configBack.controlPoint_1 = ccp(self.pourWaterPoint.x - 300, self.pourWaterPoint.y + 100);
            configBack.controlPoint_2 = ccp(monster.prePosition.x - 100, monster.position.y + 300);
            moveBackDuration = 1.5f;
            break;
        }
        case 1:
        {
            configBack.controlPoint_1 = ccp(self.pourWaterPoint.x - 200, self.pourWaterPoint.y + 100);
            configBack.controlPoint_2 = ccp(monster.prePosition.x - 200, monster.position.y + 200);

            break;
        }
        case 2:
        {
            configBack.controlPoint_1 = ccp(self.pourWaterPoint.x - 200, self.pourWaterPoint.y + 100);
            configBack.controlPoint_2 = ccp(monster.prePosition.x - 300, monster.position.y + 200);

            break;
        }
        case 3:
        {
            configBack.controlPoint_1 = ccp(self.pourWaterPoint.x + 200, self.pourWaterPoint.y + 100);
            configBack.controlPoint_2 = ccp(monster.prePosition.x + 200, monster.position.y + 200);
            break;
        }
        case 4:
        default:
        {
            configBack.controlPoint_1 = ccp(self.pourWaterPoint.x + 300, self.pourWaterPoint.y + 100);
            configBack.controlPoint_2 = ccp(monster.prePosition.x + 100, monster.position.y + 300);
            moveBackDuration = 1.5f;
            break;
        }
    }
    
    CCActionInterval* bezierBack = [[[CCBezierTo alloc] initWithDuration:moveBackDuration bezier:configBack] autorelease];
    
    CCActionInterval* rotateBack = [[[CCRotateTo alloc] initWithDuration:rotateBackDuration angle:0] autorelease];
    CCSpawn* spawnBack = [CCSpawn actionWithArray:@[bezierBack, rotateBack]];
    
    CCFiniteTimeAction* callShowMonsters = [[[CCCallBlock alloc] initWithBlock:^{
        
        if (!self.bottle.isFull)
        {
            [weakSelf showMonstersExcept:monster totalDuration:1.2f];
        }
        else
        {
            CCCallBlock* callBlock = [CCCallBlock actionWithBlock:^{
                self.isMonsterAnimated = NO;
            }];
            
            [self runAction:[CCSequence
                             actionWithArray:
                             @[[CCDelayTime actionWithDuration:.4f],
                               callBlock
                               ]]];
        }

    }] autorelease];
    
    CCActionInterval* easeOutBack = [CCEaseSineOut actionWithAction:spawnBack];
//    CCActionInterval* easeOutBack = [CCEaseOut actionWithAction:spawnBack rate:1.05f];
    
    CCFiniteTimeAction* finish = [[[CCCallBlock alloc] initWithBlock:^{
//        weakSelf.isMonsterAnimated = NO;
        [monster endUpdateWater];
        monster.isAnimated = NO;
        [self.bottle updateRenewButton];
        
        if (!self.someMonsterAnimated)
        {
            [self handleShowUi:self.iUiState withAnimation:YES];
        }
    }] autorelease];
    
    CCSequence* sequence = [CCSequence actions:callOpen, callHideMonsters, outToPlaySound, outTo, beginAddWater, beginShake, delay2, callShowMonsters, delay2_, endShake, endAddWater, callClose,  easeOutBack, finish, nil];
    
    [monster runAction:sequence];
}

- (void)monsterBeginShake:(P4Monster*)monster
{
    self.shakeMonster = monster;
    switch (monster.type)
    {
        case P4MonsterTypeGreen:
        case P4MonsterTypeYellow:
        case P4MonsterTypePurple:
        {
            self.shakeSpray = self.bottle.waterInLeft;
            break;
        }
        case P4MonsterTypeBlue:
        case P4MonsterTypeRed:
        default:
        {
            self.shakeSpray = self.bottle.waterInRight;
            break;
        }
    }
    
    int repeatTime = 1;
    int moveLength = 15;
    CCMoveBy* monsterMoveBy1 = [CCMoveBy actionWithDuration:1.f / repeatTime position:ccp(0,moveLength * 2)];
//    CCMoveBy* monsterMoveBy2 = [CCMoveBy actionWithDuration:1.f / repeatTime position:ccp(0,-moveLength * 2)];
//    CCMoveBy* monsterMoveBy3 = [CCMoveBy actionWithDuration:0.5f / repeatTime position:ccp(0,-moveLength)];
    CCSequence* monsterMoveSequence =
    [CCSequence actions:
     [CCEaseSineInOut actionWithAction:monsterMoveBy1],
//     [CCEaseSineInOut actionWithAction:monsterMoveBy2],
//     [CCEaseSineIn actionWithAction:monsterMoveBy3],
     nil];
    CCRepeat* monsterMoveRepeat = [CCRepeat actionWithAction:monsterMoveSequence times:repeatTime];
    CCRepeat* sprayMoveRepeat = [[monsterMoveRepeat copy] autorelease];
    [self.shakeMonster runAction:monsterMoveRepeat];
    [self.shakeSpray runAction:sprayMoveRepeat];
    
//    return;
//    self.sprayOriginPosition = self.shakeSpray.position;
//    [self schedule:@selector(monsterShakeUpdate:) interval:BOTTLE_SHAKE_UPDATE_RATE];
}

- (void)monsterEndShake:(P4Monster*)monster
{
    return;
    
    
    [self unschedule:@selector(monsterShakeUpdate:)];
    self.shakeX = 0;
    self.shakeY = 0;
    self.shakeSpray = nil;
    self.shakeMonster = nil;
    [self updateShakeMonsterAndSprayPosition];
}

- (void)monsterShakeUpdate:(ccTime)deltaTime
{
    float shakeX = BOTTLE_SHAKE_X * (CCRANDOM_0_1() - 0.5);
    float shakeY = BOTTLE_SHAKE_Y * (CCRANDOM_0_1() - 0.5);
    
    self.shakeX += shakeX;
    self.shakeY += shakeY;
    self.shakeX = self.shakeX > BOTTLE_SHAKE_MAX_X? BOTTLE_SHAKE_MAX_X: self.shakeX;
    self.shakeX = self.shakeX < -BOTTLE_SHAKE_MAX_X ? -BOTTLE_SHAKE_MAX_X : self.shakeX;
    self.shakeY = self.shakeY > BOTTLE_SHAKE_MAX_Y? BOTTLE_SHAKE_MAX_Y: self.shakeY;
    self.shakeY = self.shakeY < -BOTTLE_SHAKE_MAX_Y? -BOTTLE_SHAKE_MAX_Y: self.shakeY;
    [self updateShakeMonsterAndSprayPosition];
}

- (void)updateShakeMonsterAndSprayPosition
{
    self.shakeMonster.position = ccp(self.pourWaterPoint.x + self.shakeX,self.pourWaterPoint.y + self.shakeY);
    self.shakeSpray.position = ccp(self.sprayOriginPosition.x + self.shakeX,self.sprayOriginPosition.y + self.shakeY);
}

#pragma mark - Bottle Move
- (void)bottleMoveDelta:(P4BottleOffset*)offset
{
    self.bottleOffsetX += offset.deltaX;
    self.bottleOffsetY += offset.deltaY;
    [self updateBottlePositionWithAnimation:NO];
    [self.bottle bottleMoveWithDeltaX:offset.deltaX deltaY:offset.deltaY];
}
- (void)bottleMoveBack
{
    self.disableShakeForMoveBack = YES;
    float newX = 2 * self.bottleTouchPointNow.x - self.bottleTouchPoint.x;
    float newY = 2 * self.bottleTouchPointNow.y - self.bottleTouchPoint.y;
    P4BottleOffset* newOffset = [self getOffsetByTouchPoint:ccp(newX,newY)];
    float newDelay = sqrt( newOffset.deltaX * newOffset.deltaX + newOffset.deltaY * newOffset.deltaY) / 300.f;
    
    CCMoveBy* newBy = [[[CCMoveBy alloc] initWithDuration:newDelay position:ccp(newOffset.deltaX,newOffset.deltaY)] autorelease];
    CCEaseOut* newOut = [[[CCEaseOut alloc] initWithAction:newBy rate:1.f] autorelease];
    
    float delay = sqrt(self.bottleOffsetX * self.bottleOffsetX + self.bottleOffsetY * self.bottleOffsetY) / 200.f;
    CCMoveTo* moveBack = [[[CCMoveTo alloc] initWithDuration:delay position:ccp(0,0)] autorelease];

    CCEaseSineInOut* backInOut = [[[CCEaseSineInOut alloc] initWithAction:moveBack] autorelease];
//                                                                    rate:2.5f];
    [self.bottle stopAllActions];
    [self.bottle runAction:[[[CCSequence alloc] initOne:newOut two:backInOut] autorelease]];
    self.bottleOffsetX = 0;
    self.bottleOffsetY = 0;
    
    self.isTouchBottle = NO;
    self.bottleTouchPoint = CGPointZero;
    
//    [self updateBottlePositionWithAnimation:YES];
    [self.bottle bottleMoveBack:delay];
    [self performSelector:@selector(resumeDisableShakeForMoveBack) withObject:nil afterDelay:delay];
}
- (void)resumeDisableShakeForMoveBack
{
    self.disableShakeForMoveBack = NO;
}

- (void)updateBottlePositionWithAnimation:(BOOL)fAnimate
{
    CGPoint pos = ccp(self.bottlePositoinOrigin.x + self.bottleOffsetX, self.bottlePositoinOrigin.y + self.bottleOffsetY);
    if (fAnimate)
    {
        [self.bottle runAction:[[CCMoveTo alloc] initWithDuration:0.5f position:pos]];
    }
    else
    {
        self.bottle.position = pos;
    }
}

#pragma mark - Monsters Renew
- (void)monstersRenew
{
//    float time = self.bottle.addCount * 0.65f;
//        CCCallBlock* callBlock1 = [CCCallBlock actionWithBlock:^{
//            [self hideMonstersExcept:nil];
//        }];
    
//        CCDelayTime* delay = [CCDelayTime actionWithDuration:time - 1.f];
//        CCCallBlock* callBlock2 = [CCCallBlock actionWithBlock:^{
//            [self showMonstersExcept:nil totalDuration:1.f];
//        }];
//        [self runAction:[CCSequence actions:
//                         callBlock1,
//                         delay, callBlock2, nil]];
    [self showMonstersExcept:nil totalDuration:1.f];

    for (P4Monster* monster in self.monstersArray)
    {
        [monster startWaterFull];
    }
}
- (void)monstersRenewEnd
{

}

#pragma mark - Scale Update
- (void)scaleUpdateHelper
{
    self.bottleTouchPreviousPoint = self.bottleTouchPoint;
    self.bottleTouchPoint = self.bottleTouchPointNow;

}
- (void)scaleUpdate
{
    if (self.isTouchBottle)
    {
        //Scale
        float speed1 = 0.f, speed2 = 0.f;
        if (CGPointEqualToPoint(CGPointZero, self.bottleTouchPreviousPoint))
        {
            speed1 = 0.f;
        }
        else
        {
            speed1 = self.bottleTouchPoint.x - self.bottleTouchPreviousPoint.x;
        }
        speed2 = self.bottleTouchPointNow.x - self.bottleTouchPoint.x;
        
        CCLOG(@"speed1:%f, speed2:%f",speed1, speed2);
        
        float deltaSpeed = ABS(speed2 - speed1) / 7;
        
        
        float scaleAddRate = powf(BOTTLE_SCALE_X_ADD_RATE, deltaSpeed);
        float scaleDeceaseRate = powf(BOTTLE_SCALE_X_DECREASE_RATE, deltaSpeed);
        
        if ( (ABS(speed1) < 0.001f  && ABS(speed2) < 0.001f) || (ABS(speed1 - speed2) < 0.01f))
        {
            if (self.bottle.scaleX > 1)
            {

                self.bottle.scaleX = self.bottle.scaleX * BOTTLE_SCALE_X_DECREASE_RATE > 1? self.bottle.scaleX * BOTTLE_SCALE_X_DECREASE_RATE : 1;
            }
            else if (self.bottle.scaleX < 1)
            {
                self.bottle.scaleX = self.bottle.scaleX * BOTTLE_SCALE_X_ADD_RATE < 1? self.bottle.scaleX * BOTTLE_SCALE_X_ADD_RATE : 1;
            }
        }
        else if (speed1 * speed2 > 0)
        {
            if (abs(speed2) > abs(speed1))
            {
                //加速 变大
                float pScaleX = self.bottle.scaleX;
                self.bottle.scaleX = pScaleX * scaleAddRate < BOTTLE_SCALE_X_MAX ? pScaleX * scaleAddRate : BOTTLE_SCALE_X_MAX;
            }
            else
            {
                //减速 变小
                float pScaleX = self.bottle.scaleX;
                self.bottle.scaleX = pScaleX * scaleDeceaseRate > BOTTLE_SCALE_X_MIN ? pScaleX * scaleDeceaseRate : BOTTLE_SCALE_X_MIN;
            }
        }
        else if (speed1 * speed2 < 0)
        {
            //减速 变小
            float pScaleX = self.bottle.scaleX;
            self.bottle.scaleX = pScaleX * scaleDeceaseRate > BOTTLE_SCALE_X_MIN ? pScaleX * scaleDeceaseRate : BOTTLE_SCALE_X_MIN;
        }
    }

}

- (P4BottleOffset*)getOffsetByTouchPoint:(CGPoint)locationInNodeSpace
{
    //Move
    float offsetX = locationInNodeSpace.x - self.bottleTouchOriginPoint.x;
    float offsetY = locationInNodeSpace.y - self.bottleTouchOriginPoint.y;
    if (offsetX >= 0)
    {
        offsetX = sqrtf(offsetX);
    }
    else
    {
        offsetX = -sqrtf(-offsetX);
    }
    if (offsetY >= 0)
    {
        offsetY = sqrtf(offsetY);
    }
    else
    {
        offsetY = -sqrtf(-offsetY);
    }
    offsetX = 5 * offsetX;
    offsetY = 2 * offsetY;
    
    P4BottleOffset* offset = [[[P4BottleOffset alloc] init] autorelease];
    //        offset.deltaX = locationInNodeSpace.x - self.bottleTouchPoint.x;
    //        offset.deltaY = locationInNodeSpace.y - self.bottleTouchPoint.y;
    //        [self bottleMoveDelta:offset];
    offset.deltaX = offsetX - self.bottleOffsetX;
    offset.deltaY = offsetY - self.bottleOffsetY;
    return offset;
}

#pragma mark - 菜单键调用函数 mainMapDelegate
- (void)restartGameScene
{
    [self.bottle renewButtonPressed];
}

- (void)returnToMainMap
{
    [self changeToScene:^CCScene *{
        CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"world.ccbi"];
        return scene;
    }];
}

- (void)helpButtonPressed
{
    if (self.isMonsterAnimated || self.isTouchBottle || [self someMonsterAnimated])
    {
        return;
    }
    
    if (!self.bottle.isEmpty)
    {
        [self.bottle renewButtonPressed];
    }
    
    if (self.iUiState)
    {
        self.iUiState = 0;
        [self hideAllUiWithAnimation:YES];
    }
    else
    {
        self.iUiState = 1;
        [self handleShowUi:self.iUiState withAnimation:YES];

    }
}

#pragma mark - UI
- (void)hideAllUiWithAnimation:(BOOL)fAnimated
{
    [self.helpUi hideAllUiWithAnimation:fAnimated];
    [self.swipeIndicator hideWithAnimation:fAnimated];
}
- (void)handleShowUi:(int)state withAnimation:(BOOL)fAnimation
{
    [self reorderIndexForHelpUi:state];
    switch (state)
    {
        case 1:
        {
            [self.helpUi showHelpLabel:YES helpLabelIndex:1 withAnimation:NO];
//            [self.swipeIndicator hideWithAnimation:NO];
            [self.helpUi showShadow:YES withAnimation:YES];
            break;
        }
        case 2:
        {
            [self.helpUi showHelpLabel:YES helpLabelIndex:2 withAnimation:NO];
            [self.swipeIndicator hideWithAnimation:NO];
            [self.helpUi showShadow:YES withAnimation:YES];
            break;
        }
        case 3:
        {
            [self.helpUi hideAllUiWithAnimation:NO];
            [self.swipeIndicator showWithAnimation:YES];
            [self.helpUi showShadow:YES withAnimation:YES];
            break;
        }
        default:
        {
            break;
        }
    }
}
- (BOOL)checkIsFirstOpen
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* fFirst = [userDefaults objectForKey:kP4FirstOpenKey];
    return !fFirst || [fFirst isEqual:[NSNull null]] || fFirst.boolValue;
}
- (BOOL)setIsFirstOpen:(BOOL)fFirst
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@NO forKey:kP4FirstOpenKey];
    return [userDefaults synchronize];
}

#pragma mark - Order
- (void)reorderNormalIndex
{
    [self reorderChild:self.bottle z:P4NormalIndexBottle];
    [self reorderChild:self.groundSprite z:P4NormalIndexGround];
    [self reorderChild:self.table z:P4NormalIndexTable];
    for (P4Monster* monster in self.monstersArray) {
        [self reorderChild:monster z:P4NormalIndexMonster];
    }
}
- (void)reorderIndexForHelpUi:(int)state
{
    [self reorderChild:self.helpUi z:P4HelpShowedIndexUi];
    [self reorderChild:self.swipeIndicator z:P4HelpShowedIndexSwipe];
    [self reorderNormalIndex];
    switch (state) {
        case 1:
        case 2:
        {
            for (P4Monster* monster in self.monstersArray) {
                [self reorderChild:monster z:P4HelpShowedIndexFocus];
            }
            break;
        }
        case 3:
        {
            [self reorderChild:self.bottle z:P4HelpShowedIndexFocus];
            break;
        }
        default:
            break;
    }
}
@end
