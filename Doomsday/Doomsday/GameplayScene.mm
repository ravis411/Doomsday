//
//  GameplayScene.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "GameplayScene.h"

@implementation GameplayScene

-(id) init
{
    
    if(self = [super init])
	{
        spriteLayer = [SpriteLayer node];
        uiLayer = [UILayer node];
        bgLayer = [BackgroundLayer node];
    }
    
    [self addChild:spriteLayer z:1];
    [self addChild:uiLayer z:4];
    [self addChild:bgLayer z:0];
    [self scheduleUpdate];
   
    return self;
    
}

-(void)update:(ccTime)dt{
    [spriteLayer update:dt];
    
}



@end
