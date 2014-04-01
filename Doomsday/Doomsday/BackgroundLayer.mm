//
//  BackgroundLayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

-(id) init {
    self = [super init];
    if(self){

        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *sky = [CCSprite node];
     //   [sky setTextureRectInPixels:CGRectMake(0,0,size.width,size.height)];
      //  [self addChild:sky];
        
        CCSprite *background = [CCSprite spriteWithFile:@"rsz_background.png"];
        background.position = ccp(size.width/2, size.height/2);
        
        [self addChild:background z:1];
     
        CCSprite *ground = [CCSprite spriteWithFile:@"rsz_ground.png"];
        ground.position = ccp(size.width, -50);
        
        [self addChild:ground z:2];
        
        
        
        distanceTraveled = 0;
        
        distanceTraveled = 0;
    }
    
    return self;
}


@end
