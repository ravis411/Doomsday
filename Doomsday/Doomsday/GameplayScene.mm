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
        background = [CCParallaxNode node];
//        _ship = [Ship sharedModel];
        
        
        
    }
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CGPoint backgroundLayerSpeed = ccp(0.05, 0.05);
    CGPoint spriteLayerSpeed = ccp(0.1, 0.1);
    
    [background addChild:bgLayer z:-1 parallaxRatio:backgroundLayerSpeed positionOffset:ccp(0,0)];
    [background addChild:spriteLayer z:0 parallaxRatio:spriteLayerSpeed positionOffset:ccp(0,0)];
    
//    [self addChild:_ship z:1];
    //[self addChild:spriteLayer z:1];
    [self addChild:uiLayer z:4];
    //[self addChild:bgLayer z:0];
    [self addChild:background z:-1];
    //[self addChild:[spriteLayer hoipolloiSprite] z:3];
    
    [self scheduleUpdate];
    
   
    return self;
    
}


-(void)update:(ccTime)dt{
    [spriteLayer update:dt];
    
    
    if (([spriteLayer movingRight] == YES) && background.position.x >= -14795) {
//        NSLog(@"\n\n\n%f\n\n\n",background.position.x);
        CGPoint backgroundScrollVel = ccp(-3000, 0);
        background.position = ccpAdd(background.position, ccpMult(backgroundScrollVel, dt));
    }

    if (([spriteLayer movingLeft] == YES) && background.position.x <= 14795) {
//        NSLog(@"\n\n\n%f\n\n\n",background.position.x);
        CGPoint backgroundScrollVel = ccp(-3000, 0);
        background.position = ccpSub(background.position, ccpMult(backgroundScrollVel, dt));
    }
    [spriteLayer updateShipPosition:background.position.x y:background.position.y];
}



@end
