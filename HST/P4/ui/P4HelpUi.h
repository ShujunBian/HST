//
//  P4HelpUi.h
//  HST
//
//  Created by wxy325 on 10/4/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCNode.h"

@interface P4HelpUi : CCNode

@property (strong, nonatomic) CCLayerColor* shadowLayer;
@property (strong, nonatomic) CCLabelTTF* label1_1;
@property (strong, nonatomic) CCLabelTTF* label1_2;
@property (strong, nonatomic) CCLabelTTF* label2_1;
@property (strong, nonatomic) CCLabelTTF* label2_2;

- (void)showShadow:(BOOL)fShow withAnimation:(BOOL)fAnimated;
- (void)showHelpLabel:(BOOL)fShow helpLabelIndex:(int)helpNumber withAnimation:(BOOL)fAnimated;
- (void)hideAllUiWithAnimation:(BOOL)fAnimated;
@end
