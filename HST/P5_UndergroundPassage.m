//
//  P5_UndergroundPassage.m
//  Dig
//
//  Created by Emerson on 2/2/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P5_UndergroundPassage.h"
#import "P5_CalculateHelper.h"
#import "NSNotificationCenter+Addition.h"
#import "P5_UndergroundScene.h"
#import "CCBReader.h"

#define kPassageLength 103.0
#define kPassageWidth 60.0

@implementation P5_UndergroundPassage
{
    float passageLength;
    float passageDegree;
    NSInteger imageCounter;
    float currentShowPassageLength;
    
    NSMutableArray * passageFileNameArray;
}

-  (id)init
{
    if (self = [super init]) {
        currentShowPassageLength = 1.0;
        passageFileNameArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
}
- (void)onExit
{
    [super onExit];
    
    [passageFileNameArray release];
    passageFileNameArray = nil;
}

- (void)calculateForPassage
{
    passageLength = [P5_CalculateHelper distanceBetweenEndPoint:_endPoint
                                                    andStartPoint:_startPoint];
    passageDegree = [P5_CalculateHelper degreeBetweenStartPoint:_startPoint
                                                    andEndPoint:_endPoint
                                                      isForSoil:NO];
    imageCounter = (passageLength / kPassageLength) + 1;
    [self createRandomFileName];
}

#pragma mark - 创建水平角度的长度适合的通道
- (CCSprite *)createOriginPassage
{
    CCRenderTexture * rt = [[[CCRenderTexture alloc]initWithWidth:currentShowPassageLength
                                                          height:kPassageWidth
                                                      pixelFormat:kCCTexture2DPixelFormat_RGBA8888]autorelease];

    [rt beginWithClear:77.0 / 255.0 g:60.0 / 255.0 b:55.0 / 255.0 a:0.0];
    for (int i = 0 ; i < imageCounter; ++ i) {
        CCSprite * passage = [CCSprite spriteWithFile:(NSString *)[passageFileNameArray objectAtIndex:i]];

        [passage setPosition:CGPointMake((2.0 * i + 1.0)/2.0 * kPassageLength,
                                         kPassageWidth / 2.0)];
        [passage visit];
    }
    [rt end];

    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    retval.flipY = YES;
    return retval;
}

- (void)showPassages
{
    [[NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(showPassage:) userInfo:nil repeats:YES]fire];
}

#pragma mark - 显示通道 并将通道放置于合适的位置和角度
- (void)showPassage:(NSTimer *)theTimer
{
    if (currentShowPassageLength >= passageLength) {
        [self stopShowPassageTimer:theTimer];
        return;
    }
    if (_passage != nil) {
        [_passage removeFromParentAndCleanup:YES];
    }
    _passage = [self createOriginPassage];
    _passage.rotation = passageDegree;
    [_passage setPosition:[P5_CalculateHelper thirdPointInLineStartPoint:_startPoint
                                                         EndPoint:_endPoint
                                                        withDistance:currentShowPassageLength / 2
                                                          BeginPoint:_startPoint]];
    [self addChild:_passage];
    currentShowPassageLength = currentShowPassageLength + 20.0;
}

- (void)createRandomFileName
{
    for (int i = 0; i < imageCounter; ++ i) {
        NSString * passageFileName = [NSString stringWithFormat:@"P5_UndergroundPassage%d.png",(1 + (NSInteger)roundf(CCRANDOM_0_1() * 1))];
        [passageFileNameArray addObject:passageFileName];
    }
}

- (void)stopShowPassageTimer:(NSTimer *)theTimer
{
    [theTimer invalidate];
}

- (void)dealloc
{
    [super dealloc];
}
@end
