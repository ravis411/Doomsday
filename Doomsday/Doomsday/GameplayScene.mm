//
//  GameplayScene.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "GameplayScene.h"

@implementation GameplayScene

- (id)init
{
    self = [super init];
    if (self) {
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        exitLabel = [CCLabelTTF labelWithString:@"Exit" fontName:(@"Helvetica") fontSize:(42)];
        exitLabel.position = ccp(winSize.width/2 , winSize.height/2);
        exitLabel.color = ccGREEN;
        [ self addChild: exitLabel ];
        
    }
    return self;
}

@end
