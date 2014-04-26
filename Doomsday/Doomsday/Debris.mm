
//
//  Debris.m
//  Doomsday
//
//  Created by Kyle on 4/26/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "Debris.h"


#define PTM_RATIO 32.0f


@implementation Debris

-(id) makeInWorld:(b2World*)world atPosition:(CGPoint)point {
    NSLog(@"making debris...");
    if (self = [super initWithFile:@"building_block.png"]) {
        NSLog(@"...rescaling sprite...");
        [self setScale:0.3];
        
        //SETTING UP PHYSICS
        NSLog(@"...defining the body...");
        _bodyDef.type = b2_dynamicBody;
        _bodyDef.position.Set(point.x/PTM_RATIO, point.y/PTM_RATIO);
        _bodyDef.userData = self; //This may pose problems later
        _bodyDef.fixedRotation = false;
        NSLog(@"...adding to the world...");
        _body = world->CreateBody(&_bodyDef);
        NSLog(@"...defining the shape...");
        b2PolygonShape polygon;
        int num = 4;
        b2Vec2 vertices[4];
        float dev = 20/PTM_RATIO;
        
        vertices[0].Set(-1 * dev, -1 * dev);
        vertices[1].Set(dev, -1 * dev);
        vertices[2].Set(dev, dev);
        vertices[3].Set(-1 * dev, dev);
        
        
        NSLog(@"...setting polygon...");
        polygon.Set(vertices, num);
        NSLog(@"...setting fixtureDef...");
        _fixtureDef.shape = &polygon;
        _fixtureDef.density = 1.5f;
        _fixtureDef.friction = 1.0f;
        _fixtureDef.restitution = 0.00f;
        _fixtureDef.filter.categoryBits = 1;
        _fixtureDef.filter.maskBits = 3;
        NSLog(@"...adding fixture to body from fixture definition...");
        _body->CreateFixture(&_fixtureDef);
        
    }
    NSLog(@"...done!");
    return self;
    
}


-(b2Shape*) shape {
    return _shape;
}

-(b2FixtureDef) fixtureDef {
    return _fixtureDef;
}

-(b2Body*) body {
    return _body;
}

@end
