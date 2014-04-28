//
//  GameplayScene.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//
// Background track "The Ballad of Jack Noir" is available at http://homestuck.bandcamp.com/album/midnight-crew-drawing-dead-2
//


#import "GameplayScene.h"


NSString *const LeaderboardPlist = @"leaderboard.plist";
NSString *const TopScores = @"TopScores";

@interface GameplayScene()

@property (strong, nonatomic) NSString *filepath;
@property (strong,nonatomic) NSMutableDictionary *plist;

@end

@implementation GameplayScene
bool musicPlaying = false;

+(id)nodeWithGameLevel:(int)level sound:(BOOL)s music:(BOOL)m{

    return  [[[self alloc] initWithLevel:level sound:s music:m] autorelease];
}

-(id)initWithLevel:(int)level sound:(BOOL)s music:(BOOL)m
{
    
    if(self = [super init])
	{
        missionLevel = level;
        soundOn = s;
        musicOn = m;
        spriteLayer = [SpriteLayer nodeWithGameLevel:missionLevel sound:s music:m];
        uiLayer = [UILayer nodeWithGameLevel:missionLevel];
        bgLayer = [BackgroundLayer node];
        pauseLayer = [PauseLayer node];
        pauseLayer.gameplayScene = self;
        background = [CCParallaxNode node];
        _paused = false;
        _firstBlood = false;
        
        winSize = [[CCDirector sharedDirector] winSize];

        
        if (!musicPlaying && musicOn) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"The Ballad of Jack Noir.mp3" loop:YES];
            musicPlaying = TRUE;
        }
        
        
        //Set up pause layer
        [pauseLayer setVisible:NO];
        [self addChild:pauseLayer z:40];
        
        
        
        
//        _ship = [Ship sharedModel];
        
        weaponMode = WEAPON_BASIC;
        _quota = 10*missionLevel;
        
//        [self addChild:pauseLayer];
        
        [self buildUI];
        [self setTimer:400];
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        _filepath = [documentsDirectory stringByAppendingPathComponent:LeaderboardPlist];
//        _plist = [NSMutableDictionary dictionaryWithContentsOfFile:_filepath];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([defaults objectForKey:TopScores]){
            m_topScores = [defaults objectForKey:TopScores];
        }
        else{
            m_topScores = [[NSMutableArray alloc] init];
        }
    
    
    
        
    CGPoint backgroundLayerSpeed = ccp(0.05, 0.05);
    CGPoint spriteLayerSpeed = ccp(0.1, 0.1);
    
    [background addChild:bgLayer z:-1 parallaxRatio:backgroundLayerSpeed positionOffset:ccp(0,0)];
    [background addChild:spriteLayer z:0 parallaxRatio:spriteLayerSpeed positionOffset:ccp(0,0)];
    
//    [self addChild:_ship z:1];
    //[self addChild:spriteLayer z:1];
    [self addChild:uiLayer z:4];
    //[self addChild:bgLayer z:0];
    [self addChild:background z:-1];
    //[self addChild:[spriteLayer hoipolloiSprite] z:3];
    
    [self scheduleUpdate];
    
    }
    return self;
    
}


