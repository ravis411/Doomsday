//
//  GameoverScene.m
//  Doomsday
//
//  Created by Kyle on 4/22/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "GameoverScene.h"

@implementation GameoverScene

-(id) gameOverWithScore:(int)killcount outOf:(int)quota {
    self  = [super init];
    if(self)
	{
        uiLayer = [UILayer node];
        [self addChild:uiLayer];
        size = [[CCDirector sharedDirector] winSize];
        CCLayerColor* layerColorBlack = [CCLayerColor layerWithColor:ccc4(225,225,225, 0)];
        [self addChild: layerColorBlack];
        
        NSString *vicfail = @"failure";
        if (killcount >= quota) {vicfail = @"victory";}
        CCSprite* vfMSG = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_message.png", vicfail]]];
        vfMSG.position = ccp(size.width/2, size.height/2 + 96);
        
        CCLabelTTF *score = [CCLabelTTF
                             labelWithString:[NSString stringWithFormat:@"KILLS: %d/%d", killcount, quota]
                             fontName:@"Futura-Medium"
                             fontSize:30];
        score.position = ccp(size.width/2, size.height/2 + 48);
        
        
        CCMenuItemSprite* restartButton = [uiLayer makeButtonWithText:@"TRY AGAIN" ShapeID:1 x:0 y:0];
        [restartButton setTarget:self selector:@selector(retry)];
        
        CCMenuItemSprite* returnButton = [uiLayer makeButtonWithText:@"MAIN MENU" ShapeID:1 x:0 y:0];
        [returnButton setTarget:self selector:@selector(returnToMain)];
        
        
        CCMenu *menu = [CCMenu menuWithItems: restartButton, returnButton, nil];
        
        [uiLayer addChild: menu];
	    
        [menu alignItemsVertically];
        [menu setPosition:ccp( size.width/2, size.height/2 - 50)];
        
        
        [uiLayer addChild:vfMSG];
        [uiLayer addChild:score];
        
  
        [self scheduleUpdate];

    }
    
    return self;
}

-(void) retry {
    NSLog(@"New Game");
    [[CCDirector sharedDirector]
        replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[GameplayScene node]]];
}
-(void) returnToMain{
    NSLog(@"Return to main");
//    CCScene* mMS = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer scene]]];
}

@end
