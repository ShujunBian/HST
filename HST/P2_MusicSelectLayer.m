//
//  P2_MusicSelectLayer.m
//  HST
//
//  Created by Emerson on 14-8-14.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P2_MusicSelectLayer.h"
#import "P2_UINode.h"

@interface P2_MusicSelectLayer()

@property (nonatomic, strong) CCLayerColor * shadowLayer;
@property (nonatomic, strong) NSMutableArray * uiNodeArray;

@end

@implementation P2_MusicSelectLayer


-(id)init
{
    if (self = [super init]) {
        self.uiNodeArray = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

- (void)addP2SelectSongUI
{
    [self setTouchEnabled:YES];
    [[[CCDirector sharedDirector]touchDispatcher] addTargetedDelegate:self priority:-10 swallowsTouches:YES];
    
    self.shadowLayer = [CCLayerColor layerWithColor:ccc4(0.0, 0.0,0.0, 0.0 * 255.0)];
    [self addChild:_shadowLayer z:-1];
    [_shadowLayer fadeIn];
    
    CCLabelTTF * uilabel6 = [CCLabelTTF labelWithString:@"Select a" fontName:@"Kankin" fontSize:30.0];
    [uilabel6 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel6 setPosition:CGPointMake(403.0, 689.0)];
    [uilabel6 setColor:ccc3(255.0, 255.0, 255.0)];
    [uilabel6 setOpacity:0];
    [self addChild:uilabel6];
    [self performSelector:@selector(p2UILabelFadeInAnimation:) withObject:uilabel6 afterDelay:0.2];
    
    CCLabelTTF * uilabel7 = [CCLabelTTF labelWithString:@"Song Track" fontName:@"Kankin" fontSize:30.0];
    [uilabel7 setAnchorPoint:CGPointMake(0.0, 0.0)];
    [uilabel7 setPosition:CGPointMake(504.0, 689.0)];
    [uilabel7 setColor:ccc3(255.0, 192.0, 0.0)];
    [uilabel7 setOpacity:0];
    [self addChild:uilabel7];
    [self performSelector:@selector(p2UILabelFadeInAnimation:) withObject:uilabel7 afterDelay:0.2];
    
    for (int i = 0; i < 2; ++ i) {
        P2_UINode * uiNode = [[[P2_UINode alloc]initWithUINumber:i]autorelease];
        [self.uiNodeArray addObject:uiNode];
        
        [uiNode setAnchorPoint:CGPointMake(0.5, 0.5)];
        [uiNode setPosition:musicSelectPoint[i]];
        [self addChild:uiNode];
    }
}

- (void)p2UILabelFadeInAnimation:(CCLabelTTF *)label
{
    CCFadeIn * fadeIn = [CCFadeIn actionWithDuration:0.5];
    [label runAction:fadeIn];
}
@end
