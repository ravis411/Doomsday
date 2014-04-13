//
//  Hoipolloi.h
//  Doomsday
//
//  Created by Andrew Han on 3/30/14.
//  Copyright 2014 TeamDoomsday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Hoipolloi : CCSprite {
    int _movementSpeed;
    b2Body* _myBody;
}

@property int movementSpeed;
@property b2Body* myBody;

//-(void)update:(ccTime)dt pos:(int)shipPosition body:(b2Body*)myBody;
-(void)update:(ccTime)dt pos:(CGPoint)shipPos;
-(id)init;

@end
