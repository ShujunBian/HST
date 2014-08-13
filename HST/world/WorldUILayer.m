//
//  WorldUILayer.m
//  HST
//
//  Created by Emerson on 14-8-12.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "WorldUILayer.h"
#import "CCLayerColor+CCLayerColorAnimation.h"

@interface WorldUILayer ()

@property (nonatomic, strong) CCNode * uiNode;
@property (nonatomic, strong) CCLayerColor * shadowLayer;
@property (nonatomic) BOOL isShowing;

@end

@implementation WorldUILayer

- (id)initWithMainMapType:(MainMapType)currentMainMapType
{
    if (self = [super init]) {
        self.currentMainMapType = currentMainMapType;
        [self setTouchEnabled:YES];
        [[[CCDirector sharedDirector]touchDispatcher] addTargetedDelegate:self priority:-10 swallowsTouches:YES];
        self.isShowing = YES;

        self.shadowLayer = [CCLayerColor layerWithColor:ccc4(0.0, 0.0,0.0, 0.0 * 255.0)];
        [self addChild:_shadowLayer z:-1];
        [_shadowLayer fadeIn];
        [self addMainMapUIByType:0];
    }
    return self;
}
-(id)init
{
    if (self = [super init]) {

    }
    return self;
}

#pragma mark - 大地图UI动画
- (void)addMainMapUIByType:(MainMapType)mainmapType
{
    NSString * firstLine, * secondLine, * levelString;
    switch (_currentMainMapType) {
        case MainMapP1:{
            firstLine = @"Alex is designed for building basic";
            secondLine = @"sense of tone and color for kids.";
            levelString = @"Basic";
            break;
        }
        case MainMapP2:{
            firstLine = @"Bart helps kids building their rhythm";
            secondLine = @"sensation and reaction.";
            levelString = @"Normal";
            break;
        }
        case MainMapP3:{
            firstLine = @"Carl is designed for training basic";
            secondLine = @"sense of sound pitch and chorus.";
            levelString = @"Medium";
            break;
        }
        case MainMapP4:{
            firstLine = @"Mixer helps kids knowing about color";
            secondLine = @"and sound toning and mixing.";
            levelString = @"Medium";
            break;
        }
        case MainMapP5:{
            firstLine = @"Evan is designed for basic logic and";
            secondLine = @"composing training for kids.";
            levelString = @"Hard";
            break;
        }
        default:
            break;
    }
    
    
    self.uiNode = [[CCNode alloc]init];
    [self.uiNode setPosition:CGPointMake(512.0, 384.0)];
    [self.uiNode setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    CCSprite * uibg = [CCSprite spriteWithFile:@"MainMapUIBg.png"];
    [uibg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uibg setPosition:CGPointMake(504 - 512.0, 415 - 384.0)];
    [uibg setScale:0.0];
    [_uiNode addChild:uibg];
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * bgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2, nil];
    [uibg runAction:bgSeq];
    
    CCSprite * uiName = [CCSprite spriteWithFile:[NSString stringWithFormat:@"MainMap_P%dName.png",_currentMainMapType]];
    [uiName setPosition:CGPointMake(494.0 - 512.0, 608.0 - 384.0)];
    [uiName setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiName setScale:0.0];
    [_uiNode addChild:uiName];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiName afterDelay:0.2];
    
    CCSprite * uiButton = [CCSprite spriteWithFile:@"MainMapPlayButton.png"];
    [uiButton setPosition:CGPointMake(512.0 - 512.0, 234.0 - 384.0)];
    [uiButton setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiButton setScale:0.0];
    [_uiNode addChild:uiButton];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiButton afterDelay:0.4];
    [self performSelector:@selector(shakeDialogIcon:) withObject:uiButton afterDelay:1.25];
    
    CCSprite * uiImage = [CCSprite spriteWithFile:[NSString stringWithFormat:@"MainMap_P%dImage.png",_currentMainMapType]];
    [uiImage setPosition:CGPointMake(300.0 - 512.0, 478.0 - 384.0)];
    [uiImage setAnchorPoint:CGPointMake(0.5, 0.5)];
    [uiImage setScale:0.0];
    [_uiNode addChild:uiImage];
    [self performSelector:@selector(mainmapUIScaleAnimation:) withObject:uiImage afterDelay:0.4];
    
    CCLabelTTF * uilabel1 = [CCLabelTTF labelWithString:@"To Moms & Dads:" fontName:@"Kankin" fontSize:32.0];
    [uilabel1 setPosition:CGPointMake(510.0 - 512.0, 498.0 - 384.0)];
    [uilabel1 setColor:ccc3(255.0, 130.0, 130.0)];
    [_uiNode addChild:uilabel1];
    
    CCLabelTTF * uilabel2 = [CCLabelTTF labelWithString:firstLine fontName:@"Kankin" fontSize:24.0];
    [uilabel2 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel2 setPosition:CGPointMake(403.0 - 512.0, 444.0 - 384.0)];
    [uilabel2 setColor:ccc3(150.0, 150.0, 150.0)];
    [_uiNode addChild:uilabel2];
    
    CCLabelTTF * uilabel3 = [CCLabelTTF labelWithString:secondLine fontName:@"Kankin" fontSize:24.0];
    [uilabel3 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel3 setPosition:CGPointMake(403.0 - 512.0, 415.0 - 384.0)];
    [uilabel3 setColor:ccc3(150.0, 150.0, 150.0)];
    [_uiNode addChild:uilabel3];
    
    CCLabelTTF * uilabel4 = [CCLabelTTF labelWithString:@"Level:" fontName:@"Kankin" fontSize:24.0];
    [uilabel4 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel4 setPosition:CGPointMake(403.0 - 512.0, 358.0 - 384.0)];
    [uilabel4 setColor:ccc3(150.0, 150.0, 150.0)];
    [_uiNode addChild:uilabel4];
    
    CCLabelTTF * uilabel5 = [CCLabelTTF labelWithString:levelString fontName:@"Kankin" fontSize:24.0];
    [uilabel5 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel5 setPosition:CGPointMake(466.0 - 512.0, 358.0 - 384.0)];
    [uilabel5 setColor:ccc3(89.0, 227.0, 0.0)];
    [_uiNode addChild:uilabel5];
    
    [self addChild:_uiNode];
}

