//
//  PauseLayer.h
//  Doomsday
//
//  Created by Student on 4/26/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "CCLayer.h"
#import "CCMenu.h"
#import "UILayer.h"
@class GameplayScene;

@interface PauseLayer : CCLayer{
    UILayer *menu;
    GameplayScene* _gameplayScene;
}
@property GameplayScene* gameplayScene;

-(id)init;
-(void) endGame;
-(void) resumeGame;

@end
