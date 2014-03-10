//
//  BlowDetecter.h
//  town
//
//  Created by Song on 13-8-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@class P1_BlowDetecter;
@protocol P1_BlowDetecterDelegate <NSObject>

-(void)blowDetecterDidStartBlow;
-(void)blowDetecterDidEndBlow;

@end


@interface P1_BlowDetecter : NSObject

@property (nonatomic,assign) id<P1_BlowDetecterDelegate> delegate;

+ (P1_BlowDetecter*)instance;
+ (void)purge;

- (BOOL)isBlowing;

@end
