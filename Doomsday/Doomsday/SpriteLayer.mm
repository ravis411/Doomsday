//
//  SpriteLayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
// Laser sound effects from http://www.soundfx-free.com/
// Explosion sound effects from http://www.mediacollege.com/


#import "SpriteLayer.h"
#import "GLES-Render.h"
#define PTM_RATIO 32.0f
#define ARROWBUTTONWIDTH 100
#define GROUNDBOTTOM 60
#define GROUNDTOP 100

@implementation SpriteLayer

@synthesize movingLeft = _movingLeft;
@synthesize movingRight = _movingRight;
@synthesize enemiesKilled = _enemiesKilled;
@synthesize weaponMode = _weaponMode;
@synthesize gameOver = _gameOver;
@synthesize playerDead = _playerDead;

+(id)nodeWithGameLevel:(int)level sound:(BOOL)s music:(BOOL)m{
//    return  [[[self alloc] initWithGameLevel:level] autorelease];
    
    return  [[[self alloc] initWithLevel:level sound:s music:m] autorelease];
}

-(id)initWithLevel:(int)level sound:(BOOL)s music:(BOOL)m{
    if(self = [super init]){
        missionLevel = level;
        [self setTouchEnabled:YES];
        NSLog(@"sprite sound: %hhd",s);
        NSLog(@"sprite music: %hhd",m);
        soundOn = s;
        musicOn = m;
        _gameOver = NO;
        _firstBlood = NO;
        bombArray = [[NSMutableArray alloc]init];
        hoipolloiArray = [[NSMutableArray alloc]init];
        buildingsArray = [[NSMutableArray alloc] init];
        debrisArray = [[NSMutableArray alloc] init];
        deletedDebris = [[NSMutableArray alloc] init];
        explosionArray = [[NSMutableArray alloc]init];
        laserArray = [[NSMutableArray alloc]init];
        deletedBombs = [[NSMutableArray alloc]init];
        deletedLaser = [[NSMutableArray alloc]init];
        deletedPeople= [[NSMutableArray alloc]init];
        enemyGunBodyArray = [[NSMutableArray alloc] init];
        enemyWeaponArray = [[NSMutableArray alloc]init];
        deletedEnemyWeapon = [[NSMutableArray alloc] init];
        intentToMoveLeft = NO;
        intentToMoveRight = NO;
        shipLaserCooldownMode = NO;
        shipBombCooldownMode = NO;
        shipSpriteCooldown = 0;
        shipHitTex = [[CCTextureCache sharedTextureCache] addImage:@"ship_hit.png"];
        shipNormalTex = [[CCTextureCache sharedTextureCache] addImage:@"ship_normal.png"];
        if(soundOn){
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"laser.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion.mp3"];
        }
        enemyWeaponCooldownMode = NO;
        _playerDead = NO;
        
        //Initialize Player Health to 100
        playerHealth = 100;
        
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
        boxShapeDef.filter.categoryBits = 2;
        
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
//        shipShapeDef.density = 1.0f;
        shipShapeDef.density = 200.0f;
        shipShapeDef.friction = 0.2f;
        shipShapeDef.restitution = 0.1f;
        shipShapeDef.filter.categoryBits = 4;//This makes the ship not collide with anything!
        shipShapeDef.filter.maskBits = 8;
        _shipBody->CreateFixture(&shipShapeDef);
    
        _shipBody->SetGravityScale(0);
        _shipBody->SetLinearVelocity(b2Vec2(0.0f,0.5f));
        

        
//      _hoipolloiBody->SetGravityScale(2);
        
//        [self schedule:@selector(tick:)];
        //[self schedule:@selector(kick) interval:10.0];
        
        for(NSInteger i = 1; i < 10+missionLevel; i++ ){
            [self spawnRandomPerson];
        }
        if(missionLevel>7){
        for(NSInteger i = 1; i < 3; i++ ){
            [self spawnRandomEnemyWeaponBody];
        }
        }
        
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        
//        [self spawnBuildingWithHeight:1 atPosition:(size.width/2)];
        
        //testing
//        [self spawnDebrisAtPosition:ccp(size.width/2, size.height/2)];
        if(missionLevel>4){
                CGPoint center = ccp(size.width/2, size.height/2);
                [self spawnDebrisRectAt:center.x width:2 height:3];
        }
        if(missionLevel>8){
            CGPoint center = ccp(size.width+300, size.height/2);
            [self spawnDebrisRectAt:center.x width:2 height:3];
        }
        if(missionLevel>12){
            CGPoint center = ccp(-300, size.height/2);
            [self spawnDebrisRectAt:center.x width:2 height:3];
        }
        
    }
    return self;
}

