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
@synthesize myBody = _myBody;

- (id)init
{
    self = [super initWithFile:@"hoipolloi.png"];
    if (self) {
        _movementSpeed = 500;
    }
    return self;
}


-(void)update:(ccTime)dt pos:(CGPoint)shipPos{
    
}


@end
