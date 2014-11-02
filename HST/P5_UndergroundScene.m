//
//  P5_UndergroundLayer.m
//  Dig
//
//  Created by Emerson on 14-1-26.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P5_UndergroundScene.h"
#import "P5_UndergroundHole.h"
#import "P5_Bell.h"
#import "P5_CalculateHelper.h"
#import "P5_UndergroundPassage.h"
#import "NSNotificationCenter+Addition.h"
#import "P5_SoilCloud.h"
#import "SimpleAudioEngine.h"
//划分为六个区域，一号区域坐标 115 ~ 335 515 ~ 630
//2     465 ~ 735 515 ~ 630
//3     115 ~ 235 315 ~ 385
//4     365 ~ 735 315 ~ 385
//5     865 ~ 900 110 ~ 385
//6     405 ~ 675 110 ~ 185

#define kMinXpoint 115.0
#define kMaxXpoint 900.0
#define kMinYpoint 110.0
#define kMaxYpoint 630.0
#define kMinDistance 200.0

#define kMaxHoleNumber 8
#define kstartHoleWidth 191.0
#define kstartHoleHeight 184.0

#define kMonsterHomeWidth   140.0
#define kMonsterHomeHeight  110.0

#define kHoleRadius 100.0

#define kBigCircleUINameInTexture       @"BigCircleUI"
#define kBigCircleUIChoosenInTexture    @"P5_BigCircleUI_Choosen"

@implementation P5_UndergroundScene
{
    NSInteger currentHoleCounters;
    BOOL isStartDrawing;
    BOOL isCreateNewDrawing;
    BOOL isEndDrawing;                  //是否完成绘制，即小怪物能通向老家
    BOOL isTouchInHome;                 //触摸点是否在老家内
    BOOL isMonsterFirstStart;           //第一次出发
    float monsterMoveDistance;          //小怪物移动距离，用作添加土块粒子
    
    NSInteger currentDrawingNumber;
    NSInteger showedPassages;
    NSInteger rolledHoles;              //小怪物正向第几个洞挖去，第0个洞代表开始，第1个洞代表第一个挖向的洞
    NSInteger rotatedBell;              //重新震动铃铛计算
    NSTimer * rotatedBellTimer;         //重新震动铃铛的计时器
    NSInteger smokeCounter;             //计算烟尘出现的频率
    CCLayer * background;               //背景图层
    
    CCSprite * bigCircleUI;             //手指处大的圆形UI
    CCSpriteBatchNode * smallCircleUI;  //小型圆形UI
    CCSpriteBatchNode * smallCircleUIBetweenHoles;//洞之间小型圆形UI
    
    CCParticleSystem * soil;            //挖洞时喷出粒子
}

static CGPoint bellPositions[] = {
    {900,500},//StartHole
    {616,570},//Hole1
    {233,608},//Hole2
    {113,370},//Hole3
    {405.0,419.0},//Hole4
    {460,226},//Hole7
    {648,115},//Hole5
    {824,292},//Hole6
    {161,100} //home
};

static CGPoint monsterStartPositions[] = {
    {900,462},//垂直向下的怪物出发点
    {855,462}//像前滚动一段的怪物出发点
};

static ccColor3B smallCircleUIColor[] = {
    {137,255,121},//绿色
    {255,255,255},//白色
    {255,44,71}   //红色
};

static float holesRadius[] = {
    100,
    57.5,
    57.5,
    57.5,
    65,
    67.5,
    62.5,
    175
};

- (void) didLoadFromCCB
{
    self.currentMusicIndex = 1;
}
- (void)setCurrentMusicIndex:(int)currentMusicIndex
{
    _currentMusicIndex = currentMusicIndex;
    
    for (P5_UndergroundHole * hole in _undergroundHolesArray) {
        hole.bell.currentMusicIndex = currentMusicIndex;
    }
}
- (void)createUndergroundWorld
{
    currentDrawingNumber = 0;
    rolledHoles = 0;
    showedPassages = 0;
    rotatedBell = 0;
    smokeCounter = 0;
    monsterMoveDistance = 0.0;
    
    isStartDrawing = NO;
    isCreateNewDrawing = NO;
    isEndDrawing = NO;
    isTouchInHome = NO;
    isMonsterFirstStart = NO;
    
    [self addBellinUndergroundHole];
    background = (CCLayer *)[CCBReader nodeGraphFromFile:@"P5_UndergroundBackground.ccbi"];
    [self addChild:background z:-10];
    
    smallCircleUI = [CCSpriteBatchNode batchNodeWithFile:@"P5_SmallCircleUI.png" capacity:60];
    smallCircleUIBetweenHoles = [CCSpriteBatchNode batchNodeWithFile:@"P5_SmallCircleUI.png" capacity:100];
    [self addChild:smallCircleUI z:-1];
    [self addChild:smallCircleUIBetweenHoles z:-1];

    [NSNotificationCenter registerShouldShowNextPassageNotificationWithSelector:@selector(showUndergroundPassage) target:self];
    [NSNotificationCenter registerShouldRollToNextHoleNotificationWithSelector:@selector(rollToHole) target:self];
    [NSNotificationCenter registShouldRotateNextBellNotificationWithSelector:@selector(startRotateAllPassedBell) target:self];
    
    [self preloadTexture];

    [self scheduleUpdate];
    [self setTouchEnabled:NO];
    
}

