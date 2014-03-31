//
//  SpriteLayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "SpriteLayer.h"
#define PTM_RATIO 32.0
@implementation SpriteLayer

-(id)init{
    if(self = [super init]){
        [self setTouchEnabled:YES];
        CCLayerColor* color = [CCLayerColor layerWithColor:ccc4(255,0,255,255)];
        [self addChild:color z:0];
        CGSize size = [[CCDirector sharedDirector] winSize];
        _ship = [CCSprite spriteWithFile:@"ship.png"];
        _ship.position = ccp(100, 300);
        [self addChild:_ship];
        
        b2Vec2 gravity = b2Vec2(0.0f, -8.0f);
        _world = new b2World(gravity);
        
        
        
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        
        b2Body *groundBody = _world->CreateBody(&groundBodyDef);
        b2EdgeShape groundEdge;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundEdge;
        
        //wall definitions
        groundEdge.Set(b2Vec2(0,0), b2Vec2(size.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(0,0), b2Vec2(0,size.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(0, size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO, size.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(size.width/PTM_RATIO, size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        
        
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(100/PTM_RATIO, 300/PTM_RATIO);
        ballBodyDef.userData = _ship;
        _body = _world->CreateBody(&ballBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.2f;
        ballShapeDef.restitution = 0.8f;
        _body->CreateFixture(&ballShapeDef);
        
        [self schedule:@selector(tick:)];
        [self schedule:@selector(kick) interval:10.0];
    }
    return self;
}

- (void)tick:(ccTime) dt {
    
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * 32,
                                    b->GetPosition().y * 32);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    
}
- (void)ccTouchesBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    b2Vec2 force = b2Vec2(-30, 30);
    _body->ApplyLinearImpulse(force, _body->GetPosition());
}
- (void)kick {
    b2Vec2 force = b2Vec2(30, 30);
    _body->ApplyLinearImpulse(force,_body->GetPosition());
}

- (void)dealloc {
    delete _world;
    _body = NULL;
    _world = NULL;
    [super dealloc];
}

@end
