//
//  SpriteLayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "SpriteLayer.h"
#import "GLES-Render.h"
#define PTM_RATIO 32.0f

@implementation SpriteLayer

@synthesize movingLeft = _movingLeft;
@synthesize movingRight = _movingRight;
@synthesize enemiesKilled = _enemiesKilled;
@synthesize weaponMode = _weaponMode;
@synthesize gameOver = _gameOver;


-(id)init{
    if(self = [super init]){
        [self setTouchEnabled:YES];
        _gameOver = NO;
        bombArray = [[NSMutableArray alloc]init];
        hoipolloiArray = [[NSMutableArray alloc]init];
        buildingsArray = [[NSMutableArray alloc] init];
        explosionArray = [[NSMutableArray alloc]init];
        laserArray = [[NSMutableArray alloc]init];
        intentToMoveLeft = NO;
        intentToMoveRight = NO;
        shipLaserCooldownMode = NO;
        shipBombCooldownMode = NO;
        
        _enemiesKilled = 0;

//        CCLayerColor* color = [CCLayerColor layerWithColor:ccc4(255,0,255,255)];
//        [self addChild:color z:0];
        size = [[CCDirector sharedDirector] winSize];
        groundLevel = size.height/6;
        _movingLeft = NO;
        _movingRight = NO;
        //Initializing Sprites + Position
//        _shipSprite = [CCSprite spriteWithFile:@"ship.png"];
        _shipSprite = [CCSprite spriteWithFile:@"ship.png"];
        [_shipSprite setScale:0.3];
        
//        [_bombSprite setScale:0.2];
        [self addChild:_shipSprite];
        
        //Creating Box2D World
        b2Vec2 gravity = b2Vec2(0.0f, -80.0f);
        _world = new b2World(gravity);
        
        GLESDebugDraw *m_debugDraw = new GLESDebugDraw( PTM_RATIO );
        _world->SetDebugDraw(m_debugDraw);
        
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        //		flags += b2Draw::e_jointBit;
        //		flags += b2Draw::e_aabbBit;
        //		flags += b2Draw::e_pairBit;
        //		flags += b2Draw::e_centerOfMassBit;
        m_debugDraw->SetFlags(flags);
        
        //Creating Edges around the screen
        b2BodyDef groundBodyDef;
        
        //groundBodyDef.position.Set(0,5.00000018);
        groundBodyDef.position.Set(0,0);
        
        _groundBody = _world->CreateBody(&groundBodyDef);
        b2EdgeShape groundEdge;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundEdge;
        
        //wall definitions
        //Creating the ground
        groundEdge.Set(b2Vec2(-8000/PTM_RATIO,groundLevel/PTM_RATIO), b2Vec2(8000/PTM_RATIO, groundLevel/PTM_RATIO));
        _groundBody->CreateFixture(&boxShapeDef);

        groundEdge.Set(b2Vec2((size.width+805)/PTM_RATIO, 0),b2Vec2((size.width+805)/PTM_RATIO, size.height/PTM_RATIO));
        _groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(-805/PTM_RATIO,0), b2Vec2(-805/PTM_RATIO,size.height/PTM_RATIO));
        _groundBody->CreateFixture(&boxShapeDef);


       
        
        
        
        //Creating Ship Box2D Body
        b2BodyDef shipBodyDef;
        shipBodyDef.type = b2_dynamicBody;
        shipBodyDef.position.Set((size.width/2)/PTM_RATIO, (size.height-50)/PTM_RATIO);
        shipBodyDef.userData = _shipSprite;
        shipBodyDef.fixedRotation = true;
        _shipBody = _world->CreateBody(&shipBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 32.0/PTM_RATIO;
        
        
        b2FixtureDef shipShapeDef;
        shipShapeDef.shape = &circle;
        shipShapeDef.density = 1.0f;
        shipShapeDef.friction = 0.2f;
        shipShapeDef.restitution = 0.6f;
        _shipBody->CreateFixture(&shipShapeDef);
    
        _shipBody->SetGravityScale(0);
        
//      _hoipolloiBody->SetGravityScale(2);
        
//        [self schedule:@selector(tick:)];
        //[self schedule:@selector(kick) interval:10.0];
        
        for(NSInteger i = 1; i < 20; i++ ){
            [self spawnRandomPerson];
        }
        
        
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        [self spawnBuildingWithHeight:1 atPosition:(size.width/2)];
        
    }
    return self;
}


