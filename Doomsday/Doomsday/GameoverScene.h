//
//  GameoverScene.h
//  Doomsday
//
//  Created by Kyle on 4/22/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"
#import "UILayer.h"
#import "GameplayScene.h"
#import "HelloWorldLayer.h"


@interface GameoverScene : CCScene {
    UILayer* uiLayer;
    CGSize size;
    int killCount;
    int gameQuota;
    int level;
}


-(id) gameOverWithScore:(int)killcount outOf:(int)quota currentLevel:(int)currentLevel;
-(void) continueMission;
-(void) retry;
-(void) returnToMain;

@end
