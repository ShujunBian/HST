//
//  P4WaterLayer.m
//  hst_p4
//
//  Created by wxy325 on 1/20/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "P4WaterLayer.h"
#import "cocos2d.h"
#import "P4WaterLayer.h"
#import "P4WaterRecord.h"
#import "P4Extension.h"
#import "CCSprite+getRect.h"
#import "SimpleAudioEngine.h"

#define WATER_Z_ORDER_START 10
#define BUBBLE_Z_ORDER 100

#define ROTATE_MAX 15.f
#define ROTATE_SPEED_BASE 0.02f
#define ROTATE_REDUCE_RATE 0.5
#define ADD_WATER_SPEED 1.3f 

#define BAN_JIN 204
//#define YUAN_XIN ccp(181,96)
#define YUAN_XIN_XIANGDUI ccp(181,96)

#define BUBBLE_SPEED 20.f

@interface P4WaterLayer ()
@property (assign, nonatomic) CGPoint prePosition;
@property (assign, nonatomic) CGPoint preAnchor;
@property (assign, nonatomic) CGPoint preMaskLeftBottom;
//@property (strong, nonatomic) CCSprite* masked;
@property (assign, nonatomic) float offset;

@property (strong, nonatomic) NSMutableArray* waterRecordArray;
//@property (strong, nonatomic) NSMutableArray* waterSpriteArray;
@property (strong, nonatomic) CCSprite* waterWaveSprite;
@property (strong, nonatomic) CCSprite* waterBgSprite;


//Add Water
@property (assign, nonatomic) BOOL fAddWater;
@property (assign, nonatomic) ccColor3B addWaterColor;
@property (assign, nonatomic) BOOL addWaterIsRight;

@property (assign, nonatomic) float waterFlowTextureWidth;
@property (assign, nonatomic) ALuint waterReleaseSoundId;
@property (assign, nonatomic) BOOL fWaterReleaseStopSchedule;

- (void)addWaterWithColor:(ccColor3B)waterColor;

//Merge Water
@property (assign, nonatomic) BOOL isMergingWater;

//Rotate
@property (assign, nonatomic) float rotate;
@property (assign, nonatomic) float rotateTo;


//@property (assign, nonatomic) BOOL fToRotate;


@property (assign, nonatomic) BOOL fReleaseWater;

- (void)mergeWaterRecord;

- (void)checkWaterRotateMinAndMax;
- (void)updateRotate;

- (float)getWaterHeight;

@property (strong, nonatomic) NSMutableArray* onScreenBubbles;
@property (strong, nonatomic) NSMutableArray* offScreenBubbles;

@end

@implementation P4WaterLayer
@dynamic averageWaterScale;
@synthesize waterRecordArray = _waterRecordArray;

- (float)averageWaterScale
{
    if (self.waterRecordArray.count == 0)
    {
        return 0.f;
    }
    else
    {
        float s = 0.f;
        for (P4WaterRecord* r in self.waterRecordArray)
        {
            s += r.waveScale;
        }
        s /= self.waterRecordArray.count;
        return s;
    }
}

- (NSMutableArray*)waterRecordArray
{
    
    if (!_waterRecordArray)
    {
        _waterRecordArray = [@[] mutableCopy];
    }
    return _waterRecordArray;
}
- (void)setWaterRecordArray:(NSMutableArray *)waterRecordArray
{
    if (_waterRecordArray)
    {
        [_waterRecordArray release];
    }
    _waterRecordArray = waterRecordArray;
    if (_waterRecordArray)
    {
        [_waterRecordArray retain];
    }
}

