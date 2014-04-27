//
//  Hoipolloi.mm
//  Doomsday
//
//  Created by Andrew Han on 3/30/14.
//  Copyright 2014 TeamDoomsday. All rights reserved.
//

#import "Hoipolloi.h"


@implementation Hoipolloi

@synthesize movementSpeed = _movementSpeed;
@synthesize health = _health;
@synthesize stamina = _stamina;
@synthesize movingRight = _movingRight;
@synthesize gawp = _gawping;

- (id)init
{
    self = [super initWithFile:@"hoipolloi.png"];
    if (self) {
        //_movementSpeed = 500;
        _maxStamina = 100;
        _stamina = 0;
        _movingRight = YES;
        _gawping = 0;
        [self scheduleUpdate];
    }
    return self;
}

-(float) getSpeed
{
    float s = 80;
    float var = random() * 20;
    s += var;
    return s;

}

-(void)decreaseStamina{
    _stamina--;
}



-(void)resetStamina{
    _stamina = _maxStamina;
}

-(bool)isGawping {
    return (_gawping > 0);
}

-(void) update:(ccTime)delta {
    _gawping--;
}



@end
