//
//  CCSprite+getRect.m
//  hst_p4
//
//  Created by wxy325 on 1/20/14.
//  Copyright (c) 2014 cdi. All rights reserved.
//

#import "CCSprite+getRect.h"

@implementation CCSprite (getRect)
- (CGRect)getRect
{
    CGPoint location = self.position;
    CGPoint anchorPoint = self.anchorPoint;
    CGSize size = self.texture.contentSize;
    CGFloat left = location.x - anchorPoint.x * size.width;
    CGFloat top = location.y - anchorPoint.y * size.height;
    return CGRectMake(left, top, size.width, size.height);
}
@end