-(int)getPlayerHealth{
    return playerHealth;
}


-(void)update:(ccTime)dt{
  
    
    if( (NSInteger)(dt*769) % 2 == 0){
        if((int)[hoipolloiArray count]<20+missionLevel){
            if (missionLevel > 4) {
                [self spawnPerson];
                [self spawnRandomPerson];
            } else {
                [self spawnRandomPerson];
            }
        }
    }

    if(_enemiesKilled >10*missionLevel){
        _gameOver = YES;
    }
    
    
    if (shipSpriteCooldown > 0) {
        shipSpriteCooldown--;
    }
    else {
        [_shipSprite setTexture:shipNormalTex];
    }
    
    if(playerHealth <= 0){
        _playerDead = YES;
    }
    
    //Makes sure ship stays in place in the center
    b2Vec2 pos = _shipBody->GetPosition();
    b2Vec2 center = b2Vec2(pos.x,(size.height-50)/PTM_RATIO);
    if((pos - center).Length() != 0){
        [self gravitateToCenter];
    }
    if(pos.y*PTM_RATIO>size.height+10){
        shipBombCooldownMode = YES;
        shipLaserCooldownMode = YES;
    }

    //This code makes the people move away from the ship.
    b2Vec2 left = b2Vec2((-80)/PTM_RATIO,0);
    b2Vec2 right = b2Vec2((80)/PTM_RATIO,0);

    b2Vec2 tankLeft = b2Vec2((-40)/PTM_RATIO,0);
    b2Vec2 tankRight = b2Vec2((40)/PTM_RATIO,0);

    if(enemyWeaponCooldownMode == NO){
        for (EnemyGunBody* tank in enemyGunBodyArray){
            b2Body *tankBody = (b2Body*)[tank pointerValue];
            //if ([tank enemyWeaponCooldownMode] == NO){
                [self enemyAttack:tankBody];
                //[self performSelector:@selector(enemyReadyToAttack:) withObject:self afterDelay:2.0];
            //}
        }
    }
    
    for(EnemyGunBody* pBody in enemyGunBodyArray){
        b2Body *pody = (b2Body*)[pBody pointerValue];
//        if(pody->GetPosition().x/PTM_RATIO <= ((_shipBody->GetPosition().x/PTM_RATIO)) && pody->GetPosition().x >= (_shipBody->GetPosition().x)){
        if(pody->GetPosition().x/PTM_RATIO <= ((_shipBody->GetPosition().x/PTM_RATIO))){
            pody->SetLinearVelocity(tankRight);
            [(id)pody->GetUserData() setMovingRight:YES];
//        }else  if(pody->GetPosition().x/PTM_RATIO >= ((_shipBody->GetPosition().x/PTM_RATIO)-0.10f) && pody->GetPosition().x <= (_shipBody->GetPosition().x)){
            }else  if(pody->GetPosition().x/PTM_RATIO >= ((_shipBody->GetPosition().x/PTM_RATIO))){
            pody->SetLinearVelocity(tankLeft);
            [(id)pody->GetUserData() setMovingRight:NO];
        }

    }
    
    for(NSValue* pBody in enemyWeaponArray){
        b2Body *pody = (b2Body*)[pBody pointerValue];
        if(pody->GetPosition().y/PTM_RATIO >= ((_shipBody->GetPosition().y/PTM_RATIO)+0.05f)) {
            [deletedEnemyWeapon addObject:pBody];
        }
    }
    
    for(Hoipolloi* pBody in hoipolloiArray){
        
//        Hoipolloi hp = [pBody pointerValue];
        b2Body *pody = (b2Body*)[pBody pointerValue];
        
        float s = 50 + arc4random_uniform(40);
        s += ((1 - (int)(arc4random_uniform(2))) * 120);
        if (!_firstBlood) {
            s = s/3;
            int g = [(id)pody->GetUserData() gawp];
            if (g > 0) {s = 0;}
            float doesStop = arc4random_uniform(100);
            if (doesStop > 98) {[(id)pody->GetUserData() gawpFor:60];}
        }
        left = b2Vec2((-1 * s)/PTM_RATIO,0);
        right = b2Vec2((s)/PTM_RATIO,0);
        
        
            if([(id)pody->GetUserData() stamina] <= 0){
                NSUInteger r = arc4random_uniform(2);
                if(r==0){
                    pody->SetLinearVelocity(right);
                    [(id)pody->GetUserData() setMovingRight:YES];
                }
                else{
                    pody->SetLinearVelocity(left);
                    [(id)pody->GetUserData() setMovingRight:NO];
                }
                [(id)pody->GetUserData() resetStamina];
            }
            else{
                
                if(pody->GetPosition().x/PTM_RATIO <= ((pos.x/PTM_RATIO)+0.15f) && pody->GetPosition().x >= (pos.x)){
                    pody->SetLinearVelocity(right);
                    [(id)pody->GetUserData() setMovingRight:YES];
                }else  if(pody->GetPosition().x/PTM_RATIO >= ((pos.x/PTM_RATIO)-0.15f) && pody->GetPosition().x <= (pos.x)){
                    pody->SetLinearVelocity(left);
                    [(id)pody->GetUserData() setMovingRight:NO];
                }
                else if([(id)pody->GetUserData() movingRight]){
                    pody->SetLinearVelocity(right);
                }else{
                    pody->SetLinearVelocity(left);
                }
                [(id)pody->GetUserData() decreaseStamina];
            }
        }
        
       
    
    
 /*
    //Update children
    for(CCSprite *hp in self.children){
        if([hp isKindOfClass:[Hoipolloi class]]){
            //[((Hoipolloi *)hp) update:dt body:];
        }
    }*/

    if((_shipBody->GetPosition().x*PTM_RATIO>1330.00f && _movingRight == YES) || (_shipBody->GetPosition().x*PTM_RATIO<-765.00f && _movingLeft == YES)){
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
    
    [self collisionDetection];

    
//============================================================
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *bodyData = (CCSprite *)b->GetUserData();
            bodyData.position = ccp(b->GetPosition().x * 32, b->GetPosition().y * 32);
            bodyData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    _world->Step(dt, 10, 10);
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
    
    //Collision with the bomb and the ground
    for(NSValue* bBody in bombArray){
        b2Body *body = (b2Body*)[bBody pointerValue];
        if((body->GetPosition().y*PTM_RATIO <(groundLevel+35))){
            [deletedBombs addObject:bBody];
        }
    }
    
    BOOL hitPerson = NO;
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
                    _enemiesKilled++;
                    CCSprite* dead = [CCSprite spriteWithFile:@"deadhoipolloi.png"];
                    dead.position = CGPointMake(size.width/2, size.height/2);
                    [dead setScale:0.3];
                    [self addChild:dead];
                    [self removeChild:(CCSprite*)pody->GetUserData()];
                    pody->SetUserData(dead);
                    [deletedPeople addObject:pBody];
                    NSLog(@"\nEnemies Killed: %d\n\n", _enemiesKilled);
                    
                }
            }//Collision detection for building debris should kill humans if it lands on them?
            for (NSValue* ds in debrisArray) {
                b2Body *dbody = (b2Body*)[ds pointerValue];
                if((contact.fixtureA == dbody->GetFixtureList() && contact.fixtureB == pody->GetFixtureList()) || (contact.fixtureA == pody->GetFixtureList() && contact.fixtureB == dbody->GetFixtureList())) {
                    if ( (dbody->GetPosition().y - (30/PTM_RATIO) ) > pody->GetPosition().y ) {
                         NSLog(@"\nDebris landed on a person?...\n");
                        _enemiesKilled++;
                        CCSprite* dead = [CCSprite spriteWithFile:@"deadhoipolloi.png"];
                        dead.position = CGPointMake(size.width/2, size.height/2);
                        [dead setScale:0.3];
                        [self addChild:dead];
                        [self removeChild:(CCSprite*)pody->GetUserData()];
                        pody->SetUserData(dead);
                        [deletedPeople addObject:pBody];
                        NSLog(@"\nEnemies Killed: %d\n\n", _enemiesKilled);

                    }
                   
                }
            }
            
        }
        
        //NSLog(@"\n\nNumber of Bullets: %d\n\n",enemyWeaponArray.count);
        for(NSValue* pBody in enemyWeaponArray){
            //NSLog(@"\na bullet in the enemy array\n");
            b2Body *pody = (b2Body*)[pBody pointerValue];
            if ((contact.fixtureA == _shipBody->GetFixtureList() && contact.fixtureB == pody->GetFixtureList()) || (contact.fixtureA == pody->GetFixtureList() && contact.fixtureB == _shipBody->GetFixtureList())) {
                NSLog(@"\nEnemy Bullet hit the ship\n");
                playerHealth = playerHealth - 20;
                
                [deletedEnemyWeapon addObject:pBody];
                shipSpriteCooldown = 12;
                [_shipSprite setTexture:shipHitTex];
            }
        }
        
        
        //Collision detection for bomb
        for(NSValue* bBody in bombArray){
            b2Body *body = (b2Body*)[bBody pointerValue];
            if ((contact.fixtureA == body->GetFixtureList() || contact.fixtureB == body->GetFixtureList()) && (contact.fixtureA != _shipBody->GetFixtureList() && contact.fixtureB != _shipBody->GetFixtureList()) && (contact.fixtureA != _groundBody->GetFixtureList() && contact.fixtureB != _groundBody->GetFixtureList())){
                NSLog(@"Heyo, bomb touched something.");
                [deletedBombs addObject:bBody];
                if (!_firstBlood) {_firstBlood = YES;}

            }
        }
        
        for(NSValue* bBody in laserArray){
            b2Body *body = (b2Body*)[bBody pointerValue];
            if ((contact.fixtureA == body->GetFixtureList() || contact.fixtureB == body->GetFixtureList()) && (contact.fixtureA != _shipBody->GetFixtureList() && contact.fixtureB != _shipBody->GetFixtureList()) && (contact.fixtureA != _groundBody->GetFixtureList() && contact.fixtureB != _groundBody->GetFixtureList())){
                if(!hitPerson){
                    NSLog(@"Heyo, laser touched something.");
                    hitPerson = YES;
                    if (!_firstBlood) {_firstBlood = YES;}
                    [deletedLaser addObject:bBody];
                }
            }
        }

        
        //Collision detection for building debris and explosions
        for (NSValue* d in debrisArray) {
            b2Body *b = (b2Body*)[d pointerValue];
            
            for(NSValue* eBody in explosionArray){
                b2Body *eX = (b2Body*)[eBody pointerValue];
                
                if ((contact.fixtureA == eX->GetFixtureList() && contact.fixtureB == b->GetFixtureList()) || (contact.fixtureA == b->GetFixtureList() && contact.fixtureB == eX->GetFixtureList())) {
                    NSLog(@"Explosion hit building debris.");
                    
                    if (eX->GetPosition().x > b->GetPosition().x) {
                        b->SetAngularVelocity(20);
                    }
                    else{
                        b->SetAngularVelocity(-20);
                    }
                    [((Debris *)(b->GetUserData())) hitByExplosion];
                }
            }
        
            //Check if debris should be removed.
            if ( ((Debris*)b->GetUserData()).shouldRemoveMe) {
                [deletedDebris addObject:d];
                ((Debris*)b->GetUserData()).shouldRemoveMe = NO;//dont want to add to deletedtwice
            }
        }
        
    }


    for(NSValue* pBody in deletedPeople){
        [hoipolloiArray removeObject:pBody];
        [self performSelector:@selector(removeDeadBodies:) withObject:pBody afterDelay:0.7];
        
    }
    
    for(NSValue* bBody in deletedBombs){
        [bombArray removeObject:bBody];
        b2Body* nuke = (b2Body*)[bBody pointerValue];
        [self explodeAndRemoveBomb:nuke];
    }
    for(NSValue* bBody in deletedLaser){
        [laserArray removeObject:bBody];
        b2Body* nuke = (b2Body*)[bBody pointerValue];
        [self explodeAndRemoveLaser:nuke];
    }
    for(NSValue* dBody in deletedDebris){
        [debrisArray removeObject:dBody];
        b2Body* nuke = (b2Body*)[dBody pointerValue];
        NSLog(@"Destroy Debris");
        for(b2Body *b = _world->GetBodyList();b;b = b->GetNext()){
            if(nuke != NULL && nuke == b){
                _world->DestroyBody(b);
                [self removeChild:(CCSprite*)b->GetUserData()];
                break;
            }
        }
    }
    for(NSValue* bBody in deletedEnemyWeapon){
        [enemyWeaponArray removeObject:bBody];
        b2Body* nuke = (b2Body*)[bBody pointerValue];
        [self explodeAndRemoveEnemyWeapon:nuke];
    }
 
    
    [deletedBombs removeAllObjects];
    [deletedPeople removeAllObjects];
    [deletedLaser removeAllObjects];
    [deletedDebris removeAllObjects];
    [deletedEnemyWeapon removeAllObjects];
}

