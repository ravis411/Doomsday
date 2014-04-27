//
//  GameoverScene.m
//  Doomsday
//
//  Created by Kyle on 4/22/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "GameoverScene.h"

NSString *const LeaderboardPlist = @"leaderboard.plist";
NSString *const TopScores = @"TopScores";

@interface GameoverScene()

@property (strong, nonatomic) NSString *filepath;
@property (strong, nonatomic) NSMutableDictionary *plist;

@end

@implementation GameoverScene

-(id) gameOverWithScore:(int)killcount outOf:(int)quota currentLevel:(int)currentLevel {
    self  = [super init];
    if(self)
	{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        killCount = killcount;
        gameQuota = quota;
        level = currentLevel;
        //Accessing plist
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        _filepath = [documentsDirectory stringByAppendingPathComponent:LeaderboardPlist];
//        _plist = [NSMutableDictionary dictionaryWithContentsOfFile:_filepath];
        
        uiLayer = [UILayer node];
        [self addChild:uiLayer];
        size = [[CCDirector sharedDirector] winSize];
        CCLayerColor* layerColorBlack = [CCLayerColor layerWithColor:ccc4(225,225,225, 0)];
        [self addChild: layerColorBlack];
        
        NSString *vicfail = @"failure";
        if (killcount >= quota) {vicfail = @"victory";}
        CCSprite* vfMSG = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_message.png", vicfail]]];
        vfMSG.position = ccp(size.width/2, size.height/2 + 96);
        
        NSMutableArray *topScores = [defaults objectForKey:TopScores];

        for(NSNumber *score in topScores){
            NSLog(@"AFTER userdefaults: \n\n%@\n\n",score);
        }
        
        CCLabelTTF *topScoresLabel = [CCLabelTTF
                                 labelWithString:@"Top Scores:"
                                 fontName:@"Futura-Medium"
                                 fontSize:20];
        topScoresLabel.position = ccp(size.width/2, size.height/2+10);
        [uiLayer addChild:topScoresLabel];

        
        CCLabelTTF *topscore1 = [CCLabelTTF
                                 labelWithString:[NSString stringWithFormat:@"%@",[topScores objectAtIndex:0]]
                             fontName:@"Futura-Medium"
                             fontSize:20];
        topscore1.position = ccp(size.width/2, size.height/2-15);
        [uiLayer addChild:topscore1];

        
        if (topScores.count>1) {
            CCLabelTTF *topscore2 = [CCLabelTTF
                                     labelWithString:[NSString stringWithFormat:@"%@",[topScores objectAtIndex:1]]
                                     fontName:@"Futura-Medium"
                                     fontSize:20];
            topscore2.position = ccp(size.width/2, size.height/2-35);
            [uiLayer addChild:topscore2];
        }
        
        if (topScores.count>2) {
            CCLabelTTF *topscore3 = [CCLabelTTF
                                     labelWithString:[NSString stringWithFormat:@"%@",[topScores objectAtIndex:2]]
                                     fontName:@"Futura-Medium"
                                     fontSize:20];
            topscore3.position = ccp(size.width/2, size.height/2-55);
            [uiLayer addChild:topscore3];
        }
        
        CCLabelTTF *score = [CCLabelTTF
                             labelWithString:[NSString stringWithFormat:@"KILLS: %d/%d", killcount, quota]
                             fontName:@"Futura-Medium"
                             fontSize:30];
        score.position = ccp(size.width/2, size.height/2 + 48);
        
        
        CCMenuItemSprite* restartButton = [uiLayer makeButtonWithText:@"TRY AGAIN" ShapeID:1 x:0 y:0];
        [restartButton setTarget:self selector:@selector(retry)];
        
        
        CCMenuItemSprite* returnButton = [uiLayer makeButtonWithText:@"MAIN MENU" ShapeID:1 x:0 y:0];
        [returnButton setTarget:self selector:@selector(returnToMain)];
        CCMenu *menu;
        if(killcount>=quota){
            CCMenuItemSprite* continueButton = [uiLayer makeButtonWithText:@"CONTINUE" ShapeID:1 x:0 y:0];
            [continueButton setTarget:self selector:@selector(continueMission)];
             menu = [CCMenu menuWithItems: restartButton,continueButton, returnButton, nil];
        }
        else{
             menu = [CCMenu menuWithItems: restartButton, returnButton, nil];
        }
        
        
        
        [uiLayer addChild: menu];
	    
        [menu alignItemsHorizontally];
        [menu setPosition:ccp( size.width/2, size.height/2 - 100)];
        
        
        [uiLayer addChild:vfMSG];
        [uiLayer addChild:score];
        
        
  
        //[self scheduleUpdate];//Why do we need to schedule update here?

    }
    
    return self;
}
-(void)continueMission{
    NSLog(@"Continue Game");
    level++;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[GameplayScene nodeWithGameLevel:level]]];
}

-(void) retry {
    NSLog(@"Restart Game");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[GameplayScene nodeWithGameLevel:level]]];
}
-(void) returnToMain{
    NSLog(@"Return to main");
//    CCScene* mMS = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer scene]]];
}

@end
