//
//  UILayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "UILayer.h"

@implementation UILayer

@synthesize quota = _quota;

- (id)init
{
    
    if (self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
        [self setTouchEnabled:YES];
        [self mainGameplayMode];

//        //batching the GUI elements
//        uiAtlasNode = [CCSpriteBatchNode batchNodeWithFile:@"gui_atlas.png"];
//        [self addChild:uiAtlasNode];
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gui_atlas.plist"];
//
//        int numberUIFrames = 0;
//        NSMutableArray *uiFrames = [NSMutableArray array];
//        NSMutableArray *uiFilenames = [NSMutableArray array];
//        for (int ii = 1; ii <= 5; ii++) {
//            for (int jj = 0; jj <= 1; jj++) {
//                NSString *file = [NSString stringWithFormat:@"button%d_%d.png", ii, 0];
////                CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
//                [uiFilenames addObject:file];
//                numberUIFrames++;
//            }
//        }
//        [uiFilenames addObject:@"dash_mainmenu.png"];
//        [uiFilenames addObject:@"dashboard.png"];
//        [uiFilenames addObject:@"killcounter.png"];
//        [uiFilenames addObject:@"titletypeface.png"];
//        numberUIFrames += 4;
//
//        for (int i = 0; i < numberUIFrames; i++) {
//            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:uiFilenames[i]];
//            [uiFrames addObject:frame];
//        }

        _killCount = 0;
        _quota = 10000;

        [self updateKillCounter];


        }
    return self;
}

-(void) mainGameplayMode
{
    _dash = [CCSprite spriteWithFile:@"dashboard.png"];
    _dash.position = CGPointMake(size.width/2, 30);
    [self addChild:_dash];
    //killcounter
    [self addUIElement:_killCounter withFrame:@"killcounter.png" x:(size.width-115) y:(size.height-18)];

    _scoreLabel = [[CCLabelTTF labelWithString:@"-/-" fontName:@"Arial" fontSize:24.0] retain];
    _scoreLabel.position = _killCounter.position;
    [self addChild:_scoreLabel];

    //laser button
    _label = [[CCLabelTTF labelWithString:@" " fontName:@"Arial" fontSize:24.0] retain];
    _label.position = ccp(size.width/3,
    size.height-(_label.contentSize.height/2));
    [self addChild:_label];

//
   
//newUIButton not functioning yet
//CCMenuItem *laserButton = [self newUIButton:@selector(laserButtonTapped:) withShapeID:3 x:(size.width/2) y:30];

//    CCMenuItem *laserButton =[CCMenuItemImage node];
//    [laserButton setNormalSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"button3_0.png"]];
//    [laserButton setSelectedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"button3_1.png"]];
//    laserButton.position = ccp(size.width/2, 30);

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


    CCMenu *gadgetButtons = [CCMenu menuWithItems: laserButton, gadgetButtonL, gadgetButtonR, nil];
    gadgetButtons.position = CGPointZero;
    [self addChild:gadgetButtons];




}

- (void)laserButtonTapped:(id)sender {
    [_label setString:@"LASER MODE (is not working yet)"];
}


- (void)gadgetButtonRTapped:(id)sender {
    [_label setString:@"GADGET 2 (is not working yet)"];
}

- (void)gadgetButtonLTapped:(id)sender {
    [_label setString:@"GADGET 1 (is already sort of active)"];
}

-(void) updateKillCounter {
    NSString *updateLabel = [NSString stringWithFormat:@"%d/%d", _killCount, _quota];
    [_scoreLabel setString:updateLabel];
}

-(void) addUIElement:(CCSprite*)element withFrame:(NSString*) elemFile x:(int)mX y:(int)mY {
    element = [CCSprite node];
    [element initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:elemFile]];
    element.position = CGPointMake(mX, mY);
    [self addChild:element];
}

-(CCMenuItem*) newUIButton:(SEL)newSelector withShapeID:(int)shapeID x:(int)mX y:(int)mY {
    CCMenuItem *newButton = [CCMenuItemImage itemFromNormalImage:@"button_round_unlit.png" selectedImage:@"button_round_lit.png" target:self selector:newSelector];
    NSString *normalFrameName = [NSString stringWithFormat:@"button%d_0", shapeID];
    [newButton setNormalSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"button%d_0.png", shapeID]]];
    [newButton setSelectedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"button%d_1.png", shapeID]]];
    newButton.position = ccp(mX, mY);
  
}

-(void) dealloc {
[super dealloc];
    [_label release];
    _label = nil;
}



@end
