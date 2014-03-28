//
//  P3_Monster_5.m
//  sing
//
//  Created by pursue_finky on 14-1-27.
//  Copyright (c) 2014年 mhc. All rights reserved.
//

#import "P3_Monster_5.h"

#define ORIGIN_X 880

#define DELAY_TIME 1.5f

#define MONSTER_Z_ORDER 6

#define MONSTER_BODY_POS_X 74


/*音量相关宏*/
#define MAX_VOICE_HEIGHT 528

#define VOICE_4 515

#define VOICE_3 412

#define VOICE_2 309

#define VOICE_1 206

#define MIN_VOICE_HEIGHT 90


@implementation P3_Monster_5


-(id)initWithNode:(CCNode *)node
{
    if(self != nil)
    {
        self.node = node;
        
        self.monsterFace = [CCSprite spriteWithFile:@"P3_monster5_face.png"];
        
        [self.monsterFace setAnchorPoint:CGPointMake(0.5, 0)];
        
        [self.monsterFace setPosition:CGPointMake(ORIGIN_X, -80)];
        
        self.monsterMouth = [CCSprite spriteWithFile:@"P3_monster5_mouth.png"];
        
        monsterEye = [CCSprite spriteWithFile:@"P3_Monster1_Eye_point.png"];
        
        [monsterEye setScale:0.833f];
        
        [monsterEye setPosition:CGPointMake(47, 48)];
        
        
        monsterAnotherEye = [CCSprite spriteWithFile:@"P3_Monster1_Eye_background.png"];
        
        monsterAnotherEyePoint = [CCSprite spriteWithFile:@"P3_Monster1_Eye_point.png"];
        
        [monsterAnotherEye setScale:0.833f];
        
        [monsterAnotherEyePoint setPosition:CGPointMake(17.5, 17.5)];
        
        [monsterAnotherEye addChild:monsterAnotherEyePoint];
        
        [monsterAnotherEye setPosition:CGPointMake(98, 48)];
        
        
        self.monsterEyeArray = [[NSMutableArray alloc]initWithObjects:monsterEye,monsterAnotherEye, nil];
        
        [self.monsterFace addChild:[self.monsterEyeArray objectAtIndex:0]];
        
        [self.monsterFace addChild:[self.monsterEyeArray objectAtIndex:1]];
        
        [self.monsterMouth setPosition:CGPointMake(74, 15)];
        
        [self.monsterMouth setAnchorPoint:CGPointMake(0.5, 0)];
        
        [self.monsterFace addChild:self.monsterMouth];
        
        [self.node addChild:self.monsterFace z:6];
        
        
        CCMoveTo *moveTo =  [CCMoveTo actionWithDuration:DELAY_TIME position:CGPointMake(ORIGIN_X, 50)];
        
        CCEaseExponentialIn *easeIn = [CCEaseExponentialIn actionWithAction:moveTo];
        
        CCScaleTo *action1 = [CCScaleTo actionWithDuration:0.1f scaleX:1-0.1 scaleY:1+0.1];
        
        CCScaleTo *action2 = [CCScaleTo actionWithDuration:0.1f scale:1];
        
        CCAction *action = [CCSequence actions:easeIn,action1,action2, nil];
        
        [self.monsterFace runAction:action];
        
        id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(animationForMonsterEyes)];
        
        [monsterAnotherEyePoint runAction:actionCallFunc];
        
        //        P3_Monster_5_Body *body = [[P3_Monster_5_Body alloc]initWithPosition:CGPointMake(ORIGIN_X, 100)];
        //        [self.node addChild:body.monsterBody];
        
        self.monsterBody = [[NSMutableArray alloc]init];

        
        for(int i = 0 ; i < 5 ; i ++)
        {
            P3_Monster_5_Body *tmpBody = [[P3_Monster_5_Body alloc]initWithPosition:CGPointMake(MONSTER_BODY_POS_X,-90 * (i + 1))];
            
            [self.monsterFace addChild:tmpBody.monsterBody];
            
            [self.monsterBody addObject:tmpBody];
            
        }
        
        
        self.monster = self.monsterFace;
        
        self.originPos = self.monsterFace.position;
        
        for(int i = 0 ; i < 6 ; i++)
        {
            cHeight[i] = i;
        }
        
        
        currentHeight = cHeight[0];
        
        self.nextHeight = 90;
        
        [self.monsterFace runAction:[CCSequence actions:[CCDelayTime actionWithDuration:4.0f],[CCCallFunc actionWithTarget:self selector:@selector(performActionForSing)], nil ]];
        
        
        
        
    }
    return self;
}


-(void)revertToPrim
{
    CCScaleTo *toLikeStrech = [CCScaleTo actionWithDuration:0.5f scaleX:1.05 scaleY:0.95];
    
    CCScaleTo *toPrim = [CCScaleTo actionWithDuration:0.5f scale:1];
    
    CCMoveBy *moveBy1 = [CCMoveBy actionWithDuration:0.5f position:CGPointMake(0, -9.05)];
    
    CCMoveBy *moveBy2 = [CCMoveBy actionWithDuration:0.5f position:CGPointMake(0, 9.05)];
    
    [self.monsterFace runAction:[CCSequence actions:[CCSpawn actionOne:moveBy1 two:[toLikeStrech copy]], [CCSpawn actionOne:moveBy2 two:[toPrim copy]],nil]];
    
}

-(void)dealloc
{
    [self.monsterFace removeAllChildrenWithCleanup:YES];
    
    [super dealloc];
}