-(void)update:(ccTime)dt{
    int time = (NSInteger)(dt*769);//a prime number
    if( time % 2 == 0){
        if((int)[hoipolloiArray count]<50)
            [self spawnPerson];
    }
    
    
//    [self spawnPerson];
    if(_enemiesKilled >60){
        _gameOver = YES;
    }
    
    [self collisionDetection];
    
    b2Vec2 pos = _shipBody->GetPosition();
    
    b2Vec2 center = b2Vec2(pos.x,(size.height-50)/PTM_RATIO);
    if((pos - center).Length() != 0){
        [self gravitateToCenter];
    }
    if(pos.y*PTM_RATIO>size.height+10){
        shipBombCooldownMode = YES;
        shipLaserCooldownMode = YES;
    }
    
    
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *bodyData = (CCSprite *)b->GetUserData();
            bodyData.position = ccp(b->GetPosition().x * 32, b->GetPosition().y * 32);
            bodyData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
   
    //This code makes the people move away from the ship.
    b2Vec2 left = b2Vec2((-80)/PTM_RATIO,0);
    b2Vec2 right = b2Vec2((80)/PTM_RATIO,0);
    for(NSValue* pBody in hoipolloiArray){
        b2Body *pody = (b2Body*)[pBody pointerValue];

        if(pody->GetPosition().x < pos.x){
            pody->SetLinearVelocity(left);
        }else{
            pody->SetLinearVelocity(right);
        }
    }
    
    

    
 /*
    //Update children
    for(CCSprite *hp in self.children){
        if([hp isKindOfClass:[Hoipolloi class]]){
            //[((Hoipolloi *)hp) update:dt body:];
        }
    }*/
   


    if(_shipBody->GetPosition().x*PTM_RATIO>1330.00f){
        //Stop the ship
        _shipBody->SetLinearVelocity(b2Vec2((0)/PTM_RATIO,0));
        
    }
    if(_shipBody->GetPosition().x*PTM_RATIO<-765.00f){
        //Stop the ship
       _shipBody->SetLinearVelocity(b2Vec2((0)/PTM_RATIO,0));
    }
 
    if(_shipBody->GetPosition().x*PTM_RATIO<1086.00f && intentToMoveLeft == YES){
        _movingLeft = YES;
        intentToMoveLeft = NO;
    }
    if(_shipBody->GetPosition().x*PTM_RATIO>-520.00f && intentToMoveRight == YES){
        _movingRight = YES;
        intentToMoveRight = NO;
    }

    
}


-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
//	[super draw];
//	
//	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
//	
//	kmGLPushMatrix();
//	
//	_world->DrawDebugData();
//	
//	kmGLPopMatrix();
}

