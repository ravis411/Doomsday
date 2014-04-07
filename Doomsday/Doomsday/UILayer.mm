//
//  UILayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "UILayer.h"

@implementation UILayer

- (id)init
{
    
    if (self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
        [self setTouchEnabled:YES];

        _dash = [CCSprite spriteWithFile:@"dashboard.png"];
        _dash.position = CGPointMake(size.width/2, 30);
               
        
        [self addChild:_dash];
        
        }
    return self;
}




@end