- (void) didLoadFromCCB
{
    //cocosbuilder retain
    [self.bottleMask retain];
    [self.sprayLeft retain];
    [self.sprayRight retain];
    self.fWaterReleaseStopSchedule = NO;
    
    
    [self.bottleMask removeFromParent];

    [self.bottleMask.texture setAntiAliasTexParameters];
//    [self.bottleMask setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
    [self.bottleMask setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
//    self.bottleMask.scale = 0.5;
    
    self.water1 = [CCSprite spriteWithFile:@"water1.png"];
    
    [self.water1.texture setAntiAliasTexParameters];
    [self.water1 setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
//    [self.water1 setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ZERO}];
//    self.water1.opacity = 120.0;
    
//    [self.water1 setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
    
    self.water1.position = self.bottleMask.position;
//    [self addChild:self.water1];
    self.prePosition = self.bottleMask.position;
    self.preAnchor = self.bottleMask.anchorPoint;
//    self.bottleMask.anchorPoint = ccp(0,0);
    CGRect maskRect = [self.bottleMask getRect];
    self.preMaskLeftBottom = maskRect.origin;
    
    self.offset = 0;
//    self.masked = nil;
    
    self.waterWaveSprite = nil;
    self.waterBgSprite = nil;
    
//    self.waterRecordArray = [@[] mutableCopy];
    
    self.fAddWater = NO;
    self.fReleaseWater = NO;
    self.isMergingWater = NO;
    
    self.waterFlowTextureWidth = self.water1.texture.contentSize.width;
    
    self.rotate = 0;
 
    
    [self.sprayLeft stopSystem];
    [self.sprayRight stopSystem];
    
    self.leftSprayPrePositionR = self.sprayLeft.position;
    self.rightSprayPrePositionR = self.sprayRight.position;
    self.leftSprayPrePositionL = ccp(self.bottleMask.position.x * 2 - self.sprayLeft.position.x, self.sprayLeft.position.y);
    self.rightSprayPrePositionL = ccp(self.bottleMask.position.x * 2 - self.sprayRight.position.x, self.sprayRight.position.y);
    
    
    [self reorderChild:self.sprayLeft z:15];
    [self reorderChild:self.sprayRight z:15];
    
    [self schedule:@selector(bubbleUpdate:) interval:0.5f];
    
    self.onScreenBubbles = [[@[] mutableCopy] autorelease];
    self.offScreenBubbles = [[@[] mutableCopy] autorelease];
}
- (void)onEnter
{
    [super onEnter];
    [self schedule:@selector(waterFlowUpdate:) interval:1.f/60];
}
- (void)waterFlowUpdate:(ccTime)delta
{
    //Add Water
    if (self.fAddWater)
    {
        [self addWaterWithColor:self.addWaterColor];
    }
    [self releaseWater];
    
    
    //Merge Water
    [self mergeWaterRecord];
    
    self.isMergingWater = NO;
    for (P4WaterRecord* record in self.waterRecordArray)
    {
        if (record.isChangeColor)
        {
            self.isMergingWater = YES;
            break;
        }
    }

    
    //Update Rotate
    [self updateRotate];
    
    
    //Update Sprite
    [self.waterWaveSprite removeFromParentAndCleanup:YES];
    self.waterWaveSprite = nil;
//    [self.waterBgSprite removeFromParentAndCleanup:YES];
//    self.waterBgSprite = nil;
    
    [self updateWaterRecord];
    self.waterWaveSprite = [self waterWaveSpriteWithTextureSprite:self.water1 maskSprite:self.bottleMask rotate:self.rotate];
    self.waterWaveSprite.position = self.prePosition;
    self.waterWaveSprite.anchorPoint = self.preAnchor;
    
    
//    self.waterBgSprite = [self waterBackgroundSpriteWithTextureSprite:self.water1 maskSprite:self.bottleMask rotate:self.rotate];
//    self.waterBgSprite.position = self.prePosition;
//    self.waterBgSprite.anchorPoint = self.preAnchor;
    
    int waterZOrder = WATER_Z_ORDER_START;
    
//    [self addChild:self.waterBgSprite z:waterZOrder++];
    [self addChild:self.waterWaveSprite z:(waterZOrder++)];
    
}
- (void)updateWaterRecord
{
    //更新信息
    for (P4WaterRecord* record in self.waterRecordArray)
    {
        [record updateRecord];
        if (self.fAddWater)
        {
            [record waterUp];
        }
        
        if (record.offset > self.waterFlowTextureWidth)
        {
            record.offset -= self.waterFlowTextureWidth;
        }
        if (record.offset <= 0)
        {
            record.offset += self.waterFlowTextureWidth;
        }
    }
}


- (CCSprite *)waterWaveSpriteWithTextureSprite:(CCSprite *)textureSprite maskSprite:(CCSprite *)maskSprite rotate:(float)radius
{
    float height = 0;
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:maskSprite.texture.contentSize.width height:maskSprite.texture.contentSize.height];
    
    maskSprite.anchorPoint = ccp(0,0);
    textureSprite.anchorPoint = ccp(0,0);
    maskSprite.position = ccp(0,0);
    textureSprite.position = ccp(0,0);
    
    [rt beginWithClear:187.f/255.f g:240.f/255.f b:239.f/255.f a:0];
//187 240 239

    [maskSprite visit];
    
    
    
    for (P4WaterRecord* record in self.waterRecordArray)
    {
        height += record.height;
    }
    
    float preRadius = radius;   //pre为角度
    radius = radius / 180 * M_PI;  //转换为弧度
    
    for (int i = 0; i < self.waterRecordArray.count; i++)
    {
        
//        break;
        
        P4WaterRecord* record = self.waterRecordArray[self.waterRecordArray.count - 1 - i];
        

        float offset = record.offset;
//        height = record.height;
        ccColor3B color = record.color;
        
        textureSprite.scaleY = record.waveScale;
        textureSprite.color = color;
        
        [rt setClearColor:ccc4FFromccc3B(color)];

        
        //    float maskWidth = maskSprite.texture.contentSize.width;
        
        //    float maskHeight = maskSprite.texture.contentSize.height;   // /2
        //    float maskAnchorX = maskSprite.anchorPoint.x;
        //    float maskAnchorY = maskSprite.anchorPoint.y;
        
        //    float maskLeft = maskSprite.position.x - maskWidth * maskAnchorX;
        //    float maskRight = maskLeft + maskWidth;
        //    float maskBottom = maskSprite.position.y - maskHeight * maskAnchorY;
        //    float maskTop = maskBottom + maskHeight;
        
        float textureHeight = textureSprite.texture.contentSize.height * textureSprite.scaleY;
        float textureWidth = textureSprite.texture.contentSize.width;
        //    float textureAnchorY = textureSprite.anchorPoint.y;
        //    float textureBottom = textureSprite.position.y - textureHeight * textureAnchorY;
        //    float textureTop = textureBottom + textureHeight;
        
        //半斤204
        //圆心坐标(181,96)
        
        float lheight = height - textureHeight ;
        

        float xianXinJu = 96 - lheight;
        float xian = sqrt( 204 * 204 - xianXinJu * xianXinJu);
        CGPoint pos = ccp(181 - xianXinJu * sin(radius) - (xian + offset) * cos(radius), 96 - xianXinJu * cos(radius) + (xian + offset) * sin(radius));

        
        
//        CGPoint clearLeftBottom = ccp(pos.x + textureHeight * sin(radius), pos.y + textureHeight * cos(radius));
//        CGPoint clearRightBottom = ccp(clearLeftBottom.x + textureWidth * 2 * cos(radius), clearLeftBottom.y - textureWidth * 2 * sin(radius));
//        float clearHeight = 408;
//        CGPoint clearLeftTop = ccp(clearLeftBottom.x + clearHeight * sin(radius), clearLeftBottom.y + clearHeight * cos(radius));
//        CGPoint clearRightTop = ccp(clearRightBottom.x + clearHeight * sin(radius), clearRightBottom.y + clearHeight * cos(radius));
//        CGPoint clearPoints[4] = {clearLeftBottom, clearLeftTop, clearRightTop, clearRightBottom};
        
        
        float fillHeight = BAN_JIN - xianXinJu;
        CGPoint fillLeftTop = ccp(pos.x - textureWidth * cos(radius), pos.y + textureWidth * sin(radius));
//        fillLeftTop.y += 20;
        CGPoint fillRightTop = ccp(fillLeftTop.x + textureWidth * 3 * cos(radius), fillLeftTop.y - textureWidth * 3 * sin(radius));
        
        
        CGPoint fillLeftBottom = ccp(fillLeftTop.x - fillHeight * sin(radius), fillLeftTop.y - fillHeight * cos(radius));
        
        CGPoint fillRightBottom = ccp(fillLeftBottom.x + textureWidth * 3 * cos(radius), fillLeftBottom.y - textureWidth * 3 * sin(radius));
        
        CGPoint fillPoints[4] = {fillLeftBottom, fillLeftTop, fillRightTop, fillRightBottom};
        
        
        
        textureSprite.position = pos;
        textureSprite.rotation = preRadius;
        [textureSprite visit];
        textureSprite.position = ccp(textureSprite.position.x + textureWidth * cos(radius), textureSprite.position.y - textureWidth * sin(radius));
        
        
//        if (i == 0)
//        {
//            ccDrawSolidPoly(clearPoints, 4, ccc4f(0, 0, 0, 0));
//        }


        [textureSprite visit];
        ccDrawSolidPoly(fillPoints, 4, ccc4FFromccc3B(color));
        height -= record.height;
    }
    
    
    
    [rt end];
    
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    retval.flipY = YES;
    
    
    if (!self.waterRecordArray.count)
    {
        retval.visible = NO;
    }
    
    
    return retval;
    
}
- (CCSprite *)waterBackgroundSpriteWithTextureSprite:(CCSprite*)textureSprite maskSprite:(CCSprite *)maskSprite rotate:(float)radius
{
    float height = 0;
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:maskSprite.texture.contentSize.width height:maskSprite.texture.contentSize.height];
    
    maskSprite.anchorPoint = ccp(0,0);
    maskSprite.position = ccp(0,0);
    textureSprite.anchorPoint = ccp(0,0);
    textureSprite.position = ccp(0,0);
    
    float textureHeight = textureSprite.texture.contentSize.height * textureSprite.scaleY;
    float textureWidth = textureSprite.texture.contentSize.width;
    
    
    [rt beginWithClear:1 g:1 b:1 a:1];
    
//    [maskSprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
    [maskSprite visit];
//    [textureSprite setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ZERO}];

    
    for (P4WaterRecord* record in self.waterRecordArray)
    {
        height += record.height;
    }
    
    float preRadius = radius;   //pre为角度
    radius = radius / 180 * M_PI;  //转换为弧度
    
    for (int i = 0; i < self.waterRecordArray.count; i++)
    {
        P4WaterRecord* record = self.waterRecordArray[self.waterRecordArray.count - 1 - i];
        float offset = record.offset;
        //        height = record.height;
        ccColor3B color = record.color;
        //半斤204
        //圆心坐标(181,96)
        height -= record.height;
        
        
        float lheight = height /*- textureHeight*/ ;
        

        float xianXinJu = 96 - lheight;
        float xian = sqrt( 204 * 204 - xianXinJu * xianXinJu);
        CGPoint pos = ccp(181 - xianXinJu * sin(radius) - (xian + offset) * cos(radius),
                          96 - xianXinJu * cos(radius) + (xian + offset) * sin(radius));
        
        
        float fillHeight = BAN_JIN - xianXinJu;
        CGPoint fillLeftTop = pos;

        fillLeftTop = ccp(fillLeftTop.x - textureWidth  * cos(radius), fillLeftTop.y + textureWidth  * sin(radius));
        CGPoint fillRightTop = ccp(fillLeftTop.x + textureWidth * 3 * cos(radius), fillLeftTop.y - textureWidth * 3 * sin(radius));

        
        
        CGPoint fillLeftBottom = ccp(fillLeftTop.x - fillHeight * sin(radius), fillLeftTop.y - fillHeight * cos(radius));
        
        CGPoint fillRightBottom = ccp(fillLeftBottom.x + textureWidth * 3 * cos(radius), fillLeftBottom.y - textureWidth * 3 * sin(radius));
        
        

        CGPoint fillPoints[4] = {fillLeftBottom, fillLeftTop, fillRightTop, fillRightBottom};
        
        

        
        if (i == 0)
        {
            
            CGPoint clearLeftBottom = ccp(pos.x + textureHeight * sin(radius), pos.y + textureHeight * cos(radius));
            CGPoint clearRightBottom = ccp(clearLeftBottom.x + textureWidth * 2 * cos(radius), clearLeftBottom.y - textureWidth * 2 * sin(radius));
            float clearHeight = 408;
            CGPoint clearLeftTop = ccp(clearLeftBottom.x + clearHeight * sin(radius), clearLeftBottom.y + clearHeight * cos(radius));
            CGPoint clearRightTop = ccp(clearRightBottom.x + clearHeight * sin(radius), clearRightBottom.y + clearHeight * cos(radius));
            
            CGPoint clearPoints[4] = {fillLeftTop, clearLeftTop, clearRightTop, fillRightTop};
            textureSprite.position = pos;
            textureSprite.rotation = preRadius;
            [textureSprite visit];
            textureSprite.position = ccp(textureSprite.position.x + textureWidth * cos(radius), textureSprite.position.y - textureWidth * sin(radius));
            [textureSprite visit];
            ccDrawSolidPoly(clearPoints, 4, ccc4f(0, 0, 0, 0));
        }
        
        
        ccDrawSolidPoly(fillPoints, 4, ccc4FFromccc3B(color));

    }
    
    [rt end];
    
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    retval.flipY = YES;
    
    if (!self.waterRecordArray.count)
    {
        retval.visible = NO;
    }
    return retval;
}