-(void) buildUI{
    CGSize size = [[CCDirector sharedDirector] winSize];
//    [self laserButtonTapped:self];
    CCSprite* _dash;
    CCLabelTTF *_scoreLabel = [[CCLabelTTF labelWithString:@"-/-" fontName:@"Futura-Medium" fontSize:24.0] retain];
    CCSprite* _killCounter;
    CCLabelTTF* _timeLabel = [[CCLabelTTF labelWithString:@"000" fontName:@"Futura-Medium" fontSize:18] retain];
    //CCSprite* pause = null;
    uiLayer.quota = _quota;
    
    _dash = [CCSprite spriteWithFile:@"dashboard.png"];
   
    _dash.position = CGPointMake(size.width/2, _dash.contentSize.height/2);
    [self addChild:_dash];
    
    [uiLayer displayMissionLevel];
    
    //testinglabel
    _label = [[CCLabelTTF labelWithString:@" " fontName:@"Futura-Medium" fontSize:24.0] retain];
    
    
    
    CCSprite* weaponModePanel = [CCSprite spriteWithFile:@"activeweaponbar.png"];
    [weaponModePanel setScale:0.4];
    weaponModePanel.position = ccp(size.width/2 - 120, 24);
    _label.position = ccp(weaponModePanel.contentSize.width/2, weaponModePanel.contentSize.height/2);

    [weaponModePanel addChild:_label];
    [_dash addChild:weaponModePanel];

    
    //killcounter
    [uiLayer addUIElement:_killCounter withFrame:@"killcounter.png" x:(size.width-115) y:(size.height-18)];
    [uiLayer displayScoreLabel];
    
    NSString* placeHolderSprite = @"button_round_unlit.png";
    
    //pause the game
    CCMenuItem *pause = [CCMenuItemFont itemWithString:@" || " target:self selector:@selector(pauseTapped:)];
    [pause setScale:2.0];
    pause.position = ccp(30, size.height- 30);

    
    CCMenuItem *laserButton = [CCMenuItemImage
                               itemFromNormalImage:placeHolderSprite selectedImage:placeHolderSprite
                               target:self selector:@selector(laserButtonTapped:)];
    [uiLayer setMenuItem:laserButton buttonID:3 x:size.width/2 y:30];
    
    CCMenuItem *gadgetButtonR = [CCMenuItemImage
                                 itemFromNormalImage:placeHolderSprite selectedImage:placeHolderSprite
                                 target:self selector:@selector(gadgetButtonRTapped:)];
    [uiLayer setMenuItem:gadgetButtonR buttonID:5 x:(size.width/2 + 50) y:30];
    
    CCMenuItem *gadgetButtonL = [CCMenuItemImage
                                 itemFromNormalImage:placeHolderSprite selectedImage:placeHolderSprite
                                 target:self selector:@selector(gadgetButtonLTapped:)];
    [uiLayer setMenuItem:gadgetButtonL buttonID:4 x:(size.width/2 - 50) y:30];
    
       
    CCMenu *gadgetButtons = [CCMenu menuWithItems: laserButton, gadgetButtonL, gadgetButtonR, pause, nil]; //gadget button R is currently inactive
    gadgetButtons.position = CGPointZero;
    [uiLayer addChild:gadgetButtons];
    
    [uiLayer updateKillCounter];
    
    //TIMER UI
    [uiLayer displayTimer];
    
    
    
    
}

//Button actions

-(void)laserButtonTapped:(id)sender {
    weaponMode = WEAPON_BASIC;
     [_label setString:@"LASER MODE"];
    
}
- (void)gadgetButtonRTapped:(id)sender {
    weaponMode = WEAPON_GADGET2;
    [_label setString:@"GADGET 2"];
}

- (void)gadgetButtonLTapped:(id)sender {
    weaponMode = WEAPON_GADGET1;
    [_label setString:@"GADGET 1"];

}

-(void) updateUILayer {
    NSString* weaponLabelString;
    switch(weaponMode) {
        case WEAPON_BASIC:
            weaponLabelString =@"LASER";
            break;
        case WEAPON_GADGET1:
            weaponLabelString = @"BOMB";
            break;
        case WEAPON_GADGET2:
            weaponLabelString = @"GADGET 2";
            break;
    }
    [_label setString:[NSString stringWithFormat:@"%@", weaponLabelString]];
    uiLayer.killed = [spriteLayer enemiesKilled];
    [uiLayer updateKillCounter];
    [uiLayer updateTimer:_timeRemaining];
    
}

-(void) setTimer:(int)mT {
    _timeRemaining = mT;
    _timerOn = true;
}

- (void)pauseTapped:(id)sender {
//    [_label setString:@"PAUSE"];
    //    [HelloWorldLayer alloc];
    
    
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer scene]]];
    if (!_paused){
        [self pauseGame];
    }
    else {
        [self resumeGame];
    }
    _paused = !_paused;

}

-(void) pauseGame {
    [pauseLayer setVisible:YES];
   // [spriteLayer setIsTouchEnabled:NO];
    [spriteLayer setTouchEnabled:NO];
    //[uiLayer setIsTouchEnabled:NO];
}

-(void) resumeGame {
    //[spriteLayer setIsTouchEnabled:YES];
    [spriteLayer setTouchEnabled:YES];
   // [uiLayer setIsTouchEnabled:YES];
    [pauseLayer setVisible:NO];
}

