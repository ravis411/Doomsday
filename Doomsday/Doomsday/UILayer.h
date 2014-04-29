//
//  UILayer.h
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "CCLayer.h"
#import "AppDelegate.h"
#import "PlayerWeapon.h"
#import "cocos2d.h"

@interface UILayer : CCLayer
{
    
//    CCLabelTTF *m_LevelLabel;
//    CCLabelTTF *m_LifeLabel;
//    CCLabelTTF *m_WeaponLabel;
//    CCLabelTTF *m_GameOverLabel;
//    CCLabelTTF *m_EnemyKilledLabel;
    CCLabelTTF *m_TotalScore;

//    NSMutableArray *heartCount;
    CGSize size;
//    CCSpriteBatchNode *uiAtlasNode;
//    CCSprite* _dash;
//    CCLabelTTF *_label;
    CCLabelTTF *_healthLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_timeLabel;
    CCLabelTTF *_missionLabel;
//    CCSprite* _killCounter;
    int _quota;
    int _killCount;
    int _remainingTime;
    enum playerWeapon _displayWeapon;
    int missionLevel;
}

@property int quota;
@property int killed;
@property int timeLeft;

//-(void) showGameOverLabel;
//-(void) pauseTapped;
+(id)nodeWithGameLevel:(int)level;
-(void) updateKillCounter;
-(void) updateTimer:(int)newTime;
-(void) updateHealth:(int)health;
-(void) displayScoreLabel;
-(void) displayTimer;
-(void) displayMissionLevel;
-(void)displayHealthLabel;
-(void) addUIElement:(CCSprite*)element withFrame:(NSString*)elemFile x:(int)mX y:(int)mY;
-(void) setMenuItem:(CCMenuItem*)element buttonID:(int)bID x:(int)mX y:(int)mY;
-(CCMenuItem*) buildButtonWithShapeID:(int)sID x:(int)mX y:(int)mY;
-(CCMenuItemSprite*) makeButtonWithText:(NSString*)bText ShapeID:(int)sID x:(int)mX y:(int)mY;
-(void) addText:(NSString*)mText toButton:(CCMenuItem*)mButton;
-(void) nullSelector;
-(void) update:(ccTime)dt level:(int) currentLevel lives:(int)currentLives killed:(int)currentKilled score:(double)s;
-(int) ticksToSchmeckonds:(int)ticks;

@end
