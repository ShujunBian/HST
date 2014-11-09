//
//  Monster.m
//  jump
//
//  Created by Emerson on 13-9-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_Monster.h"
#import "P2_MonsterEye.h"
#import "MonsterEye.h"
#import "CCBReader.h"
#import "CCBAnimationManager.h"
#import "P2_LittleFlyObjects.h"
#import "P2_FlyGrass.h"
#import "P2_CalculateHelper.h"
#import "MonsterEyeUpdateObject.h"

#define EVERYDELTATIME 0.016667
#define RATIOTORUNNEWEYEMOVING 0.7
#define RATIOTOCLOSEEYES 0.85

@interface P2_Monster()

@property (strong, nonatomic) MonsterEyeUpdateObject* updateObj;

@end

@implementation P2_Monster

@synthesize monsterHead;
@synthesize monsterBody;
@synthesize isFinishJump;
@synthesize currentJumpTime;

- (id)init
{
	if( (self=[super init]))
    {
        jumpTime = 0.0;
        theIdleTimes = 0;
        currentJumpTime = 0.0;
        downSpeed = 0.0;
        isReadyToJump = NO;
        isReadyToDown = NO;
        isFinishJump = YES;
        self.isInMainMap = NO;
        
        self.monsterEye = [[[MonsterEye alloc]initWithEyeWhiteName:@"p2_monster_eyewhite.png" eyeballName:@"p2_monster_eyeblack.png" eyelidColor:ccc3(255.0, 198.0, 0.0)]autorelease];
        self.monsterEye.position = CGPointMake(78.0, 185.0);
        [self addChild:self.monsterEye z:1];
        
        self.updateObj = [[[MonsterEyeUpdateObject alloc] init]autorelease];
        [self.updateObj addMonsterEye:self.monsterEye];
        [self.updateObj beginUpdate];
        
        [self scheduleUpdate];
	}
	return self;
}

- (void)onExit
{
    [super onExit];
}

-(void)update:(ccTime)delta
{
    if (isReadyToJump == YES) {
        jumpTime += 1;
        currentJumpTime += 1;
        
        if (jumpTime < 5) {
            self.position = CGPointMake(self.position.x, EVERYDELTATIME * 781.1 * 3 + self.position.y);
        }
        else if (jumpTime >= 5 && jumpTime < 10)
        {
            self.position = CGPointMake(self.position.x, EVERYDELTATIME * 641.1 * 3 + self.position.y);
        }
        else if (jumpTime >= 10 && jumpTime < 20)
        {
            self.position = CGPointMake(self.position.x, EVERYDELTATIME * 266.66 + self.position.y);
        }
        else if (jumpTime >= 20) {
            NSLog(@"The monster y point is %f",self.position.y);
            [self letMonsterDown];
        }
    }
    
    if (isReadyToDown == YES) {
        
        if (jumpTime == 0) {
            downSpeed = [self getMonsterDownSpeed:self.position.y];
        }
        
        if (jumpTime < 10) {
            self.position = CGPointMake(self.position.x, - EVERYDELTATIME * downSpeed + self.position.y);
        }
        else if (jumpTime >= 10 && jumpTime < 15)
        {
            self.position = CGPointMake(self.position.x, -EVERYDELTATIME * downSpeed * 3 + self.position.y);
        }
        else if (jumpTime >= 15 && jumpTime < 20)
        {
            self.position = CGPointMake(self.position.x, -EVERYDELTATIME * downSpeed * 4 + self.position.y);
        }
        else if (jumpTime >= 20) {
            currentJumpTime = 0.0;
            jumpTime = 0.0;
            isReadyToDown = NO;
            
            P2_FlyGrass * flyGrass = (P2_FlyGrass *)[CCBReader nodeGraphFromFile:@"P2_FlyGrasses.ccbi"];
            flyGrass.position = CGPointMake(self.position.x , self.position.y + 10);
            [self.parent addChild:flyGrass z:0];
            CCBAnimationManager * flyGrassAnimationManager =flyGrass.userObject;
            int flyGrassType = (arc4random() % 2) + 1;
            NSString * flyGrassFilename = [NSString stringWithFormat:@"GrassDown%d",flyGrassType];
            [flyGrassAnimationManager runAnimationsForSequenceNamed:flyGrassFilename];
            
            [self overDown];
        }
        jumpTime += 1;
    }
}