-(void) endGame {
    
        if(_killCount>10*missionLevel){
            NSLog(@"YOU WIN");
        }
        else{
            NSLog(@"YOU LOSE........");
        }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *ns_KillCount = [NSNumber numberWithInt:_killCount];
    
    m_topScores = [defaults objectForKey:TopScores];
    
    m_topScores = [NSMutableArray arrayWithArray:m_topScores];
    
    if (m_topScores.count < 3) {
        [m_topScores addObject:ns_KillCount];
    }
    else{
        
        
        if ([[m_topScores objectAtIndex:2] doubleValue] < [ns_KillCount doubleValue]) {
            NSLog(@"\n\n\nObject at index 2: %@ \n Current Kill Count: %@", [m_topScores objectAtIndex:2], ns_KillCount);
            [m_topScores removeObjectAtIndex:2];
            [m_topScores addObject:ns_KillCount];
            
        }
    }
    
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [m_topScores sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    NSMutableArray *mutableTopScoresCopy = [NSMutableArray arrayWithArray:m_topScores];
    
    for(NSNumber *score in mutableTopScoresCopy){
        NSLog(@"Before userdefaults: \n\n%@\n\n",score);
    }
    [defaults setObject:mutableTopScoresCopy forKey:TopScores];
    [defaults synchronize];
    
//    for( NSString *score in [defaults objectForKey:TopScores]){
//        NSLog(@"\n\n\n%@\n\n\n",score);
//    }
    
    
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:
                                               [[[GameoverScene alloc] gameOverWithScore:_killCount outOf:_quota currentLevel:missionLevel sound:soundOn music:musicOn]autorelease]]];
}

-(void)update:(ccTime)dt{
    
    //Paused so don't update anything.
    if (_paused) {
        return;
    }
    
    [spriteLayer update:dt];
   
       
    //    if (([spriteLayer movingRight] == YES) && background.position.x >= -14795) {
    if (([spriteLayer movingRight] == YES) && background.position.x >= -8000) {
        //        NSLog(@"\n\n\n%f\n\n\n",background.position.x);
        CGPoint backgroundScrollVel = ccp(-3000, 0);
        background.position = ccpAdd(background.position, ccpMult(backgroundScrollVel, dt));
    }
    
    //    if (([spriteLayer movingLeft] == YES) && background.position.x <= 14795) {
    if (([spriteLayer movingLeft] == YES) && background.position.x <= 8000) {
        //        NSLog(@"\n\n\n%f\n\n\n",background.position.x);
        CGPoint backgroundScrollVel = ccp(-3000, 0);
        background.position = ccpSub(background.position, ccpMult(backgroundScrollVel, dt));
    }
    [self updateUILayer];
    [spriteLayer setWeaponMode:weaponMode];
    
     _killCount = [spriteLayer enemiesKilled];
//    if([spriteLayer gameOver]){
//        if(_killCount>10*missionLevel){
//            NSLog(@"YOU WIN");
//        }
//        else{
//            NSLog(@"You lose.....");
//        }
//    }
//    if([spriteLayer gameOver]){
//        CCLabelTTF* winMessage = [[CCLabelTTF labelWithString:@"WIN!" fontName:@"Arial" fontSize:30] retain];
//        winMessage.position = ccp(winSize.width/2, winSize.height/2);
//        [uiLayer addChild:winMessage];
//        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer node]]];
//    }
    
    
    if (_timerOn) {
        _timeRemaining -= 1;
        if (_timeRemaining < 0) {
            //user fails level
            _timerOn = false;
            [self endGame];
//            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer node]]];
        }
    }
    
    if ([spriteLayer playerDead] == YES) {
        [self endGame];
    }

}

+(void)turnOffMusic{
    musicPlaying = NO;
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

//-(void) save{
//    NSString *strKillCount = [NSString stringWithFormat:@"%d",_killCount];
//    
//    
//    
//    m_topScores = [_plist objectForKey:TopScores];
//    [m_topScores addObject:strKillCount];
//    
//    
//    
//    [self.plist setObject:m_topScores forKey:TopScores];
//    [self.plist writeToFile:self.filepath atomically:YES];
//}



@end
