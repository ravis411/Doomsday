//
//  HelloWorldLayer.mm
//  Doomsday
//
//  Created by Andrew Han on 3/24/14.
//  Copyright TeamDoomsday 2014. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"
#import "GameplayScene.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"


enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;

@end

@implementation HelloWorldLayer

@synthesize uiL = uiLayer;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	// add layer as a child to scene
	[scene addChild: layer];
    if (!layer.uiL) {
        layer.uiL = [UILayer node];
    };
    [layer createMenu];
    [scene addChild: layer.uiL];
    
	
	// return the scene
	return scene;
}


-(id) init
{
	if( (self=[super init])) {
		
		// enable events
        menuScene = [CCScene node];
        if (!uiLayer) {uiLayer = [UILayer node];};
//        [menuScene addChild:uiLayer];
        
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
		CGSize s = [CCDirector sharedDirector].winSize;
		size = [[CCDirector sharedDirector] winSize];
        
		// init physics
		[self initPhysics];
		//batching sprites
        
        
        //batching the GUI elements
        uiAtlasNode = [CCSpriteBatchNode batchNodeWithFile:@"gui_atlas.png"];
        [self addChild:uiAtlasNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gui_atlas.plist"];
        
        int numberUIFrames = 0;
        NSMutableArray *uiFrames = [NSMutableArray array];
        NSMutableArray *uiFilenames = [NSMutableArray array];
        for (int ii = 1; ii <= 5; ii++) {
            for (int jj = 0; jj <= 1; jj++) {
                NSString *file = [NSString stringWithFormat:@"button%d_%d.png", ii, 0];
                [uiFilenames addObject:file];
                numberUIFrames++;
            }
        }
        
        [uiFilenames addObject:@"cosmos.png"];
        [uiFilenames addObject:@"dash_mainmenu.png"];
        [uiFilenames addObject:@"dashboard.png"];
        [uiFilenames addObject:@"failure_message.png"];
        [uiFilenames addObject:@"killcounter.png"];
        [uiFilenames addObject:@"titletypeface.png"];
        [uiFilenames addObject:@"victory_message.png"];
        numberUIFrames += 7;
        
        for (int i = 0; i < numberUIFrames; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:uiFilenames[i]];
            [uiFrames addObject:frame];
        }

        //Batching building blocks
        int numberBuildingFrames = 0;
        buildingAtlasNode = [CCSpriteBatchNode batchNodeWithFile:@"buildingatlas.png"];
        [self addChild:buildingAtlasNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buildingatlas.plist"];

        NSMutableArray *buildingFrames = [NSMutableArray array];
        NSMutableArray *buildingFilenames = [NSMutableArray array];
        for (int ii = 1; ii <= 3; ii++) {
            NSString *file = [NSString stringWithFormat:@"buildingpiece-%d-off.png", ii];
            
            [buildingFilenames addObject:file];
            numberBuildingFrames++;
            file = [NSString stringWithFormat:@"buildingpiece-%d.png", ii];
            
            [buildingFilenames addObject:file];
            numberBuildingFrames++;

        }
        
        for (int i = 0; i < numberBuildingFrames; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:buildingFilenames[i]];
            [buildingFrames addObject:frame];
        }

		
#if 1
		// Use batch node. Faster
		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
		spriteTexture_ = [parent texture];
#else
		// doesn't use batch node. Slower
		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
		CCNode *parent = [CCNode node];
#endif
		[self addChild:parent z:0 tag:kTagParentNode];
        
        
        
		[self scheduleUpdate];
	}
	return self;
}


-(void) dealloc
{
	delete world;
	world = NULL;
	    
	delete m_debugDraw;
	m_debugDraw = NULL;
	
    
    
	[super dealloc];
}	

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
//	// Reset Button
//	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
//		[[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
//	}];

	// to avoid a retain-cycle with the menuitem and blocks
	__block id copy_self = self;

