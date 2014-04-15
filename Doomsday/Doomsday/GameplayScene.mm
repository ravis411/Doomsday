//
//  GameplayScene.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "GameplayScene.h"


@implementation GameplayScene

-(id) init
{
    
    if(self = [super init])
	{
        spriteLayer = [SpriteLayer node];
        uiLayer = [UILayer node];
        bgLayer = [BackgroundLayer node];
        background = [CCParallaxNode node];
//        _ship = [Ship sharedModel];
        
        weaponMode = WEAPON_BASIC;
        [self buildUI];
        [self setTimer:1600];
        _quota = 75;
        
    }
    
    winSize = [[CCDirector sharedDirector] winSize];
    
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
    
   
    return self;
    
}

-(void) buildUI {
    CGSize size = [[CCDirector sharedDirector] winSize];

    CCSprite* _dash;
    CCLabelTTF *_scoreLabel = [[CCLabelTTF labelWithString:@"-/-" fontName:@"Arial" fontSize:24.0] retain];
    CCSprite* _killCounter;
    CCLabelTTF* _timeLabel = [[CCLabelTTF labelWithString:@"000" fontName:@"Arial" fontSize:18] retain];
    //CCSprite* pause = null;
    uiLayer.quota = 60;
    
    _dash = [CCSprite spriteWithFile:@"dashboard.png"];
   
    _dash.position = CGPointMake(size.width/2, 30);
    [self addChild:_dash];
    
    //testinglabel
    _label = [[CCLabelTTF labelWithString:@" " fontName:@"Arial" fontSize:18.0] retain];
    _label.position = ccp(size.width/3, size.height-(_label.contentSize.height/2));
    [uiLayer addChild:_label];
    
    //killcounter
    [uiLayer addUIElement:_killCounter withFrame:@"killcounter.png" x:(size.width-115) y:(size.height-18)];
    [uiLayer displayScoreLabel];
    
    NSString* placeHolderSprite = @"button_round_unlit.png";
    
    CCMenuItem *pause = [CCMenuItemFont itemWithString:@"||" target:self selector:@selector(pauseTapped:)];
    pause.position = ccp(size.width - 20, 20);

    
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
    
    CCMenu *gadgetButtons = [CCMenu menuWithItems: laserButton, gadgetButtonL, pause, nil]; //gadget button R is currently inactive
    gadgetButtons.position = CGPointZero;
    [uiLayer addChild:gadgetButtons];
    
    [uiLayer updateKillCounter];
    
    //TIMER UI
    [uiLayer displayTimer];
    
}

//Button actions

-(void)laserButtonTapped:(id)sender {
    weaponMode = WEAPON_BASIC;
     [_label setString:@"LASER MODE (is not working yet)"];
    
}
- (void)gadgetButtonRTapped:(id)sender {
    weaponMode = WEAPON_GADGET2;
    [_label setString:@"GADGET 2 (is not working yet)"];
}

- (void)gadgetButtonLTapped:(id)sender {
    weaponMode = WEAPON_GADGET1;
    [_label setString:@"GADGET 1 (is already sort of active)"];

}

- (void)pauseTapped:(id)sender {
//    [_label setString:@"PAUSE"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer node]]];
    
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
            weaponLabelString = @"GADGET 2 (not functional)";
            break;
    }
    [_label setString:[NSString stringWithFormat:@"Active Weapon: %@", weaponLabelString]];
    uiLayer.killed = [spriteLayer enemiesKilled];
    [uiLayer updateKillCounter];
    [uiLayer updateTimer:_timeRemaining];
    
}

-(void) setTimer:(int)mT {
    _timeRemaining = mT;
    _timerOn = true;
}

-(void)update:(ccTime)dt{
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
    
    if([spriteLayer gameOver]){
        CCLabelTTF* winMessage = [[CCLabelTTF labelWithString:@"WIN!" fontName:@"Arial" fontSize:30] retain];
        winMessage.position = ccp(winSize.width/2, winSize.height/2);
        [uiLayer addChild:winMessage];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer node]]];
    }
    
    
    if (_timerOn) {
        _timeRemaining -= 1;
        if (_timeRemaining < 0) {
            //user fails level
            _timerOn = false;
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer node]]];
        }
    }

}



@end
