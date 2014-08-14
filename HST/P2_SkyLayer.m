//
//  SkyLayer.m
//  town
//
//  Created by Emerson on 13-7-28.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_SkyLayer.h"

@interface P2_SkyLayer()

@property (nonatomic, strong) CCSprite * mountain1;
@property (nonatomic, strong) CCSprite * mountian1Next;
@property (nonatomic, strong) CCSprite * mountain2;
@property (nonatomic, strong) CCSprite * mountian2Next;

@property (nonatomic) float mountain2Speed;
@property (nonatomic) float mountain1Speed;

@end


@implementation P2_SkyLayer

@synthesize upperCloud;
@synthesize upperCloud2;

-(id) init
{
	if( (self=[super init]))
    {
        self.isWaitingForSelect = YES;
        
        self.mountain1 = [CCSprite spriteWithFile:@"p2_mountain1.png"];
        self.mountian1Next = [CCSprite spriteWithFile:@"p2_mountain1.png"];
        self.mountain2 = [CCSprite spriteWithFile:@"p2_mountain2.png"];
        self.mountian2Next = [CCSprite spriteWithFile:@"p2_mountain2.png"];
        
        [self.mountain1 setPosition:CGPointMake(581.5, 191.5)];
        [self.mountain1 setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self.mountian1Next setPosition:CGPointMake(1746.5, 192.5)];
        [self.mountian1Next setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self.mountain2 setPosition:CGPointMake(581.5, 180.5)];
        [self.mountain2 setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self.mountian2Next setPosition:CGPointMake(1746.5, 181.5)];
        [self.mountian2Next setAnchorPoint:CGPointMake(0.5, 0.5)];
        
        [self addChild:self.mountain1 z:1];
        [self addChild:self.mountain2 z:2];
        [self addChild:self.mountian1Next z:1];
        [self addChild:self.mountian2Next z:2];

        _mountain1Speed = 1165.0 / 32.0 / 60.0;
        _mountain2Speed = 1165.0 / 16.0 / 60.0;
        
        [self scheduleUpdate];
	}
	return self;
}

- (void) didLoadFromCCB
{
   
}


-(void) update:(ccTime)delta
{
    if (!_isWaitingForSelect) {
        [self.mountain1 setPosition:CGPointMake(_mountain1.position.x - _mountain1Speed, _mountain1.position.y)];
        [self.mountian1Next setPosition:CGPointMake(_mountian1Next.position.x - _mountain1Speed, _mountian1Next.position.y)];
        [self.mountain2 setPosition:CGPointMake(_mountain2.position.x - _mountain2Speed, _mountain2.position.y)];
        [self.mountian2Next setPosition:CGPointMake(_mountian2Next.position.x - _mountain2Speed, _mountian2Next.position.y)];

        self.upperCloud.position = ccp(self.upperCloud.position.x - 100 * delta, self.upperCloud.position.y);
        self.upperCloud2.position = ccp(self.upperCloud2.position.x - 100 * delta, self.upperCloud2.position.y);
    }
    else {
        self.upperCloud.position = ccp(self.upperCloud.position.x - 5 * delta, self.upperCloud.position.y);
        self.upperCloud2.position = ccp(self.upperCloud2.position.x - 5 * delta, self.upperCloud2.position.y);
    }


    if(self.upperCloud.position.x + self.upperCloud.boundingBox.size.width < 0)
    {
        self.upperCloud.position = ccp(self.upperCloud2.position.x + self.upperCloud2.boundingBox.size.width, self.upperCloud.position.y);
    }
    else if(self.upperCloud2.position.x + self.upperCloud2.boundingBox.size.width < 0)
    {
        self.upperCloud2.position = ccp(self.upperCloud.position.x + self.upperCloud.boundingBox.size.width, self.upperCloud2.position.y);
    }
    else if (self.mountain1.position.x <= -583.5)
    {
        [self.mountain1 setPosition:CGPointMake(581.5, 191.5)];
        [self.mountian1Next setPosition:CGPointMake(1746.5, 192.5)];
    }
    else if (self.mountain2.position.x <= -583.5)
    {
        [self.mountain2 setPosition:CGPointMake(581.5, 180.5)];
        [self.mountian2Next setPosition:CGPointMake(1746.5, 181.5)];
    }
    
}

- (void)dealloc
{
    [super dealloc];
    
#warning 添加以下代码会崩溃
    /*
    self.mountain1 = nil;
    self.mountain2 = nil;
    self.mountian1Next = nil;
    self.mountian2Next = nil;
     */
}

@end