#pragma mark - Add And Release Water
- (void)beginAddWater:(ccColor3B)waterColor isRight:(BOOL)fIsRight
{

    self.fAddWater = YES;
    self.addWaterColor = waterColor;
    self.addWaterIsRight = fIsRight;
    
    ccColor4F color = ccc4f(waterColor.r / 255.f, waterColor.g / 255.f, waterColor.b / 255.f, 1.f);
    self.sprayLeft.startColor = color;
    self.sprayLeft.endColor = color;
    self.sprayRight.startColor = color;
    self.sprayRight.endColor = color;
    [self.sprayLeft resetSystem];
    [self.sprayRight resetSystem];
}
- (void)endAddWater
{
    self.fAddWater = NO;
    [self.sprayLeft stopSystem];
    [self.sprayRight stopSystem];
}
- (void)addWaterWithColor:(ccColor3B)waterColor
{
    P4WaterRecord* waterRecord = nil;
    P4WaterRecord* r = [self.waterRecordArray lastObject];

    if (r.color.r == waterColor.r && r.color.g == waterColor.g && r.color.b == waterColor.b)
    {
        waterRecord = r;
    }

    
    if (!waterRecord)
    {
        waterRecord = [[[P4WaterRecord alloc] init] autorelease];
        waterRecord.color = waterColor;
        if (self.waterRecordArray.count)
        {
            waterRecord.height = 5.f;
        }
        [self.waterRecordArray addObject:waterRecord];
    }
    waterRecord.height += ADD_WATER_SPEED;
    
    //更新水花粒子位置、倒入粒子生命
    [self waterHeightChange:[self getWaterHeight]];
    [self.delegate waterHeightChange:[self getWaterHeight]];
}
- (void)worldSceneConfigure
{
    P4WaterRecord* waterRecord = [[[P4WaterRecord alloc] init] autorelease];
    waterRecord.color = ccc3(50.f, 248.f, 255.f);
    waterRecord.height = 60.f;
    waterRecord.waveScaleLowest = 0.5f;
    waterRecord.waveScale = 0.5f;
    waterRecord.flowSpeed = 2.f;
    waterRecord.flowSpeedMin = 2.f;
    [self.waterRecordArray addObject:waterRecord];
}

