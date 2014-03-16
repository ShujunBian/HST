//
//  P5_SkyLayer.m
//  Dig
//
//  Created by Emerson on 14-1-25.
//  Copyright (c) 2014年 Emerson. All rights reserved.
//

#import "P5_SkyLayer.h"

@implementation P5_SkyLayer

@synthesize upperCloud;
@synthesize upperCloud2;

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
    self.upperCloud.position = ccp(self.upperCloud.position.x - 20.0 * delta, self.upperCloud.position.y);
    self.upperCloud2.position = ccp(self.upperCloud2.position.x - 20.0 * delta, self.upperCloud2.position.y);
    if(self.upperCloud.position.x + self.upperCloud.boundingBox.size.width < 0)
    {
        self.upperCloud.position = ccp(self.upperCloud2.position.x + self.upperCloud2.boundingBox.size.width, self.upperCloud.position.y);
    }
    else if(self.upperCloud2.position.x + self.upperCloud2.boundingBox.size.width < 0)
    {
        self.upperCloud2.position = ccp(self.upperCloud.position.x + self.upperCloud.boundingBox.size.width, self.upperCloud2.position.y);
    }
    
}

- (void)dealloc
{
    [super dealloc];
}
@end
