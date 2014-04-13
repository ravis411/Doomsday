//
//  GameplayScene.h
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "CCScene.h"
#import "UILayer.h"
#import "SpriteLayer.h"
#import "BackgroundLayer.h"
#include "CCTouchDelegateProtocol.h"
//#import "GameOverLayer.h"


@interface GameplayScene : CCScene {
    
   enum playerWeapon {
        PLAYER_OFF,
        PLAYER_PLAYING,
        PLAYER_PAUSED
    };
    
//    enum {
//        WEAPON_LASER,
//        WEAPON_GADGET1,
//        WEAPON_GADGET2
//    };
//    
//    typedef NSInteger WeaponType;
    enum playerWeapon weaponMode;
    SpriteLayer *spriteLayer;
    UILayer *uiLayer;
    BackgroundLayer *bgLayer;
    CCParallaxNode *background;
    Ship *_ship;
//    int m_Level;
//    int m_Lives;
//    int m_WeaponLevel;
//    int m_Score;
//    int m_GamesPlayed;
    //    int m_DeadObstacles;
    //    GroundLayer *groundLayer;
    //    IntroLayer *introLayer;
 //   ALuint soundEffectID;
    
    //gameplay UI
    CCLabelTTF *_label;

    
}

-(void) buildUI;
-(void) laserButtonTapped:(id)sender;

//-(void) moveScreenLeft;
//-(void) moveScreenRight;
//@property int level;
//@property int lives;
//@property int weaponLevel;
//@property int deadObstacles;
//@property int score;
//@property int gamesPlayed;

//-(void) startGameOver;
//-(void) update:(ccTime)dt;
//-(void) exitScene;

@end
