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

//#define BOTTLE_MOVE_DELAY 0.2f
#define BOTTLE_SCALE_X_MAX 1.2f
#define BOTTLE_SCALE_X_MIN 0.8f

#define BOTTLE_SCALE_X_ADD_RATE 1.03f
#define BOTTLE_SCALE_X_DECREASE_RATE 0.995f



@interface P4GameLayer ()
- (void)monsterPressed:(P4Monster*)monster;


//Bottle Move
- (void)bottleMoveDelta:(P4BottleOffset*)offset;
- (void)bottleMoveBack;
- (void)updateBottlePositionWithAnimation:(BOOL)fAnimate;


@property (strong, nonatomic) CCArray* monstersArray;
@property (assign, nonatomic) BOOL isMonsterAnimated;

@property (assign, nonatomic) CGPoint pourWaterPoint;

@property (assign, nonatomic) BOOL isTouchBottle;
@property (assign, nonatomic) CGPoint bottleTouchPointNow;
@property (assign, nonatomic) CGPoint bottleTouchPoint;
@property (assign, nonatomic) CGPoint bottleTouchPreviousPoint;
@property (assign, nonatomic) CGPoint bottleTouchOriginPoint;


@property (assign, nonatomic) CGPoint bottlePositoinOrigin;


@property (assign, nonatomic) float bottleOffsetX;
@property (assign, nonatomic) float bottleOffsetY;

@end

@implementation P4GameLayer

@synthesize backgroundSprite = _backgroundSprite;

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
	[super dealloc];

}

- (void)onEnter
{
    [super onEnter];

    [self.cloudLayer startAnimation];
    
    
//    CCRenderTexture* te = [[CCRenderTexture alloc] initWithWidth:300 height:300 pixelFormat:kCCTexture2DPixelFormat_Default];
//    [te beginWithClear:255.f g:0 b:0 a:255.f];
//    [te end];
//    CCSprite* s = [CCSprite spriteWithTexture:te.sprite.texture];
//    [self addChild:s];

    
}

- (void) didLoadFromCCB
{
    [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 727.0)];

//Monster Init
    self.monstersArray = [[CCArray alloc] init];
    
    [self.monstersArray addObject:self.greenMonster];
    [self.monstersArray addObject:self.brownMonster];
    [self.monstersArray addObject:self.purpleMonster];
    [self.monstersArray addObject:self.blueMonster];
    [self.monstersArray addObject:self.yellowMonster];
    
    for (P4Monster* monster in self.monstersArray)
    {
        [monster prePositionInit];
    }
    self.greenMonster.waterColor = ccc3(68.f, 255.f, 25.f);
    self.brownMonster.waterColor = ccc3(255.f, 252.f, 62.f);
    self.purpleMonster.waterColor = ccc3(255.f, 97.f, 242.f);
    self.blueMonster.waterColor = ccc3(50.f, 248.f, 255.f);
    self.yellowMonster.waterColor = ccc3(254.f, 70.f, 100.f);
    
    self.isMonsterAnimated = NO;
    self.isTouchBottle = NO;
    self.bottleTouchPoint = CGPointZero;
    
    CGRect bottleRect = [self.bottle.bottleMain getRect];
    self.pourWaterPoint = CGPointMake(bottleRect.origin.x + bottleRect.size.width / 2 - 100, bottleRect.origin.y + bottleRect.size.height + 70);

    
    self.bottleOffsetX = 0;
    self.bottleOffsetY = 0;
    self.bottlePositoinOrigin = self.bottle.position;
    
    self.bottle.gameLayer = self;
    
    self.bottleTouchOriginPoint = CGPointZero;
    self.bottleTouchPreviousPoint = CGPointZero;
    self.bottleTouchPoint = CGPointZero;
    self.bottleTouchPointNow = CGPointZero;
 
    
//    [self schedule:@selector(scaleUpdate)];
//    [self schedule:@selector(scaleUpdateHelper) interval:0.018f];
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
            else if (CGRectContainsPoint([self.bottle getRect], locationInNodeSpace) && !self.isMonsterAnimated)
            {
                
                self.isTouchBottle = YES;
                self.bottleTouchPoint = locationInNodeSpace;
                self.bottleTouchOriginPoint = locationInNodeSpace;
                self.bottleTouchPointNow = locationInNodeSpace;
            }
        }
    }
}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isTouchBottle)
    {
        CCDirector* director = [CCDirector sharedDirector];
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:director.view];
        CGPoint locationGL = [director convertToGL:touchLocation];
        CGPoint locationInNodeSpace = [self convertToNodeSpace: locationGL];
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
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isTouchBottle)
    {
        [self bottleMoveBack];
//        [self performSelector:@selector(bottleMoveBack) withObject:nil afterDelay:BOTTLE_MOVE_DELAY];
        [self.bottle runAction:[[CCScaleTo alloc] initWithDuration:0.2f scale:1.f]];
        
        self.bottleTouchOriginPoint = CGPointZero;
        self.bottleTouchPreviousPoint = CGPointZero;
        self.bottleTouchPoint = CGPointZero;
        self.bottleTouchPointNow = CGPointZero;
    }
}