#pragma mark - 预加载贴图降低消耗
- (void) preloadTexture
{
    UIImage * image = [UIImage imageNamed:@"P5_BigCircleUI.png"];
    [[CCTextureCache sharedTextureCache]addCGImage:image.CGImage forKey:kBigCircleUINameInTexture];
    UIImage * imageChoosen = [UIImage imageNamed:@"P5_BigCircleUI_Choosen.png"];
    [[CCTextureCache sharedTextureCache]addCGImage:imageChoosen.CGImage forKey:kBigCircleUIChoosenInTexture];
    
    [[CCTextureCache sharedTextureCache]addImage:@"P5_Soil.png"];
}

#pragma mark - update函数
- (void)update:(ccTime)delta
{
    CCNode * node;
    CCARRAY_FOREACH(self.children, node)
    {
        if ([node isKindOfClass:[P5_SoilCloud class]]) {
            P5_SoilCloud * soilCloud = (P5_SoilCloud *)node;
            if (soilCloud.isReadyToMove) {
                [soilCloud removeFromParentAndCleanup:YES];
            }
        }
    }
    
    if (rolledHoles != 0){
        if ([P5_CalculateHelper isPoint:_monsterUnderground.position inAnotherPoint:bellPositions[[[_drawOrderArray objectAtIndex:rolledHoles]integerValue]]
                                   with:holesRadius[[[_drawOrderArray objectAtIndex:rolledHoles]integerValue]]] ||
            [P5_CalculateHelper isPoint:_monsterUnderground.position inAnotherPoint:bellPositions[[[_drawOrderArray objectAtIndex:rolledHoles - 1]integerValue]]
                                   with:holesRadius[[[_drawOrderArray objectAtIndex:rolledHoles - 1]integerValue]]]) {
                if(soil != nil && [self.children containsObject:soil] && !isMonsterFirstStart) {
                    isMonsterFirstStart = YES;
                    soil.duration = 0.0;
                }
                monsterMoveDistance = 0.0;
            }
        else {
            if (isMonsterFirstStart) {
                NSString * soilFilename = [NSString stringWithFormat:@"P5_SoilPS%d.plist",
                                           [P5_CalculateHelper chooseSoilPlistByStartPoint:bellPositions[[[_drawOrderArray objectAtIndex:rolledHoles - 1]integerValue]]
                                                                               andEndPoint:bellPositions[[[_drawOrderArray objectAtIndex:rolledHoles]integerValue]]]];
                soil = [CCParticleSystemQuad particleWithFile:soilFilename];
                soil.positionType = kCCPositionTypeGrouped;
                CGPoint soilPoint = CGPointMake(_monsterUnderground.position.x,
                                                _monsterUnderground.position.y - 5.0);
                soil.position = soilPoint;
                soil.autoRemoveOnFinish = YES;
                soil.rotation = [P5_CalculateHelper degreeBetweenStartPoint:bellPositions[[[_drawOrderArray objectAtIndex:rolledHoles - 1]integerValue]]
                                                                andEndPoint:bellPositions[[[_drawOrderArray objectAtIndex:rolledHoles]integerValue]]
                                                                  isForSoil:YES];

                [self addChild:soil z:1];
                
                isMonsterFirstStart = NO;
                monsterMoveDistance = 0.0;
            }
            else {
                CGPoint soilPoint = CGPointMake(_monsterUnderground.position.x,
                                                _monsterUnderground.position.y - 5.0);
                soil.position = soilPoint;
                
                ++ smokeCounter;
                if (smokeCounter == 10) {
                    P5_SoilCloud * soilCloud = [[[P5_SoilCloud alloc]init]autorelease];
                    [self addChild:soilCloud z:11];
                    soilCloud.position = soilPoint;
                    [soilCloud createRandomSoilCloudByName:@"P5_Smoke.png" andType:kSmokeType];
                    smokeCounter = 0;
                }
            }
        }
    }
    
    if (_monsterUnderground.position.x < bellPositions[kMaxHoleNumber].x + kMonsterHomeWidth &&
        _monsterUnderground.position.y < bellPositions[kMaxHoleNumber].y + kMonsterHomeHeight &&
        !_monsterUnderground.isArriveHome) {
        _monsterUnderground.isArriveHome = YES;
        _monsterUnderground.isReadyStart = NO;
        [_monsterUnderground arriveHome];
    }
}

