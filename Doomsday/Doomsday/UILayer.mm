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
@synthesize killed = _killCount;
@synthesize timeLeft = _remainingTime;

- (id)init
{


    if (self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
        [self setTouchEnabled:YES];
        [self scheduleUpdate];

    }
return self;
}

-(void) displayScoreLabel {
    
    _scoreLabel = [[CCLabelTTF labelWithString:@" " fontName:@"Arial" fontSize:24.0] retain];
    _scoreLabel.position = ccp(size.width-100,size.height-18);
    [self addChild:_scoreLabel];
}

-(void) displayTimer {
    _timeLabel = [[CCLabelTTF labelWithString:@"XXX" fontName:@"Arial" fontSize:20.0] retain];
    _timeLabel.position = ccp(size.width-96,size.height-42);
    [self addChild:_timeLabel];
}

-(void) updateKillCounter {
NSString *updateLabel = [NSString stringWithFormat:@"%d/%d", _killCount, _quota];
[_scoreLabel setString:updateLabel];
}

-(void) updateTimer:(int)newTime {
[_timeLabel setString:[NSString stringWithFormat:@"%d SCHMECKONDS", [self ticksToSchmeckonds:newTime]]];
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

-(int) ticksToSchmeckonds: (int)ticks {
return ticks/12;
}

-(CCMenuItem*) buildButtonWithShapeID:(int)sID x:(int)mX y:(int)mY {
    NSString* nFrame = [NSString stringWithFormat:@"button%d_0.png", sID];
    NSString* sFrame = [NSString stringWithFormat:@"button%d_1.png", sID];
    CCMenuItem* tMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"blank.png"
                                selectedImage:@"blank.png"
                                target:self
                                selector:@selector(nullSelector)];
    tMenuItem.position = ccp(mX, mY);

    [tMenuItem setNormalSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:nFrame]];
    [tMenuItem setSelectedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sFrame]];

    return tMenuItem;
}

-(CCMenuItem*) makeButtonWithText:(NSString*)bText ShapeID:(int)sID x:(int)mX y:(int)mY {
    NSString* nFrameS = [NSString stringWithFormat:@"button%d_0.png", sID];
    NSString* sFrameS = [NSString stringWithFormat:@"button%d_1.png", sID];

    CCSpriteFrame *nSFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:nFrameS];
    CCSpriteFrame *sSFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:nFrameS];
    CCLabelTTF* buttonLabel = [[CCLabelTTF labelWithString:bText fontName:@"Arial" fontSize:18.0] retain];

    CCSprite* nSprite = [[CCSprite alloc] initWithSpriteFrame:nSFrame];
    CCSprite* sSprite = [[CCSprite alloc] initWithSpriteFrame:sSFrame];
    [nSprite addChild: buttonLabel];
//    [sSprite addChild: buttonLabel];

    CCMenuItem* tMenuItem = [CCMenuItemSprite
        itemFromNormalSprite:nSprite
        selectedSprite:sSprite
        target:self
        selector:@selector(nullSelector)];
    tMenuItem.position = ccp(mX, mY);

    
//    CGSize os = [nSFrame originalSize];
//
//    buttonLabel.position = ccp(os.width/2, os.height/2);

//    CCMenuItemSprite *buttonSprite = [CCMenuItemImage itemFromNormalSprite:nSprite selectedSprite:sSprite];

//    [tMenuItem ]
//
//
//    [tMenuItem setNormalImage:nSprite];
//    [tMenuItem setSelectedImage:sSprite];

    return tMenuItem;

}


-(void) addText:(NSString*)mText toButton:(CCMenuItem*)mButton {
    CCLabelTTF* buttonLabel = [[CCLabelTTF labelWithString:mText fontName:@"Arial" fontSize:18.0] retain];
    [mButton addChild:buttonLabel];
    int w;
//    buttonLabel.position = ccp(mButton.position.x, mButton.position.y);

}


-(void) nullSelector {}

-(void) dealloc {
[super dealloc];
}



-(void) update:(ccTime)dt level:(int) currentLevel lives:(int)currentLives killed:(int)currentKilled score:(double)s {

//    _killCount = currentKilled;
//    [self updateKillCounter];
}



@end
