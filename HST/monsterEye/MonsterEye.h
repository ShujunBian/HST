//
//  MonsterEye.h
//  HST
//
//  Created by wxy325 on 7/16/14.
//  Copyright (c) 2014 Emerson. All rights reserved.
//

#import "CCNode.h"

//怪物眼睛
//锚点0.5,0.5
@interface MonsterEye : CCNode

- (id)initWithEyeWhiteName:(NSString *)eyeWhiteName eyeballName:(NSString *)eyeballName eyelidColor:(ccColor3B)eyelidColor;
- (void)blink;
- (void)eyeMoveAngle:(float)angle;
- (void)eyeMoveRandom;

@end