- (void)waterReleaseSoundUpdate
{
    if (self.fReleaseWater)
    {
        [[SimpleAudioEngine sharedEngine] stopEffect:self.waterReleaseSoundId];
        self.waterReleaseSoundId = 0;
        self.waterReleaseSoundId = [[SimpleAudioEngine sharedEngine] playEffect:@"p4_monster_shake.mp3"];
        [self performSelector:@selector(waterReleaseSoundUpdate) withObject:nil afterDelay:11.f];
    }
}


- (void)waterReleaseSoundStop
{
    if (!self.fWaterReleaseStopSchedule)
    {
        [[CCDirector sharedDirector].scheduler scheduleSelector:@selector(waterReleaseSoundStopUpdate) forTarget:self interval:0.045f paused:NO];
        self.fWaterReleaseStopSchedule = YES;
    }

}
- (void)resumeEffectVolume
{
    [SimpleAudioEngine sharedEngine].effectsVolume = 1.f;
}
- (void)waterReleaseSoundStopUpdate
{
    float volume = [SimpleAudioEngine sharedEngine].effectsVolume;
    volume -= 0.03f;
    if (volume < 0.f)
    {
        [[SimpleAudioEngine sharedEngine] stopEffect:self.waterReleaseSoundId];
        [self performSelector:@selector(resumeEffectVolume) withObject:nil afterDelay:0.05f];

        self.waterReleaseSoundId = 0;
        [[CCDirector sharedDirector].scheduler unscheduleSelector:@selector(waterReleaseSoundStopUpdate) forTarget:self];
        self.fWaterReleaseStopSchedule = NO;
    }
    else
    {
        [SimpleAudioEngine sharedEngine].effectsVolume = volume;
    }
}

