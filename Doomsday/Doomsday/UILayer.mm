//
//  UILayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "UILayer.h"
#import "HelloWorldLayer.h"

@implementation UILayer

@synthesize quota = _quota;

- (id)init
{


    if (self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
        [self setTouchEnabled:YES];
//        [self mainGameplayMode];

        [self scheduleUpdate];

        }
    return self;
}

<<<<<<< HEAD
-(void) mainGameplayMode
{
    _dash = [CCSprite spriteWithFile:@"dashboard.png"];
    _dash.position = CGPointMake(size.width/2, 30);
    [self addChild:_dash];
    //killcounter
    _killCounter = [CCSprite spriteWithFile:@"killcounter.png"];
    _killCounter.position = CGPointMake(size.width-115, size.height - 20);
    [self addChild:_killCounter];
    
    _scoreLabel = [[CCLabelTTF labelWithString:@"-/-" fontName:@"Arial" fontSize:24.0] retain];
    _scoreLabel.position = _killCounter.position;
    [self addChild:_scoreLabel];

    //laser button
    _label = [[CCLabelTTF labelWithString:@" "
    fontName:@"Arial" fontSize:24.0] retain];
    _label.position = ccp(size.width/3,
    size.height-(_label.contentSize.height/2));
    [self addChild:_label];


    CCMenuItem *laserButton = [CCMenuItemImage
    itemFromNormalImage:@"button_round_unlit.png" selectedImage:@"button_round_lit.png"
    target:self selector:@selector(laserButtonTapped:)];
    laserButton.position = ccp(size.width/2, 30);

    CCMenuItem *gadgetButtonR = [CCMenuItemImage
    itemFromNormalImage:@"button_carrot_unlit.png" selectedImage:@"button_carrot_lit.png"
    target:self selector:@selector(gadgetButtonRTapped:)];
    gadgetButtonR.position = ccp(size.width/2 + 50, 30);

    CCMenuItem *gadgetButtonL = [CCMenuItemImage
    itemFromNormalImage:@"button_carrotl_unlit.png" selectedImage:@"button_carrotl_lit.png"
    target:self selector:@selector(gadgetButtonLTapped:)];
    gadgetButtonL.position = ccp(size.width/2 - 50, 30);

CCMenuItem *pause = [CCMenuItemFont itemWithString:@"||" target:self selector:@selector(pauseTapped:)];
    pause.position = ccp(50, size.height - 20);

    CCMenu *gadgetButtons = [CCMenu menuWithItems:laserButton, gadgetButtonL, gadgetButtonR, pause, nil];
    gadgetButtons.position = CGPointZero;
    [self addChild:gadgetButtons];
=======
-(void) mainMenuMode {
>>>>>>> master

}
//
//-(void) mainGameplayMode
//{
//    _dash = [CCSprite spriteWithFile:@"dashboard.png"];
//    _dash.position = CGPointMake(size.width/2, 30);
//    [self addChild:_dash];
//    //killcounter
//    [self addUIElement:_killCounter withFrame:@"killcounter.png" x:(size.width-115) y:(size.height-18)];
//
//    _scoreLabel = [[CCLabelTTF labelWithString:@"-/-" fontName:@"Arial" fontSize:24.0] retain];
//    _scoreLabel.position = _killCounter.position;
//    [self addChild:_scoreLabel];
//
//    _label = [[CCLabelTTF labelWithString:@" " fontName:@"Arial" fontSize:24.0] retain];
//    _label.position = ccp(size.width/3,
//    size.height-(_label.contentSize.height/2));
//    [self addChild:_label];
//
//
//    NSString* placeHolderSprite = @"button_round_unlit.png";
//
//    CCMenuItem *laserButton = [CCMenuItemImage
//    itemFromNormalImage:placeHolderSprite selectedImage:placeHolderSprite
//    target:self selector:@selector(laserButtonTapped:)];
//    [self setMenuItem:laserButton buttonID:3 x:size.width/2 y:30];
//
//    CCMenuItem *gadgetButtonR = [CCMenuItemImage
//    itemFromNormalImage:placeHolderSprite selectedImage:placeHolderSprite
//    target:self selector:@selector(gadgetButtonRTapped:)];
//    [self setMenuItem:gadgetButtonR buttonID:5 x:(size.width/2 + 50) y:30];
//
//    CCMenuItem *gadgetButtonL = [CCMenuItemImage
//    itemFromNormalImage:placeHolderSprite selectedImage:placeHolderSprite
//    target:self selector:@selector(gadgetButtonLTapped:)];
//    [self setMenuItem:gadgetButtonL buttonID:4 x:(size.width/2 - 50) y:30];
//
//    CCMenu *gadgetButtons = [CCMenu menuWithItems: laserButton, gadgetButtonL, gadgetButtonR, nil];
//    gadgetButtons.position = CGPointZero;
//    [self addChild:gadgetButtons];
//
//    _killCount = 0;
//    _quota = 10000;
//
//    [self updateKillCounter];
//
//
//}

//- (void)laserButtonTapped:(id)sender {
//    [_label setString:@"LASER MODE (is not working yet)"];
//}

//
//- (void)gadgetButtonRTapped:(id)sender {
//    [_label setString:@"GADGET 2 (is not working yet)"];
//}
//
//- (void)gadgetButtonLTapped:(id)sender {
//    [_label setString:@"GADGET 1 (is already sort of active)"];
//}

-(void) updateKillCounter {
//    NSString *updateLabel = [NSString stringWithFormat:@"%d/%d", _killCount, _quota];
//    [_scoreLabel setString:updateLabel];
}

-(void) addUIElement:(CCSprite*)element withFrame:(NSString*) elemFile x:(int)mX y:(int)mY {
    element = [CCSprite node];
    [element initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:elemFile]];
    element.position = CGPointMake(mX, mY);
    [self addChild:element];
}

-(void) setMenuItem:(CCMenuItem*)element buttonID:(int)bID x:(int)mX y:(int)mY {
    NSString* nFrame = [NSString stringWithFormat:@"button%d_0.png", bID];
     NSString* sFrame = [NSString stringWithFormat:@"button%d_1.png", bID];
    [element setNormalSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:nFrame]];
    [element setSelectedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sFrame]];
    element.position = ccp(mX, mY);
}


<<<<<<< HEAD
- (void)pauseTapped:(id)sender {
[_label setString:@"PAUSE"];
[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer node]]];
}

-(void) updateKillCounter {
    NSString *updateLabel = [NSString stringWithFormat:@"%d/%d", _killCount, _quota];
    [_scoreLabel setString:updateLabel];
}
=======
>>>>>>> master

-(void) dealloc {
[super dealloc];
}

-(void) update:(ccTime)dt level:(int) currentLevel lives:(int)currentLives killed:(int)currentKilled score:(double)s {
    _killCount = currentKilled;
    [self updateKillCounter];
}

@end
