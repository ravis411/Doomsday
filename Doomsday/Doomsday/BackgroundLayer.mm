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
        [sky setTextureRectInPixels:CGRectMake(0,0,size.width,size.height)];
        
        distanceTraveled = 0;
    }
    
    return self;
}


@end