- (void)beginReleaseWater
{
    if (self.waterRecordArray.count)
    {
        self.waterReleaseSoundId = [[SimpleAudioEngine sharedEngine] playEffect:@"p4_monster_shake.mp3"];
    }
    [self performSelector:@selector(waterReleaseSoundUpdate) withObject:nil afterDelay:11.f];
    
    
    if (self.waterRecordArray.count)
    {
        self.fReleaseWater = YES;
        P4WaterRecord* record = self.waterRecordArray[0];
        [self.delegate startWaterOut:record.color];
    }
    
    //移除屏幕上的泡泡
    while (self.onScreenBubbles.count)
    {
        CCSprite* sprite = self.onScreenBubbles[0];
        [sprite removeFromParentAndCleanup:YES];
        [self.offScreenBubbles addObject:sprite];
        [self.onScreenBubbles removeObject:sprite];
    }
    
}
- (void)releaseWater
{
    if (self.fReleaseWater)
    {
        if (self.waterRecordArray.count)
        {
            if (self.waterRecordArray.count <= 1)
            {
                //End Release Water
                [self waterReleaseSoundStop];
            }
            P4WaterRecord* record = self.waterRecordArray[0];
            record.height -= 2;
            if (record.height < 0)
            {
                [self.waterRecordArray removeObjectAtIndex:0];
                
                if (self.waterRecordArray.count)
                {
                    P4WaterRecord* record = self.waterRecordArray[0];
                    [self.delegate waterOutColorChange:record.color];
                }
            }
        }
        else
        {
            
            self.fReleaseWater = NO;
            [self.delegate endWaterOut];
        }
        
        //更新水花粒子位置、倒入粒子生命
        [self waterHeightChange:[self getWaterHeight]];
        [self.delegate waterHeightChange:[self getWaterHeight]];
    }
}

