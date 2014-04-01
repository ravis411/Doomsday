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
//#import "GameOverLayer.h"


@interface GameplayScene : CCScene {
    
    SpriteLayer *spriteLayer;
    UILayer *uiLayer;
    BackgroundLayer *bgLayer;
    
    CCLabelTTF *exitLabel;
    CGSize winSize;
//    int m_Level;
//    int m_Lives;
//    int m_WeaponLevel;
//    int m_Score;
//    int m_GamesPlayed;
    //    int m_DeadObstacles;
    //    GroundLayer *groundLayer;
    //    IntroLayer *introLayer;
 //   ALuint soundEffectID;
    
}

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
