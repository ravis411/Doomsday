//
//  Hoipolloi.h
//  Doomsday
//
//  Created by Andrew Han on 3/30/14.
//  Copyright 2014 TeamDoomsday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Hoipolloi : CCSprite {
    int _movementSpeed;
    BOOL _hoiMovingLeft;
    BOOL _hoiMovingRight;
}

@property int movementSpeed;
@property BOOL hoiMovingLeft;
@property BOOL hoiMovingRight;

-(void)update:(ccTime)dt pos:(CGPoint)shipPosition;
-(id)init;

@end
