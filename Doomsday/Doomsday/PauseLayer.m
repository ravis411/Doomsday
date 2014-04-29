//
//  PauseLayer.m
//  Doomsday
//
//  Created by Student on 4/26/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "PauseLayer.h"

@implementation PauseLayer


@synthesize gameplayScene = _gameplayScene;


- (id)init{
    self = [super init];
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCLayerColor* layercolorHalftransparentgray = [CCLayerColor layerWithColor:ccc4(69,69,69, 200)];
        [self addChild: layercolorHalftransparentgray];
        
        menu = [UILayer node];
        [self addChild:menu];
        
        CCLabelTTF* pauseLabel = [[CCLabelTTF labelWithString:@"PAUSED" fontName:@"Arial" fontSize:30] retain];
        pauseLabel.position = ccp(size.width/2, size.height - 50);
        [self addChild:pauseLabel];

        
        
        //A button to resume the game.
        CCMenuItemSprite* resumeButton = [menu makeButtonWithText:@"RESUME" ShapeID:1 x:0 y:0];
        [resumeButton setTarget:self selector:@selector(resumeGame)];
        
        //A button to exit the game when paused.
        CCMenuItemSprite* quitButton = [menu makeButtonWithText:@"EXIT GAME" ShapeID:1 x:0 y:0];
        [quitButton setTarget:self selector:@selector(endGame)];
        [quitButton setColor:ccRED];

        //A button to resume the game.
        CCMenuItemSprite* instructs = [menu makeButtonWithText:@"HELP" ShapeID:1 x:0 y:0];
        [instructs setTarget:self selector:@selector(showInstructions)];

        
        
        CCMenu *menuuu = [CCMenu menuWithItems: resumeButton, quitButton, instructs, nil];
        
        [menu addChild: menuuu];
	    
        [menuuu alignItemsVertically];
        [menuuu setPosition:ccp( size.width/2, size.height/2)];
        
        [self setTouchEnabled:YES];
        [self setTouchSwallow:YES];
    }
    return self;
}

-(void)showInstructions{
    InstructionsLayer * instructions = [InstructionsLayer node];
    [self addChild:instructions z:50];
}

-(void)endGame{
    [_gameplayScene endGameFromPause];
}

-(void)resumeGame{
    [_gameplayScene pauseTapped:NULL];
}

@end