#pragma mark - Merge Record
- (void)mergeWaterRecord
{
    for (int i = 0; i < self.waterRecordArray.count; i++)
    {
        if (i == self.waterRecordArray.count - 1)
        {
            break;
        }
        P4WaterRecord* record1 = self.waterRecordArray[i];
        P4WaterRecord* record2 = self.waterRecordArray[i + 1];
        if ([record2 mergeRecord:record1])
        {
            [self.waterRecordArray removeObject:record1];
            --i;
        }
    }
}

- (void)mergeWater
{
    if (!self.isMergingWater)
    {
        self.isMergingWater = YES;
        
        float aveR, aveG, aveB, totalR = 0, totalG = 0, totalB = 0, totalHeight = 0.f;
        for (P4WaterRecord* record in self.waterRecordArray)
        {
            totalR += record.color.r * record.height;
            totalG += record.color.g * record.height;
            totalB += record.color.b * record.height;
            totalHeight += record.height;
        }
        aveR = totalR / totalHeight;
        aveG = totalG / totalHeight;
        aveB = totalB / totalHeight;
       
        ccColor3B finalColor;
        if (self.waterRecordArray.count <= 1)
        {
            finalColor = ccc3(aveR, aveG, aveB);
        }
        else
        {
            finalColor = [self adjustColorR:aveR g:aveG b:aveB];
        }
        
        for (P4WaterRecord* record in self.waterRecordArray)
        {
            record.colorTo = finalColor;
            record.isChangeColor = YES;
        }
    }
}

- (ccColor3B)adjustColorR:(float)aveR g:(float)aveG b:(float)aveB
{
    
    //RGB转HSV
    float maxRGB = maxThree(aveR, aveG, aveB);
    float minRGB = minThree(aveR, aveG, aveB);
    
    float h, s, v;
    
    //h
    if (ABS(maxRGB - minRGB) <= 0.01)
    {
        h = 0;
    }
    else if (ABS(maxRGB - aveR) <= 0.01)
    {
        if (aveG >= aveB)
        {
            h = 60 * (aveG - aveB) / (maxRGB - minRGB);
        }
        else
        {
            h = 60 * (aveG - aveB) / (maxRGB - minRGB) + 360;
        }
    }
    else if (ABS(maxRGB - aveG) <= 0.01)
    {
        h = 60 * (aveB - aveR) / (maxRGB - minRGB) + 120;
    }
    else
    {
        h = 60 * (aveR - aveG) / (maxRGB - minRGB) + 240;
    }
    
    //s
    if (ABS(maxRGB) <= 0.01 )
    {
        s = 0;
    }
    else
    {
        s = (maxRGB - minRGB) / maxRGB;
    }
    
    v = maxRGB;
    
    
    //颜色调整
    if (h < 200)
    {
        //            h += 100;
        h *= 1.6;
    }
    
    
    //HSV转RGB
    float finalR, finalG, finalB;
    
    int hi = ((int)h / 60) % 6;
    float f = h / 60 - hi;
    float p = v * (1 - s);
    float q = v * (1 - f * s);
    float t = v * (1 - (1 - f) * s);
    
    switch (hi)
    {
        case 0:
        {
            //vtp
            finalR = v;
            finalG = t;
            finalB = p;
            break;
        }
        case 1:
        {
            //qvp
            finalR = q;
            finalG = v;
            finalB = p;
            break;
        }
        case 2:
        {
            //pvt
            finalR = p;
            finalG = v;
            finalB = t;
            break;
        }
        case 3:
        {
            //pqv
            finalR = p;
            finalG = q;
            finalB = v;
            break;
        }
        case 4:
        {
            //tpv
            finalR = t;
            finalG = p;
            finalB = v;
            break;
        }
        case 5:
        default:
        {
            //vpq
            finalR = v;
            finalG = p;
            finalB = q;
            break;
        }
            
    }
    
//    CCLOG(@"r:%f,g:%f,b:%f",aveR,aveG,aveB);
//    CCLOG(@"adjust:r:%f,g:%f,b:%f",finalR,finalG,finalB);
    return ccc3(finalR, finalG, finalB);
}


