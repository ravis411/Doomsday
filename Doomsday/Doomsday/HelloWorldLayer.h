//
//  HelloWorldLayer.h
//  Doomsday
//
//  Created by Andrew Han on 3/24/14.
//  Copyright TeamDoomsday 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "UILayer.h"
#import "InstructionsLayer.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    CCSpriteBatchNode *uiAtlasNode;
    CCSpriteBatchNode *spriteAtlasNode;
    CCSpriteBatchNode *buildingAtlasNode;
    UILayer *uiLayer;
    UILayer *levelSelectLayer;
    CGSize size;
    CCScene *menuScene;
    CCSprite* mishPane;
    CCSprite* settingPane;
    CCMenuItemSprite* ccMusic;
    CCMenuItemSprite* ccSound;
    BOOL soundOn;
    BOOL musicOn;
}

@property UILayer* uiL;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene:(BOOL)s music:(BOOL)m;
+(id)nodeWithSound:(BOOL)s music:(BOOL)m;
-(void) createMenu;
-(void) newGame:(id)sender;
-(void) levelSelect:(id)sender;
-(void) setSound:(BOOL)s;
-(void) setMusic:(BOOL)m;

@end