-(void)removeDeadBodies:(NSValue*)pBody{
    
    NSLog(@"Destroy polli");
    b2Body* polloi = (b2Body*)[pBody pointerValue];
    for(b2Body *b = _world->GetBodyList();b;b = b->GetNext()){
        if(polloi != NULL && polloi == b){
            _world->DestroyBody(b);
            [self removeChild:(CCSprite*)b->GetUserData()];
//            [(CCSprite*)b->GetUserData() release];
        }
    }
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    for( UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        NSLog(@"ship position: %f",_shipBody->GetPosition().x*PTM_RATIO);

        if (location.x <= ARROWBUTTONWIDTH && ( location.y <= GROUNDBOTTOM || location.y >= GROUNDTOP ) ) {//touch left
            //[self schedule:@selector(moveScreenLeft)];
                b2Vec2 v = b2Vec2((-300)/PTM_RATIO,0);
                _shipBody->SetLinearVelocity(v);
                _movingLeft = YES;
            if(_shipBody->GetPosition().x*PTM_RATIO>1086.00f){
                _movingLeft = NO;
                intentToMoveLeft = YES;
            }
        }
        else if(location.x >= size.width - ARROWBUTTONWIDTH && (location.y <= GROUNDBOTTOM || location.y >= GROUNDTOP) ){//touch right
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
                    if(!shipLaserCooldownMode && location.y <= GROUNDTOP)
                        [self singleLazerFire:location];
                     break;
             }
        }
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for( UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        if ((location.x <= ARROWBUTTONWIDTH && ( location.y <= GROUNDBOTTOM || location.y >= GROUNDTOP ) ) || (location.x >= size.width - ARROWBUTTONWIDTH && (location.y <= GROUNDBOTTOM || location.y >= GROUNDTOP) )) {//touch left
            
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

    }
}




-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for( UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        if ((location.x <= ARROWBUTTONWIDTH && ( location.y <= GROUNDBOTTOM || location.y >= GROUNDTOP ) ) || (location.x >= size.width - ARROWBUTTONWIDTH && (location.y <= GROUNDBOTTOM || location.y >= GROUNDTOP) )) {//touch left
        
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
    }

}

-(void)explodeAndRemoveBomb:(b2Body*)b{
    NSLog(@"explode!");
    [self createHugeExplosion:CGPointMake(b->GetPosition().x*PTM_RATIO, (b->GetPosition().y*PTM_RATIO)-10)];
    
        NSLog(@"Destroy b");
    if(b!=NULL){
    _world->DestroyBody(b);
    [self removeChild:(CCSprite*)b->GetUserData()];
    }
}
-(void)explodeAndRemoveLaser:(b2Body*)b{
    NSLog(@"explode!");
    
    [self createSingleExplosion:CGPointMake(b->GetPosition().x*PTM_RATIO, (b->GetPosition().y*PTM_RATIO)-10)];
    NSLog(@"Destroy b");
    if(b!=NULL){
    _world->DestroyBody(b);
    [self removeChild:(CCSprite*)b->GetUserData()];
    }
}
-(void)explodeAndRemoveEnemyWeapon:(b2Body*)b{
    NSLog(@"explode!");
    
    [self createSingleExplosion:CGPointMake(b->GetPosition().x*PTM_RATIO, (b->GetPosition().y*PTM_RATIO)-10)];
    NSLog(@"Destroy b");
    if(b!=NULL){
        _world->DestroyBody(b);
        [self removeChild:(CCSprite*)b->GetUserData()];
    }
}


//returns the array of Hoipolloi



-(void)spawnRandomPerson{
    NSInteger x =( arc4random() % (int)(size.width - 0+1)) + 0;
    
    Hoipolloi* _humanSprite = [[[Hoipolloi alloc]init]autorelease];
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
    int num = 4;
    
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
    hoipolloiShapeDef.filter.categoryBits = 1;
    hoipolloiShapeDef.filter.maskBits = 2;
    _hoipolloiBody->CreateFixture(&hoipolloiShapeDef);
    
    [hoipolloiArray addObject:[NSValue valueWithPointer:_hoipolloiBody]];
    
}

-(void)spawnRandomEnemyWeaponBody{
    NSInteger x =( arc4random() % (int)(size.width - 0+1)) + 0;
    
    EnemyGunBody* _tankSprite = [[[EnemyGunBody alloc]init]autorelease];
    //CCSprite *_tankSprite = [CCSprite spriteWithFile:@"tank.png"];
    _tankSprite.position = CGPointMake(x, size.height/4);
    [_tankSprite setScale:0.7];
    [self addChild:_tankSprite];
    b2Body* _tankBody;
    
    //Creating Tank Box2D Body
    b2BodyDef tankBodyDef;
    //tankBodyDef.type = b2_staticBody;
    tankBodyDef.type = b2_dynamicBody;
    tankBodyDef.position.Set((x)/PTM_RATIO, (size.height/4)/PTM_RATIO);
    tankBodyDef.userData = _tankSprite;
    tankBodyDef.fixedRotation = true;
    
    _tankBody = _world->CreateBody(&tankBodyDef);
    
    
    b2FixtureDef tankShapeDef;
    b2PolygonShape polygon;
    int num = 4;
    
    b2Vec2 vertices[4];
    
    vertices[0].Set(-7/ PTM_RATIO, -20/ PTM_RATIO);
    vertices[1].Set(7/ PTM_RATIO,-20/ PTM_RATIO);
    vertices[2].Set(7/ PTM_RATIO,20/ PTM_RATIO);
    vertices[3].Set(-7/ PTM_RATIO,20/ PTM_RATIO);
    
    polygon.Set(vertices, num);
    tankShapeDef.shape = &polygon;
    tankShapeDef.density = 2.0f;
    tankShapeDef.friction = 0.01f;
    tankShapeDef.restitution = 0.7f;
    tankShapeDef.filter.categoryBits = 1;
    tankShapeDef.filter.maskBits = 2;
    _tankBody->CreateFixture(&tankShapeDef);
    
    [enemyGunBodyArray addObject:[NSValue valueWithPointer:_tankBody]];
    
}


- (void)spawnPerson {
    Hoipolloi* _humanSprite = [[[Hoipolloi alloc]init]autorelease];
    _humanSprite.position = CGPointMake(size.width/2, GROUNDBOTTOM + 20);
    [_humanSprite setScale:0.3];
    [self addChild:_humanSprite];
    b2Body* _hoipolloiBody;
    
    //Creating Hoipolloi Box2D Body
    b2BodyDef hoipolloiBodyDef;
    hoipolloiBodyDef.type = b2_dynamicBody;
    hoipolloiBodyDef.position.Set((size.width/2+10)/PTM_RATIO, (GROUNDBOTTOM + 20)/PTM_RATIO);
    hoipolloiBodyDef.userData = _humanSprite;
    hoipolloiBodyDef.fixedRotation = false;
    
    _hoipolloiBody = _world->CreateBody(&hoipolloiBodyDef);
    
    
    b2FixtureDef hoipolloiShapeDef;
    b2PolygonShape polygon;
    int num = 4;
    
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
    hoipolloiShapeDef.filter.categoryBits = 1;
    hoipolloiShapeDef.filter.maskBits = 2;

    _hoipolloiBody->CreateFixture(&hoipolloiShapeDef);
    
    [hoipolloiArray addObject:[NSValue valueWithPointer:_hoipolloiBody]];
}

-(void)singleLazerFire:(CGPoint)point{
    
    float xPoint = point.x-283.00f;
    if(_shipBody->GetPosition().x*PTM_RATIO>1120.00f){
        xPoint+=((_shipBody->GetPosition().x*PTM_RATIO)-1120.00)*-1;
    }
    else if(_shipBody->GetPosition().x*PTM_RATIO<-520.00f){
        xPoint+=((_shipBody->GetPosition().x*PTM_RATIO)+520.00)*-1;
    }
    
    
    float yPoint = (_shipBody->GetPosition().y*PTM_RATIO)- point.y;
    float answer = atanf(xPoint/yPoint)*55;
    
    CCSprite* _laserSprite = [CCSprite spriteWithFile:@"laser.png"];
    [_laserSprite setScale:0.3f];

    [_laserSprite setPosition:CGPointMake((_shipBody->GetPosition().x*PTM_RATIO)+xPoint, (_shipBody->GetPosition().y*PTM_RATIO)-150)];
    NSLog(@"ship x position: %f", _shipSprite.position.x);

    [self addChild:_laserSprite];
    
    b2BodyDef laserBodyDef;

    laserBodyDef.position.Set(((_shipBody->GetPosition().x*PTM_RATIO)+(xPoint/2))/PTM_RATIO, ((_shipBody->GetPosition().y*PTM_RATIO)-50)/PTM_RATIO);
    NSLog(@"x: %f y:%f angle:%f",xPoint,yPoint,answer);
    laserBodyDef.type = b2_dynamicBody;
    laserBodyDef.userData = _laserSprite;
    laserBodyDef.fixedRotation = true;
    b2Body* _laserBody = _world->CreateBody(&laserBodyDef);

    b2PolygonShape polygon;
    int num = 4;
    b2Vec2 vertices[4];
    vertices[0].Set(-5/ PTM_RATIO, -18/ PTM_RATIO);
    vertices[1].Set(3/ PTM_RATIO,-18/ PTM_RATIO);
    vertices[2].Set(3/ PTM_RATIO,24/ PTM_RATIO);
    vertices[3].Set(-5/ PTM_RATIO,24/ PTM_RATIO);
    polygon.Set(vertices, num);
    
    b2FixtureDef laserShapeDef;
    laserShapeDef.shape = &polygon;
    laserShapeDef.density = 2.5f;
    laserShapeDef.friction = 0.8f;
    laserShapeDef.restitution = 0.2f;
    laserShapeDef.filter.categoryBits = 2;
    _laserBody->CreateFixture(&laserShapeDef);
    _laserBody->SetTransform(_laserBody->GetPosition(), CC_DEGREES_TO_RADIANS(answer));
 
    
    b2Vec2 force = b2Vec2(xPoint, -1*yPoint);
    force *= 10.5;  // Use this if your game engine uses an explicit time step
    b2Vec2 p = _laserBody->GetWorldPoint(b2Vec2(0.0f, 0.0f));
    _laserBody->ApplyForce(force, p);
    
    _laserBody->SetGravityScale(0.0f);
//    _laserBody->SetFixedRotation(YES);
    [laserArray addObject:[NSValue valueWithPointer:_laserBody]];
    shipLaserCooldownMode = YES;
    [self performSelector:@selector(laserWeaponReadyToFire) withObject:self afterDelay:0.5];
    if(soundOn){
    [[SimpleAudioEngine sharedEngine] playEffect:@"laser.mp3"];
    }
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
    explosionShapeDef.filter.categoryBits = 2;
    _explosionBody->CreateFixture(&explosionShapeDef);
    _explosionBody->SetGravityScale(0);
    [explosionArray addObject:[NSValue valueWithPointer:_explosionBody]];
    NSLog(@"BOOM explosion added to array");
    [self performSelector:@selector(removeSingleExplosion:) withObject:[NSValue valueWithPointer:_explosionBody] afterDelay:0.1];
    if(soundOn){
    [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.mp3"];
    }
}
-(void)createHugeExplosion:(CGPoint)point{
    CCSprite* _explosionSprite = [CCSprite spriteWithFile:@"explosion.png"];
    [_explosionSprite setScale:0.3f];
    [_explosionSprite setPosition:point];
    [self addChild:_explosionSprite];
    
    b2CircleShape circle;
    circle.m_radius = 55.0/PTM_RATIO;
    b2BodyDef explosionBodyDef;
    NSLog(@"Explosion Point Y: %f", point.y-60);
    if(point.y<120)
        point.y = 120;
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
    explosionShapeDef.filter.categoryBits = 2;
    _explosionBody->CreateFixture(&explosionShapeDef);
    _explosionBody->SetGravityScale(0);
    [explosionArray addObject:[NSValue valueWithPointer:_explosionBody]];
    NSLog(@"BOOM explosion added to array");
    [self performSelector:@selector(removeSingleExplosion:) withObject:[NSValue valueWithPointer:_explosionBody] afterDelay:0.1];
    if(soundOn){
        [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.mp3"];
    }
    
}

-(void)removeSingleExplosion:(id)b{
    b2Body *xplode = (b2Body*)[b pointerValue];
    
    NSLog(@"Destroy xplode");
    for(b2Body *b = _world->GetBodyList();b;b = b->GetNext()){
        if(b == xplode){
            [explosionArray removeObject:[NSValue valueWithPointer:xplode]];
            if(b!=NULL){
                _world->DestroyBody(xplode);
            [   self removeChild:(CCSprite*)xplode->GetUserData()];
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
    bombShapeDef.restitution = 0.2f;
    bombShapeDef.filter.categoryBits = 2;
    _bombBody->CreateFixture(&bombShapeDef);
    [bombArray addObject:[NSValue valueWithPointer:_bombBody]];
    shipBombCooldownMode = YES;
//    _bombBody->SetLinearVelocity(b2Vec2((0)/PTM_RATIO,100));
    
    [self performSelector:@selector(bombWeaponReadyToFire) withObject:self afterDelay:1.0];
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
        _shipBody->ApplyForce(b2Vec2(0, -1000*(pos.y-center.y)), center);
//        _shipBody->SetLinearDamping(2);
    }
    if(pos.y < center.y){
        _shipBody->ApplyForce(b2Vec2(0, 1000*(center.y-pos.y)), center);
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
//    b2SquareShape* bSqS;
    [bb2 setPosition:ccp(size.width/2, size.height/2 - 20)];
    [self addChild:bb1];
    [self addChild:bb2];
}

-(void) spawnDebrisAtPosition:(CGPoint)cgp {
    NSLog(@"Spawning debris");
    Debris* d = [[[Debris alloc] makeInWorld:_world atPosition:cgp]autorelease] ;
    
    [debrisArray addObject:[NSValue valueWithPointer:[d body]]];
    [self addChild:d];
    
}

-(void) spawnDebrisRectAt:(float)mX width:(int)w height:(int)h {
    float dimY = 60;
    float dimX = 70;
    float tX = mX;
    float tY = groundLevel + 31 + 1;
    CGPoint tCGP;
    
    for (int jj = 0; jj < h; jj++) {
        for(int ii = 0; ii < w; ii++) {
            tCGP = ccp(tX + 1 + (ii * dimX), tY  + (jj * dimY));
            [self spawnDebrisAtPosition:tCGP];
        }
    }
}

//Enemy Attack
- (void)enemyAttack: (b2Body *)tankBody {

    
    //Second Implementation
    
    CGPoint point = ccp(_shipBody->GetPosition().x, _shipBody->GetPosition().y);
    
    //float xPoint = point.x-283.00f;
    float xPoint = point.x;
    
    
    float yPoint = (tankBody->GetPosition().y*PTM_RATIO)- point.y;
    float answer = atanf(xPoint/yPoint)*55;
    
    CCSprite* _bulletSprite = [CCSprite spriteWithFile:@"bullet.png"];
    [_bulletSprite setScale:0.3f];
    
    [_bulletSprite setPosition:CGPointMake((tankBody->GetPosition().x*PTM_RATIO)+xPoint, (tankBody->GetPosition().y*PTM_RATIO)+30)];
    //NSLog(@"ship x position: %f", _shipSprite.position.x);
    
    [self addChild:_bulletSprite];
    
    b2BodyDef bulletBodyDef;
    
    bulletBodyDef.position.Set(((tankBody->GetPosition().x*PTM_RATIO)+(xPoint/2))/PTM_RATIO, ((tankBody->GetPosition().y*PTM_RATIO))/PTM_RATIO);
    NSLog(@"x: %f y:%f angle:%f",xPoint,yPoint,answer);
    bulletBodyDef.type = b2_dynamicBody;
    bulletBodyDef.userData = _bulletSprite;
    bulletBodyDef.fixedRotation = true;
    b2Body* _bulletBody = _world->CreateBody(&bulletBodyDef);
    

    b2CircleShape circle;
    circle.m_radius = 10.0/PTM_RATIO;
    b2FixtureDef bulletShapeDef;
    bulletShapeDef.shape = &circle;
    bulletShapeDef.density = 2.5f;
    bulletShapeDef.friction = 0.8f;
    bulletShapeDef.restitution = 0.2f;
    bulletShapeDef.filter.categoryBits = 8;
    bulletShapeDef.filter.maskBits = 4;
    _bulletBody->CreateFixture(&bulletShapeDef);

    
    //b2Vec2 force = b2Vec2(xPoint, yPoint);
    
//    _bombBody->SetLinearVelocity(b2Vec2((0)/PTM_RATIO,100));
    
//    b2Vec2 force = b2Vec2((_shipBody->GetPosition().x*PTM_RATIO)-(xPoint/4)/PTM_RATIO, _shipBody->GetPosition().y*PTM_RATIO);
    
    b2Vec2 force = b2Vec2(0, _shipBody->GetPosition().y*PTM_RATIO);

    
    //force *= 5.5;  // Use this if your game engine uses an explicit time step
    b2Vec2 p = _bulletBody->GetWorldPoint(b2Vec2(0.0f, 0.0f));
    _bulletBody->ApplyForce(force, p);
    
    _bulletBody->SetGravityScale(0.0f);
    //    _laserBody->SetFixedRotation(YES);


    [enemyWeaponArray addObject:[NSValue valueWithPointer:_bulletBody]];
    enemyWeaponCooldownMode = YES;
    [self performSelector:@selector(enemyReadyToAttack) withObject:self afterDelay:3.0];
    NSLog(@"\n\nENEMY FIRED\n\n");
    NSLog(@"\n\nNumber of Bullets: %d\n\n",enemyWeaponArray.count);

    
    
}

-(void) enemyReadyToAttack{
    //[tank setEnemyWeaponCooldownMode:YES];
    enemyWeaponCooldownMode = NO;
}
    

- (void)dealloc {
    delete _contactListener;
    [bombArray release];
    [hoipolloiArray release];
    [explosionArray release];
    [buildingsArray release];
    [debrisArray release];
    [deletedDebris release];
    [laserArray release];
    [deletedBombs release];
    [deletedLaser release];
    [deletedPeople release];
    [enemyGunBodyArray release];
    [enemyWeaponArray release];
    [deletedEnemyWeapon release];
    
    delete _world;
    _shipBody = NULL;
    _world = NULL;
    [super dealloc];
}



@end
