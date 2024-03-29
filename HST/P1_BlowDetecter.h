//
//  BlowDetecter.h
//  town
//
//  Created by Song on 13-8-1.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//



@class P1_BlowDetecter;
@protocol P1_BlowDetecterDelegate <NSObject>

-(void)blowDetecterDidStartBlow;
-(void)blowDetecterDidEndBlow;

@end


@interface P1_BlowDetecter : NSObject

@property (nonatomic, assign) id<P1_BlowDetecterDelegate> delegate;
@property (readonly, assign, nonatomic) BOOL success;
+ (BOOL)isFirstDetect;
+ (void)setIsFirstDetect:(BOOL)fFirst;
+ (BOOL)isEnableDetect;
+ (void)setIsEnableDetect:(BOOL)fFirst;
+ (P1_BlowDetecter*)instance;
+ (void)purge;
- (BOOL)isDetect;
- (BOOL)isBlowing;
+ (BOOL)checkIsAir;
@end
