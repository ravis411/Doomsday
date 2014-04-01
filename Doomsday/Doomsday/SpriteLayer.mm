//
//  SpriteLayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "SpriteLayer.h"
#define PTM_RATIO 32.0f
@implementation SpriteLayer

-(id)init{
    if(self = [super init]){
        [self setTouchEnabled:YES];
        CCLayerColor* color = [CCLayerColor layerWithColor:ccc4(255,0,255,255)];
        [self addChild:color z:0];
        size = [[CCDirector sharedDirector] winSize];
        //Initializing Sprites + Position
        _shipSprite = [CCSprite spriteWithFile:@"ship.png"];
        _hoipolloiSprite = [CCSprite spriteWithFile:@"hoipolloi.png"];
       
        _hoipolloiSprite.position = CGPointMake(size.width/2, size.height/2);
       
        [_shipSprite setScale:0.3];
        [_hoipolloiSprite setScale:0.3];
//        [_bombSprite setScale:0.2];
        [self addChild:_shipSprite];
        [self addChild:_hoipolloiSprite];
        
        //Creating Box2D World
        b2Vec2 gravity = b2Vec2(0.0f, -80.0f);
        _world = new b2World(gravity);
        
        //Creating Edges around the screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        
        b2Body *groundBody = _world->CreateBody(&groundBodyDef);
        b2EdgeShape groundEdge;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundEdge;
        
        //wall definitions
        //Creating the ground
        groundEdge.Set(b2Vec2(0,0), b2Vec2(size.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);

        
        groundEdge.Set(b2Vec2(0,0), b2Vec2(0,size.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);


        groundEdge.Set(b2Vec2(size.width/PTM_RATIO, size.height/PTM_RATIO),b2Vec2(size.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        
        
        //Creating Ship Box2D Body
        b2BodyDef shipBodyDef;
        shipBodyDef.type = b2_dynamicBody;
        shipBodyDef.position.Set((size.width/2)/PTM_RATIO, (size.height-50)/PTM_RATIO);
        shipBodyDef.userData = _shipSprite;
        shipBodyDef.fixedRotation = true;
        _shipBody = _world->CreateBody(&shipBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        
        
        b2FixtureDef shipShapeDef;
        shipShapeDef.shape = &circle;
        shipShapeDef.density = 1.0f;
        shipShapeDef.friction = 0.2f;
        shipShapeDef.restitution = 0.6f;
        _shipBody->CreateFixture(&shipShapeDef);
    
        _shipBody->SetGravityScale(0);
        
        
        //Creating Hoipolloi Box2D Body
        b2BodyDef hoipolloiBodyDef;
        hoipolloiBodyDef.type = b2_dynamicBody;
        hoipolloiBodyDef.position.Set((size.width/2)/PTM_RATIO, (size.height/2)/PTM_RATIO);
        hoipolloiBodyDef.userData = _hoipolloiSprite;
        hoipolloiBodyDef.fixedRotation = false;
        _hoipolloiBody = _world->CreateBody(&hoipolloiBodyDef);
        
        
        b2FixtureDef hoipolloiShapeDef;
        hoipolloiShapeDef.shape = &circle;
        hoipolloiShapeDef.density = 2.0f;
        hoipolloiShapeDef.friction = 0.2f;
        hoipolloiShapeDef.restitution = 0.2f;
        _hoipolloiBody->CreateFixture(&hoipolloiShapeDef);
        
        
        
//        _hoipolloiBody->SetGravityScale(2);
        
        [self schedule:@selector(tick:)];
        //[self schedule:@selector(kick) interval:10.0];
    }
    return self;
}

- (void)tick:(ccTime) dt {
    
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * 32, b->GetPosition().y * 32);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    
}

-(void)update:(ccTime)dt{
    b2Vec2 pos = _shipBody->GetPosition();
    b2Vec2 center = b2Vec2((size.width/2)/PTM_RATIO,(size.height-50)/PTM_RATIO);
    if((pos - center).Length() != 0){
        [self gravitateToCenter];
    }
    
}

- (void)ccTouchesBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    b2Vec2 force = b2Vec2(-50, 80);
//    _hoipolloiBody->ApplyLinearImpulse(force, _shipBody->GetPosition());
    [self kick];
}
- (void)kick {
//    b2Vec2 force = b2Vec2(30, 30);
//    _shipBody->ApplyLinearImpulse(force,_shipBody->GetPosition());
    //Creating Hoipolloi Box2D Body
     _bombSprite = [CCSprite spriteWithFile:@"bomb.png"];
    [_bombSprite setScale:0.2f];
     [_bombSprite setPosition:CGPointMake(_shipSprite.position.x, _shipSprite.position.y)];
    [self addChild:_bombSprite];
    
    b2CircleShape circle;
    circle.m_radius = 26.0/PTM_RATIO;
    b2BodyDef bombBodyDef;
    bombBodyDef.type = b2_dynamicBody;
    bombBodyDef.position.Set(_shipSprite.position.x/PTM_RATIO, (_shipSprite.position.y-20)/PTM_RATIO);
    bombBodyDef.userData = _bombSprite;
    bombBodyDef.fixedRotation = false;
    _bombBody = _world->CreateBody(&bombBodyDef);
    
    
    b2FixtureDef bombShapeDef;
    bombShapeDef.shape = &circle;
    bombShapeDef.density = 2.5f;
    bombShapeDef.friction = 0.8f;
    bombShapeDef.restitution = 0.2f;
    _bombBody->CreateFixture(&bombShapeDef);
}

-(void)gravitateToCenter{
    b2Vec2 pos = _shipBody->GetPosition();
     b2Vec2 center = b2Vec2((size.width/2)/PTM_RATIO,(size.height-50)/PTM_RATIO);
    if(pos.x < center.x){
        _shipBody->ApplyForce(b2Vec2(100*(center.x-pos.x), 0), center);
        _shipBody->SetLinearDamping(2);
    }
    if(pos.x > center.x){
        _shipBody->ApplyForce(b2Vec2(-100*(pos.x-center.x), 0), center);
        _shipBody->SetLinearDamping(2);
    }
    if(pos.y > center.y){
        _shipBody->ApplyForce(b2Vec2(0, -10*(pos.y-center.y)), center);
        _shipBody->SetLinearDamping(2);
    }
    if(pos.y < center.y){
        _shipBody->ApplyForce(b2Vec2(0, 10*(center.y-pos.y)), center);
        _shipBody->SetLinearDamping(2);
    }
    
}

- (void)dealloc {
    delete _world;
    _shipBody = NULL;
    _world = NULL;
    [super dealloc];
}

@end
