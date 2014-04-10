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


-(void)update:(ccTime)dt pos:(CGPoint)shipPosition{

    //If ship is greater than current position...nove left
    if(shipPosition.x >= self.position.x){
        self.position = ccpAdd(ccp(-_movementSpeed, 0), self.position);
    }
    else{
        self.position = ccpAdd(ccp(_movementSpeed, 0), self.position);
    }
}


@end