#pragma mark - 添加铃铛
- (void)addBellinUndergroundHole
{
    for (int i = 1; i < kMaxHoleNumber; ++ i) {
        P5_UndergroundHole * newHole = [[[P5_UndergroundHole alloc]init]autorelease];
        newHole.centerPoint = bellPositions[i];
        newHole.scaleRate = 0.95 + CCRANDOM_0_1() * 0.1;
        NSString * bellFileName = [NSString stringWithFormat:@"P5_Bell%d.ccbi",(1 + (NSInteger)roundf(CCRANDOM_0_1() * 3))];
        P5_Bell * bell = (P5_Bell *)[CCBReader nodeGraphFromFile:bellFileName];
        [bell performSelector:@selector(bellNormalAction) withObject:bell afterDelay:(CCRANDOM_0_1() * 2)];
        bell.position = CGPointMake(bellPositions[i].x, bellPositions[i].y + 33.0) ;//因为Bell的锚点设置为(0.5,1)所以加上Bell本身高度66.0的一半33.0
        bell.scale = newHole.scaleRate;
        ccColor3B color = [bell colorAtIndex:i];
        bell.currentMusicType = i;
        [bell setBodyColor:color];
        [self addChild:bell z:0];
        newHole.bell = bell;
        newHole.holeNumber = i;
        [self.undergroundHolesArray addObject:newHole];
    }
}

- (float)calculateDistancewith:(float)xDistance and:(float)yDistance
{
    return sqrtf(xDistance * xDistance + yDistance * yDistance);
}

#pragma mark - monster
- (void)monsterRoll
{
    [self.monsterUnderground startRoll];
    isMonsterFirstStart = YES;
}

- (void)rollToHole
{
    if ([_drawOrderArray count] != 0) {
        if (rolledHoles != [_drawOrderArray count] - 1) {
            ++ rolledHoles;
            CGPoint endPoisiton = bellPositions[[(NSNumber *)[_drawOrderArray objectAtIndex:rolledHoles]integerValue]];
            [self.monsterUnderground rollfromPoint1:self.monsterUnderground.position toPoint2:endPoisiton];
        }
    }
}

#pragma mark - passage
- (void)createUndergroundPassage
{
    NSInteger holeCounter = [_drawOrderArray count];
    for (int i = 0; i < holeCounter - 1; ++ i) {
        P5_UndergroundPassage * passage = [[[P5_UndergroundPassage alloc]init]autorelease];
        [self addChild:passage z:-1];
        if (i == 0) {
            if ([[_drawOrderArray objectAtIndex:1]integerValue] == 6) {
                passage.startPoint = monsterStartPositions[0];
            }
            else {
                passage.startPoint = monsterStartPositions[1];
            }
        }
        else {
            passage.startPoint = bellPositions[[(NSNumber *)[_drawOrderArray objectAtIndex:i]integerValue]];
        }
        passage.endPoint = bellPositions[[(NSNumber *)[_drawOrderArray objectAtIndex:(i + 1)]integerValue]];
        [passage calculateForPassage];
        [self.undergroundPassagesArray addObject:passage];
    }
}

- (void)showUndergroundPassage
{
    if (showedPassages != [_undergroundPassagesArray count]) {
        P5_UndergroundPassage * passage = (P5_UndergroundPassage *)[_undergroundPassagesArray objectAtIndex:showedPassages];
        ++ showedPassages;
        [passage showPassages];
    }
}

#pragma mark - 重新开始震动铃铛
- (void)startRotateAllPassedBell
{
    if (isEndDrawing) {
        rotatedBellTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(rotateAllPassedBell) userInfo:nil repeats:YES];
        [rotatedBellTimer fire];
    }
}

