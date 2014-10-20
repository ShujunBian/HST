//
//  P5_NumberButton.m
//  HST
//
//  Created by wxy325 on 10/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "P5_NumberButton.h"
#import "CCSprite+getRect.h"
@interface P5_NumberButton ()

@property (strong, nonatomic) CCSprite* normalBg;
@property (strong, nonatomic) CCSprite* hoverBg;

@end

@implementation P5_NumberButton
- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.normalBg.visible = !_selected;
    self.hoverBg.visible = _selected;
}

- (void)didLoadFromCCB
{
    [self.normalBg retain];
    [self.hoverBg retain];
    [self.numberLabel retain];
    
}


- (void)dealloc
{
    self.normalBg = nil;
    self.hoverBg = nil;
    self.numberLabel = nil;
    [super dealloc];
}

- (CGRect)getRect
{
    CGPoint location = self.position;
    CGSize size = [self.normalBg getRect].size;
    //CGPoint anchorPoint = self.anchorPoint;
    return CGRectMake(location.x - size.width * 0.5 , location.y - size.height * 0.5, size.width, size.height);
}
@end
