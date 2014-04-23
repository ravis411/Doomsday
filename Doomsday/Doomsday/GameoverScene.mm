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
        
        [uiLayer addChild:vfMSG];
        [uiLayer addChild:score];
  
        [self scheduleUpdate];

    }
    
    return self;
}

-(void) retry {}
-(void) returnToMain{}

@end