- (void)mainmapUIScaleAnimation:(CCNode *)node
{
    CCScaleTo * uibgScaleTo1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo * uibgScaleTo2 = [CCScaleTo actionWithDuration:0.2 scale:0.85];
    CCScaleTo * uibgScaleTo3 = [CCScaleTo actionWithDuration:0.15 scale:1.1];
    CCScaleTo * uibgScaleTo4 = [CCScaleTo actionWithDuration:0.15 scale:0.95];
    CCScaleTo * uibgScaleTo5 = [CCScaleTo actionWithDuration:0.1 scale:1.0];
    CCSequence * uibgSeq = [CCSequence actions:uibgScaleTo1,uibgScaleTo2,uibgScaleTo3,uibgScaleTo4,uibgScaleTo5, nil];
    [node runAction:uibgSeq];
}

- (void)shakeDialogIcon:(CCNode *)node
{
    float moveLength = 2.f;
    float moveDuration = 0.5f;
    CCMoveBy* moveBy1 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCMoveBy* moveBy2 = [CCMoveBy actionWithDuration:moveDuration * 2 position:ccp(0, moveLength * 2)];
    CCMoveBy* moveBy3 = [CCMoveBy actionWithDuration:moveDuration position:ccp(0, -moveLength)];
    CCSequence* moveSequence =
    [CCSequence actions:
     [CCDelayTime actionWithDuration:CCRANDOM_0_1() * 0.5],
     [CCEaseSineOut actionWithAction:moveBy1],
     [CCEaseSineInOut actionWithAction:moveBy2],
     [CCEaseSineIn actionWithAction:moveBy3],
     nil];
    CCRepeatForever* moveRepeat = [CCRepeatForever actionWithAction:moveSequence];
    [node runAction:moveRepeat];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_isShowing) {
        _isShowing = NO;
        [_shadowLayer fadeOut];
        
        CCScaleTo * scaleTo = [CCScaleTo actionWithDuration:0.2 scale:1.2];
        CCScaleTo * scaleDisappera = [CCScaleTo actionWithDuration:0.3 scale:0.0];
        CCCallBlock * callBack = [CCCallBlock actionWithBlock:^{
            //            self.shadowLayer = nil;
            //            self.uiNode = nil;
            [self.parent removeChild:self cleanup:YES];
            [self.delegate removeFromWorldLayer];
        }];
        CCSequence * seq = [CCSequence actions:scaleTo,scaleDisappera,callBack, nil];
        
        [_uiNode runAction:seq];
    }
    return YES;
}

- (void)dealloc
{
    [super dealloc];

    self.shadowLayer = nil;
    self.uiNode = nil;
}

@end
