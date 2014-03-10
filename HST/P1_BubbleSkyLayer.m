//
//  BubbleSkyLayer.m
//  town
//
//  Created by Song on 13-7-28.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P1_BubbleSkyLayer.h"

@implementation P1_BubbleSkyLayer

-(id) init
{
	if( (self=[super init]))
    {
        [self scheduleUpdate];
	}
	return self;
}

- (void) didLoadFromCCB
{
   
}


-(void) update:(ccTime)delta
{
    self.lowerCloud.position = ccp(self.lowerCloud.position.x - 8 * delta, self.lowerCloud.position.y);
    self.lowerCloud2.position = ccp(self.lowerCloud2.position.x - 8 * delta, self.lowerCloud2.position.y);
    if(self.lowerCloud.position.x + self.lowerCloud.boundingBox.size.width < 0)
    {
        self.lowerCloud.position = ccp(self.lowerCloud2.position.x + self.lowerCloud2.boundingBox.size.width, self.lowerCloud.position.y);
    }
    else if(self.lowerCloud2.position.x + self.lowerCloud2.boundingBox.size.width < 0)
    {
        self.lowerCloud2.position = ccp(self.lowerCloud.position.x + self.lowerCloud.boundingBox.size.width, self.lowerCloud2.position.y);
    }
    
    
    
    self.upperCloud.position = ccp(self.upperCloud.position.x - 5 * delta, self.upperCloud.position.y);
    self.upperCloud2.position = ccp(self.upperCloud2.position.x - 5 * delta, self.upperCloud2.position.y);
    if(self.upperCloud.position.x + self.upperCloud.boundingBox.size.width < 0)
    {
        self.upperCloud.position = ccp(self.upperCloud2.position.x + self.upperCloud2.boundingBox.size.width, self.upperCloud.position.y);
    }
    else if(self.upperCloud2.position.x + self.upperCloud2.boundingBox.size.width < 0)
    {
        self.upperCloud2.position = ccp(self.upperCloud.position.x + self.upperCloud.boundingBox.size.width, self.upperCloud2.position.y);
    }
    
}


@end