-(BOOL)createAMonsterBodyWithTranslation:(CGPoint)translation
{
    BOOL bRet = NO;
    
    do {
        
        int times = 1;
        
        if(self.nextHeight > 90)
        {
            times = self.nextHeight / 90 ;
        }
        
        [self.monsterFace setScaleX:1 - translation.y * 0.002 / times];
        
        [self.monsterFace setScaleY:1 + 0.0026 * translation.y / times];
        
        if(translation.y > self.nextHeight)
        {
            
            
            CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.2f scaleX:1.20f scaleY:0.83f];
            
            [self.monsterFace runAction:scaleTo];
            
            currentHeight = cHeight[currentHeight + 1];
            
            [self.monsterFace setAnchorPoint:(CGPointMake(0.5, -0.6 * currentHeight))];
            
            CCScaleTo *scaleTo2 = [CCScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f];
            
            [self.monsterFace runAction:scaleTo2];
            
            NSLog(@"%f",translation.y);
            
            self.nextHeight += 90;
            
            
        }
        
        
        
        bRet = YES;
        
    } while (0);
    
    return bRet;
}

-(void)performActionForSing
{
    [self.monsterMouth setVisible:NO];
    
    monsterSingMouth = [CCSprite spriteWithFile:@"P3_monster_sing.png"];
    
    [monsterSingMouth setPosition:CGPointMake(MONSTER_BODY_POS_X, 10)];
    
    [monsterSingMouth setScale:0.9f];
    
    [monsterSingMouth setAnchorPoint:CGPointMake(0.5, 0)];
    
    [self.monsterFace addChild:monsterSingMouth z:6 tag:10];
    
    
    CCMoveBy *moveBy = [CCMoveBy actionWithDuration:1.0f position:CGPointMake(0.05, 0)];
    
    for(int i = 0 ; i < [self.monsterBody count] ; i ++)
    {
        P3_Monster_5_Body * tmpBody = (P3_Monster_5_Body *)[self.monsterBody objectAtIndex:i];
        
        [tmpBody.monsterBodyMouth setVisible:NO];
        
        tmpBody.monsterBodySingMouth = [CCSprite spriteWithFile:@"P3_MonsterBody_SingMouth.png"];
        
        [tmpBody.monsterBodySingMouth setPosition:CGPointMake(51.5, 30)];
        
        [tmpBody.monsterBody addChild:tmpBody.monsterBodySingMouth];
        
        CCMoveBy *moveBy = [CCMoveBy actionWithDuration:1.0f position:CGPointMake(0.05, 0)];
        
        [tmpBody.monsterBodySingMouth runAction:moveBy];

        
        
    }
    
    
    [monsterSingMouth runAction:[CCSequence actions:moveBy, nil]];
    
    
    
}

-(BOOL)removeMonsterBodyWithTranslation:(CGPoint)translation
{
    BOOL bRet = NO;
    
    do {
        
        
        int times = 1;
        
        if(self.nextHeight > 90)
        {
            times = self.nextHeight / 90 ;
        }
        
        [self.monsterFace setScaleX:1 - translation.y * 0.002 / times];
        
        [self.monsterFace setScaleY:1 + 0.0026 * translation.y / times];
        
        if(translation.y < -self.nextHeight)
        {
            
            if(currentHeight != 0)
            {
                currentHeight = cHeight[currentHeight - 1];
                
                [self.monsterFace setAnchorPoint:(CGPointMake(0.5, -0.55 * currentHeight ))];
            }
            CCScaleTo *scaleTo2 = [CCScaleTo actionWithDuration:1.0f scaleX:1.0f scaleY:1.0f];
            
            [self.monsterFace runAction:scaleTo2];
            
            NSLog(@"%f",translation.y);
            
            self.nextHeight += 90;
            
        }
        
    } while (0);
    
    return bRet;
}



#define RADIUS 17.5
#define CENTER 17.5
#define ARC4RANDOM_MAX      0x100000000

-(void)animationForMonsterEyes
{
    
    int ran = arc4random() % 2;
    int x;
    double y;
    if(ran == 1 )
    {
        x = (arc4random() % 2) + 10;
    }
    else
    {
        x = -((arc4random() % 2) + 10);
    }
    int ran2 = arc4random() % 2;
    
    if(ran2 == 1 )
        y = -sqrt(pow(14, 2) - pow(x , 2));
    else
        y = sqrt(pow(14, 2) - pow(x , 2));
    
    //NSLog(@"第五个：%d,%f",x,y);
    
    float time;
    
    while(1)
    {
        time = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 2.0f);
        
        if(time > 0.5f)
        {
            break;
        }
    }
    CCMoveBy *moveTo = [CCMoveBy actionWithDuration:time position:CGPointMake(x  , y )];

    
    CCMoveTo *moveBack = [CCMoveTo actionWithDuration:time position:CGPointMake(17.5, 17.5)];
    
    CCMoveTo *moveBack2 = [CCMoveTo actionWithDuration:time position:CGPointMake(47, 48)];
    
    CCMoveTo *stay = [CCMoveTo actionWithDuration:time * 4  position:CGPointMake(17.5, 17.5)];
    
    CCMoveTo *stay2 = [CCMoveTo actionWithDuration:time * 4  position:CGPointMake(47, 48)];
    
    id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(animationForMonsterEyes)];
    
    
    [monsterEye runAction:[CCSequence actions:[moveTo copy],moveBack2,stay2,nil]];
    
    [monsterAnotherEyePoint runAction:[CCSequence actions:moveTo,moveBack,stay,actionCallFunc,nil]];
    
    
    //眨眼部分以后完成
}

@end
