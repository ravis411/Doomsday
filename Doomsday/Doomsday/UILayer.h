//
//  UILayer.h
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "CCLayer.h"
#import "AppDelegate.h"
#import "cocos2d.h"

@interface UILayer : CCLayer
{
//    CCLabelTTF *m_LevelLabel;
//    CCLabelTTF *m_LifeLabel;
//    CCLabelTTF *m_WeaponLabel;
//    CCLabelTTF *m_GameOverLabel;
//    CCLabelTTF *m_EnemyKilledLabel;
//    CCLabelTTF *m_TotalScore;
//    NSMutableArray *heartCount;
    CGSize size;
    CCSprite* _dash;
    CCLabelTTF *_label;

}


-(void) showGameOverLabel;
-(void) mainGameplayMode;



-(void) update:(ccTime)dt level:(int) currentLevel lives:(int)currentLives killed:(int)currentKilled score:(double)s;
@end
