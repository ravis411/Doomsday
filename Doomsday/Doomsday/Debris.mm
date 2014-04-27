
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
    float s =  arc4random_uniform(100);
    if (s < 20) {spriteVersion = 2;}
    if (s > 80) {spriteVersion = 3;}
    else {spriteVersion = 1;}
    
    NSString* frameName = [NSString stringWithFormat:@"buildingpiece-%d.png", spriteVersion];
    
    if (self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]]) {
        
        [self setScale:0.3];
        [self setPosition:ccp(point.x, point.y)];
        
        //SETTING UP PHYSICS
        _bodyDef.type = b2_dynamicBody;
        _bodyDef.position.Set(point.x/PTM_RATIO, point.y/PTM_RATIO);
        _bodyDef.userData = self; //This may pose problems later
        _bodyDef.fixedRotation = false;
      
        _body = world->CreateBody(&_bodyDef);
      
        b2PolygonShape polygon;
        int num = 4;
        b2Vec2 vertices[4];
        float dev = 30/PTM_RATIO;
        
        vertices[0].Set(-1 * dev, -1 * dev);
        vertices[1].Set(dev, -1 * dev);
        vertices[2].Set(dev, dev);
        vertices[3].Set(-1 * dev, dev);
        
        
        polygon.Set(vertices, num);
        _fixtureDef.shape = &polygon;
        _fixtureDef.density = 5.5f;
        _fixtureDef.friction = 1.0f;
        _fixtureDef.restitution = 0.00f;
        _fixtureDef.filter.categoryBits = 3;//0b0000000000000011;
        _fixtureDef.filter.maskBits = 2;    //0b0000000000000010;//0x0002
//        _fixtureDef.filter.groupIndex = 4;
        
        _fixture = _body->CreateFixture(&_fixtureDef);
                
    }
    return self;
    
}


-(void)hitByExplosion{
    b2Filter f = _fixture->GetFilterData();
    if(f.maskBits == 2){
        f.maskBits = 0b0000000000000011;
        _fixture->SetFilterData(f);
    }
    NSString *frameName = [NSString stringWithFormat:@"buildingpiece-%d-off.png", spriteVersion];
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
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