#pragma mark - Rotate

- (void)updateRotate
{
    if (ABS(self.rotateTo) < 0.001 && ABS(self.rotateTo - self.rotate) < 0.001)
    {
        return;
    }
    
    float absRotate = ABS(self.rotate);
    float absRotateTo = ABS(self.rotateTo);
    
    float rotateSpeed = 0.5 + (absRotateTo - absRotate) * ROTATE_SPEED_BASE ;
    if (self.rotateTo < self.rotate)
    {
        self.rotate -= rotateSpeed;
        if (self.rotate < self.rotateTo)
        {
            self.rotate = self.rotateTo;
        }
    }
    else
    {
        self.rotate += rotateSpeed;
        if (self.rotate > self.rotateTo)
        {
            self.rotate = self.rotateTo;
        }
    }
    if (ABS(self.rotateTo - self.rotate) < 0.3 )
    {
        self.rotate = self.rotateTo;
        self.rotateTo = - ROTATE_REDUCE_RATE * self.rotateTo;
    }
    [self checkWaterRotateMinAndMax];
}

- (void)checkWaterRotateMinAndMax
{
    self.rotate = [self checkWaterRotateMinAndMaxHelper:self.rotate];
    self.rotateTo = [self checkWaterRotateMinAndMaxHelper:self.rotateTo];
    if (ABS(self.rotateTo) < 4)
    {
        self.rotateTo = 0;
    }
    
}
- (float)checkWaterRotateMinAndMaxHelper:(float)currentDegree
{
    BOOL fMinu = NO;
    if (currentDegree < 0)
    {
        fMinu = YES;
        currentDegree = -currentDegree;
    }
    currentDegree = currentDegree > ROTATE_MAX? ROTATE_MAX : currentDegree;
    if (fMinu)
    {
        currentDegree = -currentDegree;
    }
    return currentDegree;
}

#pragma mark - Water Move
- (void)waterMoveWithDeltaX:(float)deltaX deltaY:(float)deltaY
{
    float rate = sqrt(deltaX * deltaX + deltaY * deltaY);
    if (deltaX > 0)
    {
        self.rotateTo += rate;
    }
    else
    {
        self.rotateTo -= rate;
    }
    [self checkWaterRotateMinAndMax];
    
    
    for (P4WaterRecord* record in self.waterRecordArray)
    {
        [record waterMoveWithDeltaX:deltaX deltaY:deltaY];
    }
}

- (void)waterHeightChange:(float)height
{
    float radio = -0.2f;
    float deltaX = height * radio;
    height = height - 15.f;
    
    CGPoint leftSprayPrePos = self.addWaterIsRight? self.leftSprayPrePositionL : self.leftSprayPrePositionR;
    CGPoint rightSprayPrePos = self.addWaterIsRight? self.rightSprayPrePositionL : self.rightSprayPrePositionR;
    
    deltaX = self.addWaterIsRight? -deltaX: deltaX;
    
    self.sprayLeft.position = ccp(leftSprayPrePos.x + deltaX, leftSprayPrePos.y + height);
    self.sprayRight.position = ccp(rightSprayPrePos.x + deltaX, rightSprayPrePos.y + height);
}

- (float)getWaterHeight
{
    float height = 0;
    for (P4WaterRecord* r in self.waterRecordArray)
    {
        height += r.height;
    }
    return height;
}

