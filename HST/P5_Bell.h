//
//  P5_Bell.h
//  Dig
//
//  Created by Emerson on 14-1-26.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"

@interface P5_Bell : CCNode

typedef enum {
    BellNormalMode,
    BellQuickMode,
} BellMode;

typedef enum {
    PartBellBody,
    PartBellEye,
    PartBellMouth,
    PartBellHead
} BellPart;


@property (nonatomic, strong) CCSprite * bellBody;
@property (nonatomic, strong) CCSprite * bellHead;
@property (nonatomic, strong) CCSprite * bellMouth;
@property (nonatomic, strong) CCSprite * bellEye;
@property (nonatomic) BOOL isChoosen;

- (ccColor3B)colorAtIndex:(NSUInteger)index;
- (void)setBodyColor:(ccColor3B)color;
- (void)restartBellToMode:(NSNumber *)bellNumber;
- (void)bellNormalAction;

@end