- (void)rotateAllPassedBell
{
    P5_UndergroundHole * hole = (P5_UndergroundHole *)[_undergroundHolesArray objectAtIndex:
                                                       ([(NSNumber *)[_drawOrderArray objectAtIndex:(rotatedBell + 1)]integerValue] - 1)];
    [hole.bell restartBellToMode:[[[NSNumber alloc]initWithInteger:BellQuickMode]autorelease]];
    [hole.bell performSelector:@selector(restartBellToMode:)
                    withObject:[[[NSNumber alloc]initWithInteger:BellNormalMode]autorelease]
                    afterDelay:1.2];
    ++ rotatedBell;
    if (rotatedBell == [_drawOrderArray count] - 2) {
        rotatedBell = 0;
    }
}

#pragma mark - 重置场景
- (void)restartUndergroundWorld
{
    [_monsterUnderground stopAllActions];
    [_monsterUnderground removeFromParentAndCleanup:YES];
    
    self.monsterUnderground = (P5_Monster *)[CCBReader nodeGraphFromFile:@"P5_MonsterUnderground.ccbi"];
    [self addChild:_monsterUnderground z:10];
    _monsterUnderground.isUpground = NO;
    _monsterUnderground.delegate = self;
    [self.monsterUnderground setPosition:CGPointMake(900.0, 460.0)];
    
    for (P5_UndergroundHole * hole in _undergroundHolesArray) {
        hole.isChoosen = NO;
        hole.bell.isChoosen = NO;
    }
    
    NSInteger passageNumber = [_undergroundPassagesArray count];
    for (int i = 0; i < passageNumber; ++ i) {
        P5_UndergroundPassage * passage = [_undergroundPassagesArray objectAtIndex:0];
        [_undergroundPassagesArray removeObjectAtIndex:0];
        [passage removeFromParentAndCleanup:YES];
        //        [passage release];
    }
    
    [_drawOrderArray removeAllObjects];
    if (rotatedBellTimer != nil && [rotatedBellTimer isValid]) {
        [rotatedBellTimer invalidate];
        rotatedBellTimer = nil;
    }
    if (soil != nil && [self.children containsObject:soil]) {
        [soil removeFromParentAndCleanup:YES];
    }
    
    isStartDrawing = NO;
    isCreateNewDrawing = NO;
    isEndDrawing = NO;
    isTouchInHome = NO;
    isMonsterFirstStart = NO;

    currentDrawingNumber = 0;
    showedPassages = 0;
    rolledHoles = 0;
    rotatedBell = 0;
    smokeCounter = 0;
    monsterMoveDistance = 0.0;
}

#pragma mark - Touch

