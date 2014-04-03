//
//  MyCocos2DClass.m
//  sing
//
//  Created by Pursue_finky on 13-12-9.
//  Copyright 2013年 mhc. All rights reserved.
//

#import "P3_Main_Scene.h"
#import "P3_grass.h"
#import "CCBAnimationManager.h"
#import "P3_Calculator.h"
#import "MainMapHelper.h"
#import "HelloWorldLayer.h"

@implementation P3_Main_Scene

@synthesize grass;
@synthesize monster_1;
@synthesize monster_2;
@synthesize monster_3;
@synthesize monster_4;
@synthesize monster_5;


- (void)didLoadFromCCB
{
    [MainMapHelper addMenuToCurrentPrototype:self atMainMapButtonPoint:CGPointMake(66.0, 727.0)];

    grass = (P3_grass *)[CCBReader nodeGraphFromFile:@"P3_grass.ccbi"];
    [self addChild:grass z:10];
    
    
    [[self getChildByTag:500] setZOrder:9];
    
    [[self getChildByTag:501] setZOrder:9];
    
    [[self getChildByTag:502] setZOrder:9];
    
    [[self getChildByTag:503] setZOrder:9];
    
    
    monster_1 = [[P3_Monster_1 alloc]initWithNode:self];
    
    monster_2 = [[P3_Monster_2 alloc]initWithNode:self];
    
    monster_3 = [[P3_Monster_3 alloc]initWithNode:self];
    
    monster_4 = [[P3_Monster_4 alloc]initWithNode:self];
    
    monster_5 = [[P3_Monster_5 alloc]initWithNode:self];
    
    
    
    
    [self setTouchEnabled:YES];
    
    
}