#pragma mark - Action
- (void)monsterPressed:(P4Monster*)monster
{
    if (self.isMonsterAnimated || monster.isEmpty || self.bottle.isFull)
    {
        return;
    }
    __weak P4GameLayer *weakSelf = self;
    self.isMonsterAnimated = YES;
    [monster beginUpdateWater];
    CCFiniteTimeAction* callOpen = [[CCCallBlock alloc] initWithBlock:^{
        [weakSelf.bottle capOpen];
    }];
    CCFiniteTimeAction* moveTo = [[CCMoveTo alloc] initWithDuration:1.f position:self.pourWaterPoint];
//    CCFiniteTimeAction* delay = [[CCDelayTime alloc] initWithDuration:1.f];

    CCFiniteTimeAction* rotate = [[CCRotateTo alloc] initWithDuration:1.f angle:105];
    
    CCFiniteTimeAction* beginAddWater = [[CCCallBlock alloc] initWithBlock:^{
        [self.bottle startWaterIn:monster];
    }];
    
    CCFiniteTimeAction* delay2 = [[CCDelayTime alloc] initWithDuration:1.f];
    
    CCFiniteTimeAction* endAddWater = [[CCCallBlock alloc] initWithBlock:^{
        [self.bottle stopWaterIn];
    }];
    
    CCFiniteTimeAction* rotateBack = [[CCRotateTo alloc] initWithDuration:1.f angle:0];
    CCFiniteTimeAction* callClose = [[CCCallBlock alloc] initWithBlock:^{
        [weakSelf.bottle capClose];
    }];
    CCFiniteTimeAction* moveBack = [[CCMoveTo alloc] initWithDuration:1.f position:monster.prePosition];
    CCFiniteTimeAction* finish = [[CCCallBlock alloc] initWithBlock:^{
        weakSelf.isMonsterAnimated = NO;
        [monster endUpdateWater];
    }];
    
    CCSequence* sequence = [CCSequence actions:callOpen, moveTo, rotate, beginAddWater, delay2, endAddWater, rotateBack, callClose, moveBack, finish, nil];
    
    [monster runAction:sequence];
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


    float newX = 2 * self.bottleTouchPointNow.x - self.bottleTouchPoint.x;
    float newY = 2 * self.bottleTouchPointNow.y - self.bottleTouchPoint.y;
    P4BottleOffset* newOffset = [self getOffsetByTouchPoint:ccp(newX,newY)];
    float newDelay = sqrt( newOffset.deltaX * newOffset.deltaX + newOffset.deltaY * newOffset.deltaY) / 300.f;
    CCMoveBy* newBy = [[CCMoveBy alloc] initWithDuration:newDelay position:ccp(newOffset.deltaX,newOffset.deltaY)];
    CCEaseOut* newOut = [[CCEaseOut alloc] initWithAction:newBy rate:1.f];
    
    float delay = sqrt(self.bottleOffsetX * self.bottleOffsetX + self.bottleOffsetY * self.bottleOffsetY) / 200.f;
    CCMoveTo* moveBack = [[CCMoveTo alloc] initWithDuration:delay position:ccp(0,0)];

    CCEaseSineInOut* backInOut = [[CCEaseSineInOut alloc] initWithAction:moveBack];
//                                                                    rate:2.5f];
    [self.bottle runAction:[[CCSequence alloc] initOne:newOut two:backInOut]];
    self.bottleOffsetX = 0;
    self.bottleOffsetY = 0;
    
    self.isTouchBottle = NO;
    self.bottleTouchPoint = CGPointZero;
    
//    [self updateBottlePositionWithAnimation:YES];
    [self.bottle bottleMoveBack:delay];
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
    for (P4Monster* monster in self.monstersArray)
    {
        [monster startWaterFull];
    }
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
    
    P4BottleOffset* offset = [[P4BottleOffset alloc] init];
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
}

- (void)returnToMainMap
{
    [self unscheduleAllSelectors];
    for (CCNode * child in [self children]) {
        [child stopAllActions];
        [child unscheduleAllSelectors];
    }
    
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFade transitionWithDuration:1.0
                                        scene:[HelloWorldLayer scene]]];
}

@end
