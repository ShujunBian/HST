//
//  P4CloudTop.m
//  hst_p4
//
//  Created by wxy325 on 1/17/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "P4Cloud.h"
#import "cocos2d.h"

@interface P4Cloud()

@property (assign, nonatomic) CGPoint leftInitPosition;
@property (assign, nonatomic) CGPoint rightInitPosition;

@end


@implementation P4Cloud

- (void)startAnimationWithDuration:(float)duration
{
    CCMoveBy* leftMoveBy = [[CCMoveBy alloc] initWithDuration:duration position:ccp(self.leftInitPosition.x - self.rightInitPosition.x, 0)];
    
    CCMoveTo* leftMoveTo = [[CCMoveTo alloc] initWithDuration:0 position:self.leftInitPosition];
    CCAction* leftRepeat = [[CCRepeatForever alloc] initWithAction:[[CCSequence alloc] initOne:leftMoveBy two:leftMoveTo]];
    [self.leftCloudSprite runAction:leftRepeat];
    
    CCMoveBy* rightMoveBy = [[CCMoveBy alloc] initWithDuration:duration position:ccp(self.leftInitPosition.x - self.rightInitPosition.x, 0)];
    CCMoveTo* rightMoveTo = [[CCMoveTo alloc] initWithDuration:0 position:self.rightInitPosition];
    CCAction* rightRepeat = [[CCRepeatForever alloc] initWithAction:[[CCSequence alloc] initOne:rightMoveBy two:rightMoveTo]];
    [self.rightCloudSprite runAction:rightRepeat];
}

- (void) didLoadFromCCB
{
    self.leftInitPosition = self.leftCloudSprite.position;
    self.rightInitPosition = self.rightCloudSprite.position;
}
@end
