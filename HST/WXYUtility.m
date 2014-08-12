//
//  WXYUtility.m
//  HST
//
//  Created by wxy325 on 8/12/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "WXYUtility.h"
#import "cocos2d.h"
@implementation WXYUtility
+ (void)clearImageCachedOfArray:(NSArray*)imageNameArray
{
    for (NSString* imgName in imageNameArray)
    {
        [[CCTextureCache sharedTextureCache] removeTextureForKey:imgName];
    }
}
+ (void)clearImageCachedOfPlist:(NSString*)plistName
{
    NSArray* array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
    [self clearImageCachedOfArray:array];
}

@end
