//
//  P5_UiLayer.h
//  HST
//
//  Created by wxy325 on 10/19/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCLayer.h"

@class P5_UiLayer;

@protocol P5_UILayerDelegate <NSObject>
- (void)p5Ui:(P5_UiLayer*)uiLayer selectIndex:(int)index;
- (void)p5UiOkButtonPressed:(P5_UiLayer*)uiLayer;

@end

@interface P5_UiLayer : CCLayer
@property (readonly) BOOL isShow;
@property (unsafe_unretained, nonatomic) NSObject<P5_UILayerDelegate>* delegate;
- (void)showAnimate;
- (void)hideAnimate;
@end