-(void)collisionDetection{
    /*The bomb coming in contact with anything will create an explosion
     The explosion itself will damage anyting it is touching. Rather than the bomb itself damaging the contact fixtures.
    */
    NSMutableArray* deleteBombs = [[NSMutableArray alloc]init];
    NSMutableArray* deleteLaser = [[NSMutableArray alloc]init];
    NSMutableArray* deletePeople = [[NSMutableArray alloc]init];
    
    //Collision with the bomb and the ground
    for(NSValue* bBody in bombArray){
        b2Body *body = (b2Body*)[bBody pointerValue];
        if((body->GetPosition().y*PTM_RATIO <(groundLevel+35))){
            [deleteBombs addObject:bBody];
        }
    }
    
     
    std::vector<MyContact>::iterator position;
    for(position = _contactListener->_contacts.begin(); position != _contactListener->_contacts.end(); ++position) {
        
        MyContact contact = *position;
        //Collision detection for explosion
        
        for(NSValue* pBody in hoipolloiArray){
            b2Body *pody = (b2Body*)[pBody pointerValue];
        
            for(NSValue* eBody in explosionArray){
                b2Body *eX = (b2Body*)[eBody pointerValue];
            
                if ((contact.fixtureA == eX->GetFixtureList() && contact.fixtureB == pody->GetFixtureList()) || (contact.fixtureA == pody->GetFixtureList() && contact.fixtureB == eX->GetFixtureList())) {
                    NSLog(@"Explosion hit person.");

                    if (eX->GetPosition().x > pody->GetPosition().x) {
                        pody->SetAngularVelocity(100);
                    }
                    else{
                        pody->SetAngularVelocity(-100);
                    }
                   //pody->SetAngularVelocity(50);
//                    [deletePeople addObject:pBody];

                    _enemiesKilled++;
                    CCSprite* dead = [CCSprite spriteWithFile:@"deadhoipolloi.png"];
                    dead.position = CGPointMake(size.width/2, size.height/2);
                    [dead setScale:0.3];
                    [self addChild:dead];
                    [self removeChild:(CCSprite*)pody->GetUserData()];
                    pody->SetUserData(dead);
                    [deletePeople addObject:pBody];
                    NSLog(@"\nEnemies Killed: %d\n\n", _enemiesKilled);
                    
                    
                }
            }
        }
        //Collision detection for bomb
        for(NSValue* bBody in bombArray){
            b2Body *body = (b2Body*)[bBody pointerValue];
            if ((contact.fixtureA == body->GetFixtureList() || contact.fixtureB == body->GetFixtureList()) && (contact.fixtureA != _shipBody->GetFixtureList() && contact.fixtureB != _shipBody->GetFixtureList()) && (contact.fixtureA != _groundBody->GetFixtureList() && contact.fixtureB != _groundBody->GetFixtureList())){
                NSLog(@"Heyo, bomb touched something.");
                [deleteBombs addObject:bBody];
            }
        }
        for(NSValue* bBody in laserArray){
            b2Body *body = (b2Body*)[bBody pointerValue];
            if ((contact.fixtureA == body->GetFixtureList() || contact.fixtureB == body->GetFixtureList()) && (contact.fixtureA != _shipBody->GetFixtureList() && contact.fixtureB != _shipBody->GetFixtureList()) && (contact.fixtureA != _groundBody->GetFixtureList() && contact.fixtureB != _groundBody->GetFixtureList())){
                NSLog(@"Heyo, laser touched something.");
                [deleteLaser addObject:bBody];
            }
        }
        
        
    }


    for(NSValue* pBody in deletePeople){
        [hoipolloiArray removeObject:pBody];
        [self performSelector:@selector(removeDeadBodies:) withObject:pBody afterDelay:0.7];
        
    }
    
    for(NSValue* bBody in deleteBombs){
        [bombArray removeObject:bBody];
        b2Body* nuke = (b2Body*)[bBody pointerValue];
        [self explodeAndRemoveBomb:nuke];
    }
    for(NSValue* bBody in deleteLaser){
        [laserArray removeObject:bBody];
        b2Body* nuke = (b2Body*)[bBody pointerValue];
        [self explodeAndRemoveLaser:nuke];
    }
 
    
    [deleteBombs dealloc];
    [deletePeople dealloc];
    [deleteLaser dealloc];
}

