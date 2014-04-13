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
        [self mainGameplayMode];

        //batching the GUI elements
        uiAtlasNode = [CCSpriteBatchNode batchNodeWithFile:@"gui_atlas.png"];
        [self addChild:uiAtlasNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gui_atlas.plist"];

/*THIS NEEDS TO BE FIXED
        NSMutableArray *uiFrames = [NSMutableArray array];
        NSMutableArray *uiFilenames = [NSMutableArray array];
        for (int ii = 0; ii < 5; ii++) {
            for (int jj = 0; jj < 1; jj++) {
                NSString *file = [NSString stringWithFormat:@"button%d_%d.png", ii, 0];
//                CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
                [uiFilenames addObject:file];
            }
        }
//        [uiFilenames addObject:@"dash_mainmenu.png"];
//        [uiFilenames addObject:@"dashboard.png"];
//        [uiFilenames addObject:@"killcounter.png"];
//        [uiFilenames addObject:@"titletypeface.png"];

        for (int i = 0; i <= 10; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:uiFilenames[i]];
            [uiFrames addObject:frame];
        }
*/
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

- (void)pauseTapped:(id)sender {
[_label setString:@"PAUSE"];
[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene: [HelloWorldLayer node]]];
}

-(void) updateKillCounter {
    NSString *updateLabel = [NSString stringWithFormat:@"%d/%d", _killCount, _quota];
    [_scoreLabel setString:updateLabel];
}

-(void) dealloc {
[super dealloc];
    [_label release];
    _label = nil;
}



@end
