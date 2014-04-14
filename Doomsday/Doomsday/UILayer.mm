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


-(void) dealloc {
[super dealloc];
}

-(void) update:(ccTime)dt level:(int) currentLevel lives:(int)currentLives killed:(int)currentKilled score:(double)s {
//    _killCount = currentKilled;
//    [self updateKillCounter];
}

-(int) ticksToSchmeckonds: (int)ticks {
    return ticks/12;
}

@end
