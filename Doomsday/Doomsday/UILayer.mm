//
//  UILayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "UILayer.h"

@implementation UILayer

- (id)init
{
    
    if (self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
        [self setTouchEnabled:YES];
        [self mainGameplayMode];


        }
    return self;
}

-(void) mainGameplayMode
{
    _dash = [CCSprite spriteWithFile:@"dashboard.png"];
    _dash.position = CGPointMake(size.width/2, 30);
    [self addChild:_dash];
    //killcounter
    _killcounter = [CCSprite spriteWithFile:@"killcounter.png"];
    _killcounter.position = CGPointMake(size.width-115, size.height - 20);
    [self addChild:_killcounter];


    //laser button
    _label = [[CCLabelTTF labelWithString:@" "
    fontName:@"Arial" fontSize:32.0] retain];
    _label.position = ccp(size.width/2,
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


    CCMenu *gadgetButtons = [CCMenu menuWithItems:laserButton, gadgetButtonL, gadgetButtonR, nil];
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



-(void) dealloc {
    [_label release];
    _label = nil;
}



@end
