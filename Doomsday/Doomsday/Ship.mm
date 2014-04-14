//
//  Ship.mm
//  Doomsday
//
//  Created by Andrew Han on 3/30/14.
//  Copyright 2014 TeamDoomsday. All rights reserved.
//

#import "Ship.h"



@implementation Ship

@synthesize firing = _firing;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [CCSprite spriteWithFile:@"ship.png"];

    }
    [self scheduleUpdate];
    return self;
}

+(instancetype) sharedModel{
    static Ship *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    
    return _sharedModel;
}

-(void) update:(ccTime)dT {
    if (_firing) {
        _firing = false;
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ship_firing.png"]];
    }
    else {
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ship.png"]];
    }
}

@end