#pragma mark - Bubble
//半斤204
//圆心坐标(181,96)
- (void)bubbleUpdate:(float)dt
{
//    CGPoint yuanXin = ccp(YUAN_XIN_XIANGDUI.x + self.preMaskLeftBottom.x, YUAN_XIN_XIANGDUI.y + self.preMaskLeftBottom.y);
//    CCSprite* sprite = [[CCSprite alloc] initWithFile:@"P4water_particle.png"];
//    sprite.position = yuanXin;
//    [self addChild:sprite z:BUBBLE_Z_ORDER];
    [self makeNewBubbleScaleRate:1.f speedRate:1.f];
}

- (void)makeNewBubbleScaleRate:(float)scaleRate speedRate:(float)speedRate
{
    //Start Point
    float banjin = BAN_JIN * CCRANDOM_0_1();
    float hudu = M_PI * 2 * CCRANDOM_0_1();
    
//    CGPoint yuanXin = ccp(YUAN_XIN_XIANGDUI.x + self.preMaskLeftBottom.x, YUAN_XIN_XIANGDUI.y + self.preMaskLeftBottom.y);
    CGPoint yuanXin = ccp(self.prePosition.x, YUAN_XIN_XIANGDUI.y + self.preMaskLeftBottom.y);
    
    CGPoint startPoint = ccp(yuanXin.x + banjin * sin(hudu),yuanXin.y + banjin * cos(hudu));
//    if (!CGRectContainsPoint([self.bottleMask getRect], startPoint))
//    {
//        return;
//    }
    float waterHeight = [self getWaterHeight] + BAN_JIN - (yuanXin.y - self.preMaskLeftBottom.y);
    
    if (startPoint.y - yuanXin.y + BAN_JIN > waterHeight)
    {
        float height = waterHeight * CCRANDOM_0_1() * 0.5;
        startPoint.y = height + yuanXin.y - BAN_JIN;
        
//        return;
    }

    float boHeight = sqrt(BAN_JIN * BAN_JIN - (yuanXin.x - startPoint.x) * (yuanXin.x - startPoint.x)) + BAN_JIN;

    float endHeight = boHeight < waterHeight ? boHeight : waterHeight;
    endHeight -= 20;
//
    CGPoint endPoint = ccp(startPoint.x, yuanXin.y + endHeight - BAN_JIN);
    
    CCSprite* sprite = nil;
    if (self.offScreenBubbles.count)
    {
        sprite = self.offScreenBubbles[0];
        [sprite retain];
        [sprite autorelease];
        [self.offScreenBubbles removeObject:sprite];
    }
    else
    {
        sprite = [[[CCSprite alloc] initWithFile:@"P4water_particle.png"] autorelease];
    }
    
    sprite.scale = CCRANDOM_0_1() * scaleRate;
    sprite.position = startPoint;
    __unsafe_unretained P4WaterLayer* weakSelf = self;
    CCMoveTo* moveTo = [[[CCMoveTo alloc] initWithDuration:((endPoint.y - startPoint.y) / ((BUBBLE_SPEED + 20 * CCRANDOM_0_1()) * speedRate)) position:endPoint] autorelease];
    CCCallBlock* call = [[[CCCallBlock alloc] initWithBlock:^{
        [sprite removeFromParent];
        [weakSelf.offScreenBubbles addObject:sprite];
        [weakSelf.onScreenBubbles removeObject:sprite];
    }] autorelease];
    [self addChild:sprite z:BUBBLE_Z_ORDER];
    [self.onScreenBubbles addObject:sprite];
    [sprite runAction:[[[CCSequence alloc] initOne:moveTo two:call] autorelease]];
}


#pragma mark - Life Cycle
- (void)onExit
{
    [super onExit];
    self.bottleMask = nil;
    self.water1 = nil;
    self.water2 = nil;
    self.sprayLeft = nil;
    self.sprayRight = nil;
    
    self.waterWaveSprite = nil;
    self.waterBgSprite = nil;
//    self.sprayLeft = nil;
//    self.sprayRight = nil;
    [self.offScreenBubbles removeAllObjects];
    self.offScreenBubbles = nil;
    [self.onScreenBubbles removeAllObjects];
    self.onScreenBubbles = nil;
    [self removeAllChildrenWithCleanup:YES];

    [self.waterRecordArray removeAllObjects];
    self.waterRecordArray = nil;
    
}

@end