#pragma mark - 触摸事件

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([touches count] >= 2)  //多点触控 以后需要实现
    {
        //       for(UITouch *touch in touches)
        //       {
        //           touch = [touches anyObject];
        //       }
    }
    else    //单点触控
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        
         oldTouchRecord = touchLocation;
        
        if(touchLocation.x <= 250)
        {
            CGRect BoundingBox = monster_1.monsterFace.boundingBox;
            
            BoundingBox.origin.y -= 5 *99;
            
            BoundingBox.size.height += 5*99;
            
            if(CGRectContainsPoint(BoundingBox, touchLocation))
            {
                touchId = 1;
            }
        }
        if(touchLocation.x > 250 && touchLocation.x <= 410)
        {
            CGRect BoundingBox = monster_2.monsterFace.boundingBox;
            
            BoundingBox.origin.y -= 5 *99;
            
            BoundingBox.size.height += 5*99;
            
            if(CGRectContainsPoint(BoundingBox, touchLocation))
            {
                touchId = 2;
                canTouch = 1;
            }
            
        }
        
        if(touchLocation.x > 410 && touchLocation.x <= 660)
        {
            CGRect BoundingBox = monster_3.monsterFace.boundingBox;
            
            BoundingBox.origin.y -= 5 *130;
            
            BoundingBox.size.height += 5*130;
            
            if(CGRectContainsPoint(BoundingBox, touchLocation))
            {
                touchId = 3;
                canTouch = 1;
            }
        }
        if(touchLocation.x > 660 && touchLocation.x <= 800)
        {
            CGRect BoundingBox = monster_4.monsterFace.boundingBox;
            
            BoundingBox.origin.y -= 5 *99;
            
            BoundingBox.size.height += 5*99;
            
            if(CGRectContainsPoint(BoundingBox, touchLocation))
            {
                touchId = 4;
                canTouch = 1;
            }
        }
        if(touchLocation.x > 800 )
        {
            CGRect BoundingBox = monster_5.monsterFace.boundingBox;
            
            BoundingBox.origin.y -= 5 *99;
            
            BoundingBox.size.height += 5*99;
            
            if(CGRectContainsPoint(BoundingBox, touchLocation))
            {
                touchId = 5;
                canTouch = 1;
            }
        }
        
       

        
    }
    
}
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint translation = ccpSub(touchLocation,oldTouchRecord);
    
     //NSLog(@"%f,%f",translation.x,translation.y);
    
    if(touchId == 1 )
    {
        
        //NSLog(@"在怪物1中执行函数");
        
        if([P3_Calculator judgeGestureIsVerticalOrNot:translation])
        {
            //手势是垂直方向的
            
            if(translation.y > 0)
                [monster_1 createAMonsterBodyWithTranslation:translation];
            else
                if([monster_1 removeMonsterBodyWithTranslation:translation] == 2)
                {
                    _effects = (P3_RemoveEffects *)[CCBReader nodeGraphFromFile:@"P3_Monster_RemoveEffects.ccbi"];
                    
                    [_effects setStartColor:ccc4FFromccc3B(MONSTER_1_COLOR)];
                    
                    [_effects setEndColor:ccc4FFromccc3B(MONSTER_1_COLOR)];
                    
                    [_effects setPosition:CGPointMake(150, 50)];
                    
                    [self addChild:_effects z:7];
                }
            
        }
        
    }
    if(touchId == 2 )
    {
        
        if([P3_Calculator judgeGestureIsVerticalOrNot:translation])
        {
            //手势是垂直方向的
            
            if(translation.y > 0)
                [monster_2 createAMonsterBodyWithTranslation:translation];
            else
                if([monster_2 removeMonsterBodyWithTranslation:translation] == 2)
                {
                    _effects = (P3_RemoveEffects *)[CCBReader nodeGraphFromFile:@"P3_Monster_RemoveEffects.ccbi"];
                    
                    [_effects setStartColor:ccc4FFromccc3B(MONSTER_2_COLOR)];
                    
                    [_effects setEndColor:ccc4FFromccc3B(MONSTER_2_COLOR)];
                    
                    [_effects setPosition:CGPointMake(320, 50)];
                    
                    [self addChild:_effects z:7];
                }
            
        }
        
    }
    if(touchId == 3 )
    {
        
        if([P3_Calculator judgeGestureIsVerticalOrNot:translation])
        {
            //手势是垂直方向的
            
            if(translation.y > 0)
                [monster_3 createAMonsterBodyWithTranslation:translation];
            else
                [monster_3 removeMonsterBodyWithTranslation:translation];
            
        }
        
    }
    if(touchId == 4 && canTouch ==1)
    {
        
        if([P3_Calculator judgeGestureIsVerticalOrNot:translation])
        {
            //手势是垂直方向的
            
            if(translation.y > 0)
                [monster_4 createAMonsterBodyWithTranslation:translation];
            else
                if([monster_4 removeMonsterBodyWithTranslation:translation] == 2)
                {
                    _effects = (P3_RemoveEffects *)[CCBReader nodeGraphFromFile:@"P3_Monster_RemoveEffects.ccbi"];
                    
                    [_effects setStartColor:ccc4FFromccc3B(MONSTER_4_COLOR)];
                    
                    [_effects setEndColor:ccc4FFromccc3B(MONSTER_4_COLOR)];
                    
                    [_effects setPosition:CGPointMake(730, 50)];
                    
                    [self addChild:_effects z:7];
                }
            
        }
    }
    if(touchId == 5 && canTouch ==1)
    {
        
        if([P3_Calculator judgeGestureIsVerticalOrNot:translation])
        {
            //手势是垂直方向的
            
            if(translation.y > 0)
                [monster_5 createAMonsterBodyWithTranslation:translation];
            else
                if([monster_5 removeMonsterBodyWithTranslation:translation] == 2)
                {
                    _effects = (P3_RemoveEffects *)[CCBReader nodeGraphFromFile:@"P3_Monster_RemoveEffects.ccbi"];
                    
                    [_effects setStartColor:ccc4FFromccc3B(MONSTER_5_COLOR)];
                    
                    [_effects setEndColor:ccc4FFromccc3B(MONSTER_5_COLOR)];
                    
                    [_effects setPosition:CGPointMake(880, 50)];
                    
                    [self addChild:_effects z:7];
                }
            
        }
    }
    
    
    oldTouchRecord = touchLocation;
    
    
    
}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchId == 1)
    {
        [monster_1 revertToPrim];
        

    }
    if(touchId == 2)
    {
        
        [monster_2 revertToPrim];

        
    }
    if(touchId == 3)
    {
        [monster_3 revertToPrim];
        
           }
    if(touchId == 4)
    {
        [monster_4 revertToPrim];
        
        
    }
    if(touchId == 5)
    {
        [monster_5 revertToPrim];
        
        
    }
    
    
    touchId = 0;
}

#pragma mark - 菜单键调用函数 mainMapDelegate
- (void)restartGameScene
{
}

- (void)returnToMainMap
{
    [self unscheduleAllSelectors];
    for (CCNode * child in [self children]) {
        [child stopAllActions];
        [child unscheduleAllSelectors];
    }
    
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFade transitionWithDuration:1.0
                                        scene:[HelloWorldLayer scene]]];
}


@end