-(void) ccTouchesBegan:(NSSet*)touches withEvent:(id)event
{
    if ([self.delegate respondsToSelector:@selector(touchesBegin)]) {
        [self.delegate touchesBegin];
    }
    
    //CCDirector* director = [CCDirector sharedDirector];
    if (!isEndDrawing) {
        for(UITouch* touch in touches)
        {
            CGPoint startHolePosition = bellPositions[0];
            CGPoint touchPosition = [self locationFromTouch:touch];
            if (touchPosition.x < startHolePosition.x + kstartHoleWidth && touchPosition.x > startHolePosition.x - kstartHoleWidth) {
                if (touchPosition.y < startHolePosition.y + kstartHoleHeight && touchPosition.y > startHolePosition.y - kstartHoleHeight) {
                    isStartDrawing = YES;
                    bigCircleUI = [CCSprite spriteWithFile:@"P5_BigCircleUI.png"];
                    bigCircleUI.position = touchPosition;
                    [self addChild:bigCircleUI];
                }
            }
        }
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isStartDrawing && !isEndDrawing) {
        for (UITouch * touch in touches)
        {
            isCreateNewDrawing = NO;
            
            CGPoint currentEndPosition = [self locationFromTouch:touch];
            bigCircleUI.position = currentEndPosition;
            for (P5_UndergroundHole * hole in _undergroundHolesArray) {
                if (!hole.isChoosen) {
                    if ([P5_CalculateHelper isLineWithFirstPoint:bellPositions[currentDrawingNumber]
                                                     SecondPoint:currentEndPosition
                                                  InCircleCenter:hole.centerPoint
                                                        Radius:kHoleRadius]) {
                        [[SimpleAudioEngine sharedEngine]playEffect:[NSString stringWithFormat:@"P5_%d_%d.mp3", self.currentMusicIndex,[_undergroundHolesArray indexOfObject:hole] + 1]];

                        hole.isChoosen = YES;
                        isCreateNewDrawing = YES;
                        
                        [self addLineUIFrom:bellPositions[currentDrawingNumber] End:hole.centerPoint withUIMode:UIBetweenHoles];
                        
                        [self.drawOrderArray addObject:[[[NSNumber alloc]initWithInteger:currentDrawingNumber]autorelease]];
                        currentDrawingNumber = hole.holeNumber;
                        break;
                    }
                }
            }
            
            if (!isCreateNewDrawing) {
                [self addLineUIFrom:bellPositions[currentDrawingNumber] End:currentEndPosition withUIMode:UINormal];
            }
            
            if (currentEndPosition.x < bellPositions[kMaxHoleNumber].x + kMonsterHomeWidth &&
                currentEndPosition.y < bellPositions[kMaxHoleNumber].y + kMonsterHomeHeight &&
                isStartDrawing &&
                [_drawOrderArray count] > 1)
            {
                if (!isTouchInHome) {
                    CCTexture2D * newTexture = [[CCTextureCache sharedTextureCache]textureForKey:kBigCircleUIChoosenInTexture];
                    [bigCircleUI setTexture:newTexture];
                }
                
                for (CCSprite * smallCircle1 in [smallCircleUI children]) {
                    smallCircle1.color = smallCircleUIColor[0];
                }
                for (CCSprite * smallCircle2 in [smallCircleUIBetweenHoles children]) {
                    smallCircle2.color = smallCircleUIColor[0];
                }
                isTouchInHome = YES;
            }
            else if (currentEndPosition.x < bellPositions[kMaxHoleNumber].x + kMonsterHomeWidth &&
                     currentEndPosition.y < bellPositions[kMaxHoleNumber].y + kMonsterHomeHeight &&
                     [_drawOrderArray count] <= 1)
            {
                for (CCSprite * smallCircle1 in [smallCircleUI children]) {
                    smallCircle1.color = smallCircleUIColor[2];
                }
                for (CCSprite * smallCircle2 in [smallCircleUIBetweenHoles children]) {
                    smallCircle2.color = smallCircleUIColor[2];
                }
                isTouchInHome = YES;
            }
            else if (isTouchInHome &&
                     (currentEndPosition.x > bellPositions[kMaxHoleNumber].x + kMonsterHomeWidth ||
                      currentEndPosition.y > bellPositions[kMaxHoleNumber].y + kMonsterHomeHeight) )
            {
                
                CCTexture2D * newTexture = [[CCTextureCache sharedTextureCache]textureForKey:kBigCircleUINameInTexture];
                [bigCircleUI setTexture:newTexture];
                
                for (CCSprite * smallCircle1 in [smallCircleUI children]) {
                    smallCircle1.color = smallCircleUIColor[1];
                }
                for (CCSprite * smallCircle2 in [smallCircleUIBetweenHoles children]) {
                    smallCircle2.color = smallCircleUIColor[1];
                }
                isTouchInHome = NO;
            }
        }
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        CGPoint currentEndPosition = [self locationFromTouch:touch];
        
        if ([[self children]containsObject:bigCircleUI]) {
            [bigCircleUI removeFromParentAndCleanup:YES];
        }
        [smallCircleUI removeAllChildrenWithCleanup:YES];
        [smallCircleUIBetweenHoles removeAllChildrenWithCleanup:YES];
        
        if (currentEndPosition.x < bellPositions[kMaxHoleNumber].x + kMonsterHomeWidth &&
            currentEndPosition.y < bellPositions[kMaxHoleNumber].y + kMonsterHomeHeight &&
            isStartDrawing &&
            [_drawOrderArray count] > 1)
        {
            [_drawOrderArray addObject:[[[NSNumber alloc]initWithInteger:currentDrawingNumber]autorelease]];
            [_drawOrderArray addObject:[[[NSNumber alloc]initWithInteger:kMaxHoleNumber]autorelease]];
            [self createUndergroundPassage];
            isStartDrawing = NO;
            isEndDrawing = YES;
            [self monsterRoll];
        }
        else if (!isEndDrawing) {
            [self restartUndergroundWorld];
        }
    }
}

-(void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[self children]containsObject:bigCircleUI]) {
        [bigCircleUI removeFromParentAndCleanup:YES];
    }
    [smallCircleUI removeAllChildrenWithCleanup:YES];
    [smallCircleUIBetweenHoles removeAllChildrenWithCleanup:YES];
    [self restartUndergroundWorld];
}

