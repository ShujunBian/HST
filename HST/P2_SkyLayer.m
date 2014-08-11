//
//  SkyLayer.m
//  town
//
//  Created by Emerson on 13-7-28.
//  Copyright (c) 2013年 sbhhbs. All rights reserved.
//

#import "P2_SkyLayer.h"

@implementation P2_SkyLayer

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
    //self.shit.position = ccp(self.shit.position.x - 5 * delta, self.shit.position.y);
    self.upperCloud.position = ccp(self.upperCloud.position.x - 100 * delta, self.upperCloud.position.y);
    self.upperCloud2.position = ccp(self.upperCloud2.position.x - 100 * delta, self.upperCloud2.position.y);
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
