//
//  BuildingBlock.m
//  Doomsday
//
//  Created by Kyle on 4/13/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "BuildingBlock.h"

@implementation BuildingBlock

- (id)init 
{
    CGSize size = [[CCDirector sharedDirector] winSize];

    self = [super initWithFile:@"building_block.png"];
    if (self) {
        
        self.position = CGPointMake(size.width/2, size.height/2-80);
        [self setScale:0.3];
//        b2Body* _buildingBody;
    NSLog(@"Building a building");
    }
    return self;
}

-(id)initAtPosition:(CGPoint)location {
//    CGSize size = [[CCDirector sharedDirector] winSize];
    
    self = [super initWithFile:@"building_block.png"];
    if (self) {
        self.position = location;
        [self setScale:0.3];
        //        b2Body* _buildingBody;
        NSLog(@"Building a building");
    }
    return self;
}

@end
