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

@interface GameoverScene : CCScene {
    UILayer* uiLayer;
    CGSize size;
}


-(id) gameOverWithScore:(int)killcount outOf:(int)quota;
-(void) retry;
-(void) returnToMain;

@end