-(void)removeDeadBodies:(NSValue*)pBody{
    
    NSLog(@"Destroy polli");
    b2Body* polloi = (b2Body*)[pBody pointerValue];
    for(b2Body *b = _world->GetBodyList();b;b = b->GetNext()){
        if(polloi != NULL && polloi == b){
            _world->DestroyBody(b);
            [self removeChild:(CCSprite*)b->GetUserData()];
        }
    }
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    NSLog(@"ship position: %f",_shipBody->GetPosition().x*PTM_RATIO);
//    if(!shipCooldownMode)
//        [self singleBombFire];
    
    if (location.x <= 100 && location.y <= 60) {//touch left
        //[self schedule:@selector(moveScreenLeft)];
            b2Vec2 v = b2Vec2((-300)/PTM_RATIO,0);
            _shipBody->SetLinearVelocity(v);
            _movingLeft = YES;
        if(_shipBody->GetPosition().x*PTM_RATIO>1086.00f){
            _movingLeft = NO;
            intentToMoveLeft = YES;
        }
    }
    else if (location.x >= size.width-100 && location.y <=60) {//touch right
        //[self schedule:@selector(moveScreenRight)];
        
        b2Vec2 v = b2Vec2((300)/PTM_RATIO,0);
        _shipBody->SetLinearVelocity(v);
        _movingRight = YES;
        if(_shipBody->GetPosition().x*PTM_RATIO<-520.00f){
            _movingRight = NO;
            intentToMoveRight = YES;
        }

    }
    else{
        
            switch(_weaponMode) {
                case WEAPON_GADGET1:
                    if(!shipBombCooldownMode)
                        [self singleBombFire];
                    break;
                case WEAPON_GADGET2:
                    //weaponLabelString = @"GADGET 2 (not functional)";
                    break;
                 case WEAPON_BASIC:
                    if(!shipLaserCooldownMode && location.y <=100)
                        [self singleLazerFire:location];
                     break;
             }
        
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
   //Stop the ship
    _shipBody->SetLinearVelocity(b2Vec2((0)/PTM_RATIO,0));
    if (_movingLeft == YES) {
        _movingLeft = NO;
    }
    
    if (_movingRight == YES) {
        _movingRight = NO;
    }
    intentToMoveLeft = NO;
    intentToMoveRight = NO;
}

-(void)explodeAndRemoveBomb:(b2Body*)b{
    NSLog(@"explode!");
    
    [self createSingleExplosion:CGPointMake(b->GetPosition().x*PTM_RATIO, (b->GetPosition().y*PTM_RATIO)-10)];
        NSLog(@"Destroy b");
    if(b!=NULL){
    _world->DestroyBody(b);
    [self removeChild:(CCSprite*)b->GetUserData()];
    }
}
-(void)explodeAndRemoveLaser:(b2Body*)b{
    NSLog(@"explode!");
    
    [self createHugeExplosion:CGPointMake(b->GetPosition().x*PTM_RATIO, (b->GetPosition().y*PTM_RATIO)-10)];
    NSLog(@"Destroy b");
    if(b!=NULL){
    _world->DestroyBody(b);
    [self removeChild:(CCSprite*)b->GetUserData()];
    }
}


//returns the array of Hoipolloi
-(NSMutableArray*)getHoipolloiArray{
    NSMutableArray *arry = [[NSMutableArray alloc]init];
    
    for(NSValue* pBody in hoipolloiArray){
        
        b2Body *pody = (b2Body*)[pBody pointerValue];
        
        [arry addObject:(CCSprite*)pody->GetUserData()];
    }
    return arry;
}


-(void)spawnRandomPerson{
    NSInteger x =( arc4random() % (int)(size.width - 0+1)) + 0;
    
    Hoipolloi* _humanSprite = [CCSprite spriteWithFile:@"hoipolloi.png"];
    _humanSprite.position = CGPointMake(x, size.height/4);
    [_humanSprite setScale:0.3];
    [self addChild:_humanSprite];
    b2Body* _hoipolloiBody;
    
    //Creating Hoipolloi Box2D Body
    b2BodyDef hoipolloiBodyDef;
    hoipolloiBodyDef.type = b2_dynamicBody;
    hoipolloiBodyDef.position.Set((x)/PTM_RATIO, (size.height/4)/PTM_RATIO);
    hoipolloiBodyDef.userData = _humanSprite;
    hoipolloiBodyDef.fixedRotation = false;
    _hoipolloiBody = _world->CreateBody(&hoipolloiBodyDef);
    
    
    b2FixtureDef hoipolloiShapeDef;
    b2PolygonShape polygon;
    //    b2CircleShape circle;
    //    circle.m_radius = 20.0/PTM_RATIO;
    int num = 4;
    //    b2Vec2 vertices[] = {
    //        b2Vec2(-50.0f / PTM_RATIO, -50.0f / PTM_RATIO),
    //        b2Vec2(-100.0f / PTM_RATIO, -100.0f / PTM_RATIO),
    //        b2Vec2(100.0f / PTM_RATIO, 100.0f / PTM_RATIO),
    //        b2Vec2(50.0f / PTM_RATIO, 50.0f / PTM_RATIO)
    //    };
    
    b2Vec2 vertices[4];
    
    vertices[0].Set(-7/ PTM_RATIO, -20/ PTM_RATIO);
    vertices[1].Set(7/ PTM_RATIO,-20/ PTM_RATIO);
    vertices[2].Set(7/ PTM_RATIO,20/ PTM_RATIO);
    vertices[3].Set(-7/ PTM_RATIO,20/ PTM_RATIO);
    
    polygon.Set(vertices, num);
    hoipolloiShapeDef.shape = &polygon;
    hoipolloiShapeDef.density = 2.0f;
    hoipolloiShapeDef.friction = 0.01f;
    hoipolloiShapeDef.restitution = 0.2f;
    _hoipolloiBody->CreateFixture(&hoipolloiShapeDef);
    
    [hoipolloiArray addObject:[NSValue valueWithPointer:_hoipolloiBody]];
    
}


- (void)spawnPerson {
    Hoipolloi* _humanSprite = [CCSprite spriteWithFile:@"hoipolloi.png"];
    _humanSprite.position = CGPointMake(size.width/2, size.height/2);
    [_humanSprite setScale:0.3];
    [self addChild:_humanSprite];
    b2Body* _hoipolloiBody;
    
    //Creating Hoipolloi Box2D Body
    b2BodyDef hoipolloiBodyDef;
    hoipolloiBodyDef.type = b2_dynamicBody;
    hoipolloiBodyDef.position.Set((size.width/2+10)/PTM_RATIO, (size.height/2)/PTM_RATIO);
    hoipolloiBodyDef.userData = _humanSprite;
    hoipolloiBodyDef.fixedRotation = false;
    _hoipolloiBody = _world->CreateBody(&hoipolloiBodyDef);
    
    
    b2FixtureDef hoipolloiShapeDef;
    b2PolygonShape polygon;
//    b2CircleShape circle;
//    circle.m_radius = 20.0/PTM_RATIO;
    int num = 4;
//    b2Vec2 vertices[] = {
//        b2Vec2(-50.0f / PTM_RATIO, -50.0f / PTM_RATIO),
//        b2Vec2(-100.0f / PTM_RATIO, -100.0f / PTM_RATIO),
//        b2Vec2(100.0f / PTM_RATIO, 100.0f / PTM_RATIO),
//        b2Vec2(50.0f / PTM_RATIO, 50.0f / PTM_RATIO)
//    };
    
    b2Vec2 vertices[4];
    
    vertices[0].Set(-7/ PTM_RATIO, -20/ PTM_RATIO);
    vertices[1].Set(7/ PTM_RATIO,-20/ PTM_RATIO);
    vertices[2].Set(7/ PTM_RATIO,20/ PTM_RATIO);
    vertices[3].Set(-7/ PTM_RATIO,20/ PTM_RATIO);

    polygon.Set(vertices, num);
    hoipolloiShapeDef.shape = &polygon;
    hoipolloiShapeDef.density = 2.0f;
    hoipolloiShapeDef.friction = 0.01f;
    hoipolloiShapeDef.restitution = 0.2f;
    _hoipolloiBody->CreateFixture(&hoipolloiShapeDef);
    
    [hoipolloiArray addObject:[NSValue valueWithPointer:_hoipolloiBody]];
}

-(void)singleLazerFire:(CGPoint)point{
    
    float xPoint = point.x-283.00f;
    float yPoint = (_shipBody->GetPosition().y*PTM_RATIO)- point.y;
    float answer = atanf(xPoint/yPoint)*55;
    NSLog(@"x: %f y:%f angle:%f",xPoint,yPoint,answer);
    
    CCSprite* _laserSprite = [CCSprite spriteWithFile:@"laser.png"];
    [_laserSprite setScale:1.0f];

    [_laserSprite setPosition:CGPointMake(_shipSprite.position.x+xPoint, _shipSprite.position.y-150)];
 

    [self addChild:_laserSprite];
    
    b2BodyDef laserBodyDef;
    laserBodyDef.position.Set((_shipSprite.position.x+xPoint)/PTM_RATIO, (_shipSprite.position.y-150)/PTM_RATIO);
  
    laserBodyDef.type = b2_dynamicBody;
    laserBodyDef.userData = _laserSprite;
    laserBodyDef.fixedRotation = false;
    b2Body* _laserBody = _world->CreateBody(&laserBodyDef);

    b2PolygonShape polygon;
    int num = 4;
    b2Vec2 vertices[4];
    vertices[0].Set(-25/ PTM_RATIO, -90/ PTM_RATIO);
    vertices[1].Set(15/ PTM_RATIO,-90/ PTM_RATIO);
    vertices[2].Set(15/ PTM_RATIO,120/ PTM_RATIO);
    vertices[3].Set(-25/ PTM_RATIO,120/ PTM_RATIO);
    polygon.Set(vertices, num);
    
    b2FixtureDef laserShapeDef;
    laserShapeDef.shape = &polygon;
    laserShapeDef.density = 2.5f;
    laserShapeDef.friction = 0.8f;
    laserShapeDef.restitution = 0.2f;
    _laserBody->CreateFixture(&laserShapeDef);
    _laserBody->SetTransform(_laserBody->GetPosition(), CC_DEGREES_TO_RADIANS(answer));
//    b2Vec2 vectorForce = b2Vec2(cosf(answer),sinf(answer));
    b2Vec2 vectorForce =  b2Rot(answer).GetXAxis();
    vectorForce = 50*vectorForce;
    _laserBody->ApplyForceToCenter(vectorForce);
    _laserBody->SetGravityScale(0.1);
    [laserArray addObject:[NSValue valueWithPointer:_laserBody]];
    shipLaserCooldownMode = YES;
    [self performSelector:@selector(laserWeaponReadyToFire) withObject:self afterDelay:1.0];
}


-(void)createSingleExplosion:(CGPoint)point{
    CCSprite* _explosionSprite = [CCSprite spriteWithFile:@"explosion.png"];
    [_explosionSprite setScale:0.2f];
    [_explosionSprite setPosition:point];
    [self addChild:_explosionSprite];
    
    b2CircleShape circle;
    circle.m_radius = 35.0/PTM_RATIO;
    b2BodyDef explosionBodyDef;
    explosionBodyDef.type = b2_dynamicBody;
    explosionBodyDef.position.Set(point.x/PTM_RATIO, (point.y)/PTM_RATIO);
    explosionBodyDef.userData = _explosionSprite;
    explosionBodyDef.fixedRotation = false;
    b2Body* _explosionBody = _world->CreateBody(&explosionBodyDef);
    
    
    b2FixtureDef explosionShapeDef;
    explosionShapeDef.shape = &circle;
    explosionShapeDef.density = 2.5f;
    explosionShapeDef.friction = 0.8f;
    explosionShapeDef.restitution = 0.2f;
    _explosionBody->CreateFixture(&explosionShapeDef);
    _explosionBody->SetGravityScale(0);
    [explosionArray addObject:[NSValue valueWithPointer:_explosionBody]];
    NSLog(@"BOOM explosion added to array");
    [self performSelector:@selector(removeSingleExplosion:) withObject:[NSValue valueWithPointer:_explosionBody] afterDelay:0.1];
}
-(void)createHugeExplosion:(CGPoint)point{
    CCSprite* _explosionSprite = [CCSprite spriteWithFile:@"explosion.png"];
    [_explosionSprite setScale:0.3f];
    [_explosionSprite setPosition:point];
    [self addChild:_explosionSprite];
    
    b2CircleShape circle;
    circle.m_radius = 55.0/PTM_RATIO;
    b2BodyDef explosionBodyDef;
    explosionBodyDef.type = b2_dynamicBody;
    explosionBodyDef.position.Set(point.x/PTM_RATIO, (point.y-60)/PTM_RATIO);
    explosionBodyDef.userData = _explosionSprite;
    explosionBodyDef.fixedRotation = false;
    b2Body* _explosionBody = _world->CreateBody(&explosionBodyDef);
    
    
    b2FixtureDef explosionShapeDef;
    explosionShapeDef.shape = &circle;
    explosionShapeDef.density = 2.5f;
    explosionShapeDef.friction = 0.8f;
    explosionShapeDef.restitution = 0.2f;
    _explosionBody->CreateFixture(&explosionShapeDef);
    _explosionBody->SetGravityScale(0);
    [explosionArray addObject:[NSValue valueWithPointer:_explosionBody]];
    NSLog(@"BOOM explosion added to array");
    [self performSelector:@selector(removeSingleExplosion:) withObject:[NSValue valueWithPointer:_explosionBody] afterDelay:0.1];

}

-(void)removeSingleExplosion:(id)b{
    b2Body *xplode = (b2Body*)[b pointerValue];
    
    NSLog(@"Destroy xplode");
    for(b2Body *b = _world->GetBodyList();b;b = b->GetNext()){
        if(b == xplode){
            [explosionArray removeObject:[NSValue valueWithPointer:xplode]];
            if(b!=NULL){
            _world->DestroyBody(xplode);
            [self removeChild:(CCSprite*)xplode->GetUserData()];
            NSLog(@"not exploded");
            }
            break;
        }
    }
    
}

- (void)singleBombFire {
//    b2Vec2 force = b2Vec2(30, 30);
//    _shipBody->ApplyLinearImpulse(force,_shipBody->GetPosition());
    //Creating Hoipolloi Box2D Body
     CCSprite* _bombSprite = [CCSprite spriteWithFile:@"bomb.png"];
    [_bombSprite setScale:0.15f];
    [_bombSprite setPosition:CGPointMake(_shipSprite.position.x, _shipSprite.position.y)];
    [self addChild:_bombSprite];
    
    b2CircleShape circle;
    circle.m_radius = 15.0/PTM_RATIO;
    b2BodyDef bombBodyDef;
    bombBodyDef.type = b2_dynamicBody;
    bombBodyDef.position.Set(_shipSprite.position.x/PTM_RATIO, (_shipSprite.position.y-20)/PTM_RATIO);
    bombBodyDef.userData = _bombSprite;
    bombBodyDef.fixedRotation = false;
    b2Body* _bombBody = _world->CreateBody(&bombBodyDef);
    
    
    b2FixtureDef bombShapeDef;
    bombShapeDef.shape = &circle;
    bombShapeDef.density = 2.5f;
    bombShapeDef.friction = 0.8f;
    bombShapeDef.restitution = 0.2f;
    _bombBody->CreateFixture(&bombShapeDef);
    [bombArray addObject:[NSValue valueWithPointer:_bombBody]];
    shipBombCooldownMode = YES;
    
    [self performSelector:@selector(bombWeaponReadyToFire) withObject:self afterDelay:0.5];
}

-(void)laserWeaponReadyToFire{
    shipLaserCooldownMode = NO;
}
-(void)bombWeaponReadyToFire{
    shipBombCooldownMode = NO;
}

-(void)gravitateToCenter{
    b2Vec2 pos = _shipBody->GetPosition();
     b2Vec2 center = b2Vec2(pos.x,(size.height-50)/PTM_RATIO);
//    if(pos.x < center.x){
//        _shipBody->ApplyForce(b2Vec2(100*(center.x-pos.x), 0), center);
//        _shipBody->SetLinearDamping(2);
//    }
//    if(pos.x > center.x){
//        _shipBody->ApplyForce(b2Vec2(-100*(pos.x-center.x), 0), center);
//        _shipBody->SetLinearDamping(2);
//    }
    if(pos.y > center.y){
        _shipBody->ApplyForce(b2Vec2(0, -10*(pos.y-center.y)), center);
//        _shipBody->SetLinearDamping(2);
    }
    if(pos.y < center.y){
        _shipBody->ApplyForce(b2Vec2(0, 10*(center.y-pos.y)), center);
//        _shipBody->SetLinearDamping(2);
    }
    
}

-(void) spawnBuildingWithHeight:(int)height atPosition:(int)x{
//    [self addChild:[BuildingBlock initAtPosition:ccp(x, 150)];
//    [buildingsArray addObject:[BuildingBlock node]];
//    [self addChild:[BuildingBlock node]];
    BuildingBlock *bb1, *bb2;
    bb1 = [BuildingBlock node];
    bb2 = [BuildingBlock node];
    [bb2 setPosition:ccp(size.width/2, size.height/2 - 20)];
    [self addChild:bb1];
    [self addChild:bb2];
}
     
    

- (void)dealloc {
    delete _contactListener;
    [bombArray dealloc];
    [hoipolloiArray dealloc];
    [explosionArray dealloc];
    [buildingsArray dealloc];
    delete _world;
    _shipBody = NULL;
    _world = NULL;
    [super dealloc];
}



@end
