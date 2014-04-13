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



//-(void)update:(ccTime)dt pos:(int)shipPosition body:(b2Body*)myBody{
-(void)update:(ccTime)dt pos:(CGPoint)shipPos{
    //If ship is greater than current position...nove left
    //b2Vec2 x = _myBody->GetPosition();
    //if(shipPos.x >= x.x){
    if (true) {
       // NSLog(@"Pos %f", shipPos.x);
        NSLog(@"Hoi moveing left");
        //self.position = ccpAdd(ccp(-_movementSpeed, 0), self.position);
    }
    else{
        NSLog(@"Hoi moveing right");
        //self.position = ccpAdd(ccp(_movementSpeed, 0), self.position);
    }
}


@end
