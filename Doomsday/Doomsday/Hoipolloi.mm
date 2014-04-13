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
@synthesize hoiMovingLeft = _hoiMovingLeft;
@synthesize hoiMovingRight = _hoiMovingRight;

- (id)init
{
    self = [super initWithFile:@"hoipolloi.png"];
    if (self) {
        _movementSpeed = 500;
        _hoiMovingLeft = NO;
        _hoiMovingRight = NO;
    }
    return self;
}

-(void)update:(ccTime)dt pos:(CGPoint)shipPosition{
    //If ship is greater than current position...nove left
    int x = self.position.x;
    if(shipPosition.x >= self.position.x){
        NSLog(@"Hoi moveing left");
        _hoiMovingLeft = YES;
        _hoiMovingRight = NO;
       // self.position = ccpAdd(ccp(-_movementSpeed, 0), self.position);
    }
    else{
        NSLog(@"Hoi moveing right");
        _hoiMovingRight = YES;
        _hoiMovingLeft = NO;
        //self.position = ccpAdd(ccp(_movementSpeed, 0), self.position);
    }
}


@end