#pragma mark - 转换touch坐标
-(CGPoint) locationFromTouch:(UITouch*)touch
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (CGPoint)monsterCurrentPosition
{
    return self.monsterUnderground.position;
}

#pragma mark - 添加直线UI
- (void)addLineUIFrom:(CGPoint)startPoint End:(CGPoint)endPoint withUIMode:(UIMode)uimode
{
    if (uimode == UINormal) {
        [smallCircleUI removeAllChildrenWithCleanup:YES];
    }
    
    CGPoint lastPoint = startPoint;
    float smallCircleLength = [P5_CalculateHelper distanceBetweenEndPoint:endPoint
                                                            andStartPoint:startPoint];
    NSInteger smallCircleCounter = (smallCircleLength / 30.0) + 1;
    for (int i = 0; i < smallCircleCounter - 1; ++ i) {
        CCSprite * smallCircle = [CCSprite spriteWithFile:@"P5_SmallCircleUI.png"];
        CGPoint newPoint = [P5_CalculateHelper thirdPointInLineStartPoint:startPoint
                                                                 EndPoint:endPoint
                                                             withDistance:30.0
                                                               BeginPoint:lastPoint];
        [smallCircle setPosition:newPoint];
        lastPoint = newPoint;
        if (uimode == UINormal) {
            [smallCircleUI addChild:smallCircle];
        }
        else {
            [smallCircleUIBetweenHoles addChild:smallCircle];
        }
        
        
    }
}

#pragma mark - Monster Delegate
- (void)monsterArriveTheStartHole
{
#warning 开场动画之后小怪物跳入洞穴完成
    P5_SoilCloud * soilCloud = [[[P5_SoilCloud alloc]init]autorelease];
    [self addChild:soilCloud z:6];
    soilCloud.position = CGPointMake(900.0, 410.0);
    [soilCloud createRandomSoilCloudByName:@"P5_SoilCloud.png" andType:kSoilCloudType];
    
    [self.delegate releaseTheCacheInTexture];
}

- (void)monsterArriveTheFinalHole
{
    P5_SoilCloud * soilCloud = [[[P5_SoilCloud alloc]init]autorelease];
    [self addChild:soilCloud z:6];
    soilCloud.position = CGPointMake(161, 3.0);
    [soilCloud createRandomSoilCloudByName:@"P5_SoilCloud.png" andType:kSoilCloudType];
    if ([self.delegate respondsToSelector:@selector(monsterDidArrayFinal)]) {
        [self.delegate monsterDidArrayFinal];
    }
}

#pragma mark - property
- (NSMutableArray *)undergroundHolesArray
{
    if (!_undergroundHolesArray) {
        _undergroundHolesArray = [[NSMutableArray alloc]initWithCapacity:kMaxHoleNumber];
    }
    return _undergroundHolesArray;
}

- (CCArray *)undergroundPassagesArray
{
    if (!_undergroundPassagesArray) {
        _undergroundPassagesArray = [[CCArray alloc]initWithCapacity:kMaxHoleNumber];
    }
    return _undergroundPassagesArray;
}

- (NSMutableArray *)drawOrderArray
{
    if (!_drawOrderArray) {
        _drawOrderArray = [[NSMutableArray alloc]initWithCapacity:kMaxHoleNumber + 1];
    }
    return _drawOrderArray;
}

- (void)onExit
{
    [super onExit];
    
    if (rotatedBellTimer != nil && [rotatedBellTimer isValid]) {
        [rotatedBellTimer invalidate];
        rotatedBellTimer = nil;
    }
    NSInteger passageNumber = [_undergroundPassagesArray count];
    for (int i = 0; i < passageNumber; ++ i) {
        P5_UndergroundPassage * passage = [_undergroundPassagesArray objectAtIndex:0];
        [_undergroundPassagesArray removeObjectAtIndex:0];
        [passage removeFromParentAndCleanup:YES];
    }
    [_undergroundPassagesArray release];
    
    [_undergroundHolesArray removeAllObjects];
    [_undergroundHolesArray release];
    
    [_drawOrderArray removeAllObjects];
    [_drawOrderArray release];
    
    [[[CCDirector sharedDirector] view]setMultipleTouchEnabled:YES];
}

#pragma mark - 退出时释放内存
- (void)dealloc
{
    [super dealloc];
}


@end