//	// Achievement Menu Item using blocks
//	CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
//		
//		
//		GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
//		achivementViewController.achievementDelegate = copy_self;
//		
//		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//		
//		[[app navController] presentModalViewController:achivementViewController animated:YES];
//		
//		[achivementViewController release];
//	}];
	
	// Leaderboard Menu Item using blocks
//	CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
//		
//		
//		GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
//		leaderboardViewController.leaderboardDelegate = copy_self;
//		
//		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//		
//		[[app navController] presentModalViewController:leaderboardViewController animated:YES];
//		
//		[leaderboardViewController release];
//	}];
    
     
    CCMenuItemSprite* itemNewGame = [uiLayer makeButtonWithText:@"KILL THEM ALL" ShapeID:1 x:500 y:500];
    itemNewGame.tag = 1;
    [itemNewGame setTarget:self selector:@selector(newGame:)];
    
    CCMenuItemSprite* itemLevelSelect = [uiLayer makeButtonWithText:@"MISSIONS" ShapeID:1 x:0 y:0];
    [itemLevelSelect setTarget:self selector: @selector(levelSelect:)];
    
    CCMenuItemSprite* itemSettings = [uiLayer makeButtonWithText:@"SETTINGS" ShapeID:1 x:0 y:0];
    [itemSettings setTarget:self selector: @selector(settings)];
    
	CCMenu *menu = [CCMenu menuWithItems: itemNewGame, itemLevelSelect,itemSettings, nil];
	[menu alignItemsVertically];
	[menu setPosition:ccp( size.width/2, size.height/2-30)];
	    
    //background elements
    
    CCSprite* cosmos = [CCSprite spriteWithFile:@"cosmos.png"];
    cosmos.position = ccp(size.width/2, size.height/2);
    
    CCSprite* titleFace = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"titletypeface.png"]];
    titleFace.position = ccp( size.width/2, size.height-50);
    
    CCSprite* dashboard = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dash_mainmenu.png"]];
	[dashboard setPosition:ccp(size.width/2, 150)];
    
//    CCMenuItem* testButton = [uiLayer addButtonWithText:@"TEST" ShapeID:3 x:size.width/2 y:size.height/2];
//    
    
    
    
    [self addChild: cosmos z:-4];
    [self addChild: dashboard z:-3];
//    [self addChild:titleFace z:-3];
    [uiLayer addChild:titleFace];
    [uiLayer addChild: menu];
    
}

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
}

-(void) addNewSpriteAtPosition:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
	

	CCNode *parent = [self getChildByTag:kTagParentNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[parent addChild:sprite];
	
	[sprite setPTMRatio:PTM_RATIO];
	[sprite setB2Body:body];
	[sprite setPosition: ccp( p.x, p.y)];

}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);	
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
//		[self addNewSpriteAtPosition: location];
	}
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void)toggleSound:(id)sender {
    if([sender tag]==1){//YES
        [sender setTag:2];
        NSLog(@"Sound: OFF");
//        [sender setString:@"Sound: OFF"];
        
    }else{//NO
        [sender setTag:1];
                NSLog(@"Sound: ON");
//        [sender setString:@"Sound: ON"];
    }
}

-(void)toggleMusic:(id)sender {
    if([sender tag]==1){//YES
        [sender setTag:2];
                NSLog(@"Music: OFF");
//        [sender setString:@"Music: OFF"];
    }else{//NO
        [sender setTag:1];
                        NSLog(@"Music: ON");
//        [sender setString:@"Music: ON"];
    }
}
                        
