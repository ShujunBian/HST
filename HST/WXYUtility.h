//
//  WXYUtility.h
//  HST
//
//  Created by wxy325 on 8/12/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXYUtility : NSObject

+ (void)clearImageCachedOfArray:(NSArray*)imageNameArray;
+ (void)clearImageCachedOfPlist:(NSString*)plistName;
@end
