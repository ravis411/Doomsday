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
#import "PlayerWeapon.h"
#include "CCTouchDelegateProtocol.h"
#import "GameoverScene.h"
#import "SimpleAudioEngine.h"
#import "PauseLayer.h"
//#import "GameOverLayer.h"


@interface GameplayScene : CCScene {
    int _timeRemaining;
    bool _firstBlood;
    int _quota;
    int _killCount;
    int missionLevel;
    Boolean _timerOn;
    Boolean _paused;
    enum playerWeapon weaponMode;
    SpriteLayer *spriteLayer;
    UILayer *uiLayer;
    BackgroundLayer *bgLayer;
    CCParallaxNode *background;
    BOOL soundOn;
    BOOL musicOn;
    NSString *TopScores;
    BOOL _levelOverBecausePlayerDied;
    
    
//    Ship *_ship;
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
    CGSize winSize;
    PauseLayer *pauseLayer;
    NSMutableArray *m_topScores;
}
+(id)nodeWithGameLevel:(int)level sound:(BOOL)s music:(BOOL)m;


-(void) laserButtonTapped:(id)sender;
-(void) gadgetButtonRTapped:(id)sender;
-(void) gadgetButtonLTapped:(id)sender;
-(void)pauseTapped:(id)sender;
-(void) pauseGame;
-(void) resumeGame;
-(void) endGame;
-(void) save;
-(void) buildUI;
+(void) turnOffMusic;
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