-(void) newGame:(id)sender  {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameplayScene nodeWithGameLevel:[sender tag]]]];
}
-(void)settings{
    NSLog(@"choses settings");
    
    NSMutableArray *settingButtons = [[NSMutableArray alloc] init];
    
  
    CCMenuItemSprite* ccSound =[uiLayer makeButtonWithText:[NSString stringWithFormat:@"Sound: ON"] ShapeID:1 x:0 y:0];
    ccSound.tag = 1;
    [ccSound setTarget:self selector:@selector(toggleSound:)];
    [ccSound setScale:0.8];
    CCMenuItemSprite* ccMusic =[uiLayer makeButtonWithText:[NSString stringWithFormat:@"Music: ON"] ShapeID:1 x:0 y:0];
    ccMusic.tag = 1;
    [ccMusic setTarget:self selector:@selector(toggleMusic:)];
    [ccMusic setScale:0.8];
 
    [settingButtons addObject:ccSound];
    [settingButtons addObject:ccMusic];
    
    CCLabelTTF *settingsTitle = [[CCLabelTTF labelWithString:@"Settings" fontName:@"Arial" fontSize:30.0] retain];
    settingsTitle.position = ccp(size.width/2-20,size.height-70);
    
    CCMenu *settingsMenu = [CCMenu menuWithArray:settingButtons];
    settingsMenu.position = ccp(size.width/2-20, size.height/2-20);
    
    [settingsMenu alignItemsVertically];
	
    settingPane = [CCSprite spriteWithFile:@"levelselectpanel.png"];
    settingPane.position = ccp(size.width/2, size.height/2);
    
    CCMenuItemSprite* closeButton = [uiLayer makeButtonWithText:@"x" ShapeID:3 x:40 y:size.height - 70];
    CCMenu* closeMenu = [CCMenu menuWithItems:closeButton, nil];
    closeMenu.position = ccp(0, 0);
    [closeButton setTarget:self selector:@selector(removeSettingPane)];
    
    [settingPane addChild:settingsMenu];
    [settingPane addChild:closeMenu];
    [settingPane addChild:settingsTitle];
    [uiLayer addChild:settingPane ];
}

-(void) levelSelect:(id)sender {
    int buttonNum = 9;
    int activeLevels = 4;
    id clearFunct;
    NSMutableArray *levelButtons = [[NSMutableArray alloc] init];
    
    for (int ii = 1; ii<=buttonNum; ii++) {
        [levelButtons addObject:[uiLayer makeButtonWithText:[NSString stringWithFormat:@"%d",ii] ShapeID:1 x:0 y:0]];
        CCMenuItemSprite* ccMS = [levelButtons objectAtIndex:(ii-1)];
        //decides level
        ccMS.tag = ii;
        [ccMS setTarget:self selector:@selector(newGame:)];
        [ccMS setScale:0.8];
//        if (ii > activeLevels) {
//            [ccMS setVisible:NO];
//        }
        
    }
    
    CCLabelTTF *missionTitle = [[CCLabelTTF labelWithString:@"Choose Your Mission" fontName:@"Arial" fontSize:30.0] retain];
    missionTitle.position = ccp(size.width/2-20,size.height-70);
    
    CCMenu *mishMenu = [CCMenu menuWithArray:levelButtons];
    mishMenu.position = ccp(size.width/2-20, size.height/2-20);
    
    NSNumber* itemsPerRow = [NSNumber numberWithInt:3];
    [mishMenu alignItemsInColumns:itemsPerRow, itemsPerRow, itemsPerRow, nil];
	
    mishPane = [CCSprite spriteWithFile:@"levelselectpanel-14.png"];
    mishPane.position = ccp(size.width/2, size.height/2);
    
    CCMenuItemSprite* closeButton = [uiLayer makeButtonWithText:@"x" ShapeID:3 x:40 y:size.height - 70];
    CCMenu* closeMenu = [CCMenu menuWithItems:closeButton, nil];
    closeMenu.position = ccp(0, 0);
    [closeButton setTarget:self selector:@selector(removeMissionPane)];
    
    [mishPane addChild:mishMenu];
    [mishPane addChild:closeMenu];
    [mishPane addChild:missionTitle];
    [uiLayer addChild:mishPane ];
    
}

-(void) removeMissionPane {
    [uiLayer removeChild:mishPane];
}

-(void) removeSettingPane {
    [uiLayer removeChild:settingPane];
}

@end
