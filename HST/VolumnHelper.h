//
//  VolumnHelper.h
//  HST
//
//  Created by Emerson on 14-8-5.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VolumnHelper : NSObject

+ (VolumnHelper*)sharedVolumnHelper;
- (void)downBackgroundVolumn:(NSTimer *)timer;
- (void)upBackgroundVolumn:(NSTimer *)timer;

@property (nonatomic) BOOL isPlayingWordBgMusic;

@end
