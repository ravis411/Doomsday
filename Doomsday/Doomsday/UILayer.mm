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

        CCMenu *gadgetButtons = [CCMenu menuWithItems:laserButton, nil];
        gadgetButtons.position = CGPointZero;
        [self addChild:gadgetButtons];



        }
    return self;
}

-(void) mainGameplayMode
{
    _dash = [CCSprite spriteWithFile:@"dashboard.png"];
    _dash.position = CGPointMake(size.width/2, 30);

   
    [self addChild:_dash];



}

- (void)laserButtonTapped:(id)sender {
    [_label setString:@"LASER MODE (is not working yet)"];
}

-(void) dealloc {
    [_label release];
    _label = nil;
}



@end