-(float)getMonsterDownSpeed:(float)height
{
    return ((height / EVERYDELTATIME) / 45);
}

#pragma mark - monster准备起跳
- (void)monsterReadyToJump
{
    [self.monsterEye blink];
    
    CCScaleTo * bodyScale1 = [CCScaleTo actionWithDuration:(10 * EVERYDELTATIME) scaleX:1.30 scaleY:0.75];
    CCCallFunc * jumpCallBack = [CCCallFunc actionWithTarget:self selector:@selector(jump)];
    CCSequence * seq = [CCSequence actions:bodyScale1,jumpCallBack, nil];
    [self runAction:seq];
    
    
}

#pragma mark - monster跳起后
-(void)jump
{
    isReadyToJump = YES;
    [self resetScale];
}

- (void)resetScale
{
    [self setScale:1.0];
    CCScaleTo * bodyScale1 = [CCScaleTo actionWithDuration:(12 * EVERYDELTATIME) scaleX:0.9 scaleY:1.08];
    CCScaleTo * bodyScale2 = [CCScaleTo actionWithDuration:(8 * EVERYDELTATIME) scaleX:1.0 scaleY:1.0];
    CCSequence * bodySeq = [CCSequence actions:bodyScale1,bodyScale2, nil];
    [self runAction:bodySeq];
}

#pragma mark - monster下落后
- (void)overDown
{
    isFinishJump = YES;
    [self littleJump];
//    CCScaleTo * bodyScale1 = [CCScaleTo actionWithDuration:(4 * EVERYDELTATIME) scaleX:1.1 scaleY:0.95];
//    CCScaleTo * bodyScale2 = [CCScaleTo actionWithDuration:(3 * EVERYDELTATIME) scaleX:0.95 scaleY:1.04];
//    CCScaleTo * bodyScale3 = [CCScaleTo actionWithDuration:(1 * EVERYDELTATIME) scaleX:1.0 scaleY:1.0];
//    CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
//        isFinishJump = YES;
//        [self littleJump];
//    }];
//    CCSequence * bodySeq = [CCSequence actions:bodyScale1,bodyScale2,bodyScale3,callBack, nil];
//    [self runAction:bodySeq];
}

- (void) handleCollision
{
    if (isReadyToDown == NO)
    {
        [self letMonsterDown];
    }
}

-(void)letMonsterDown
{
    currentJumpTime = 0.0;
    jumpTime = 0.0;
    isReadyToJump = NO;
    isReadyToDown = YES;
    
    [self stopAllActions];
    [self setScale:1.0];
}

#pragma mark - monster Little jump
- (void)littleJump
{
    float rate = 1.0;
    float jumpRate = 1.0;
    float changeScaleRate = 0.1;
    if (self.isInMainMap) {
        rate = 0.45;
        jumpRate = 0.3;
        changeScaleRate = 0.01;
    }
    theIdleTimes ++ ;
    CCScaleTo * monsterScale = [CCScaleTo actionWithDuration:0.20 scaleX:1.0 * rate + changeScaleRate scaleY:1.0 * rate - changeScaleRate];
    CCEaseOut * easeOutLittleJumpUp = [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0.0, 20.0 * jumpRate)] rate:1.5];
    CCScaleTo * monsterScaleBack = [CCScaleTo actionWithDuration:0.25 scaleX:1.0 * rate scaleY:1.0 * rate];
    CCSpawn * littleJump = [CCSpawn actions:easeOutLittleJumpUp,monsterScaleBack, nil];
    CCMoveBy * moveBy = [CCMoveBy actionWithDuration:0.2 position:ccp(0.0, - 20.0 * jumpRate)];
    CCCallFunc * callFunc = [CCCallFunc actionWithTarget:self selector:@selector(littleJump)];
    
    CCSequence * monseterLittleJump = [CCSequence actions:monsterScale,
                                       //                                           monsterScaleTest,
                                       littleJump,
                                       moveBy,
                                       callFunc,
                                       nil];
    [self runAction:monseterLittleJump];
}

- (void)dealloc
{
    self.monsterEye = nil;
    self.updateObj = nil;
    
    [super dealloc];
}
@end
