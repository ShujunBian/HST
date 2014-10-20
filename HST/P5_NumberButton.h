//
//  P5_NumberButton.h
//  HST
//
//  Created by wxy325 on 10/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCNode.h"

@interface P5_NumberButton : CCNode

@property (strong, nonatomic) CCLabelTTF* numberLabel;
@property (assign, nonatomic) BOOL selected;

- (CGRect)getRect;

@end
