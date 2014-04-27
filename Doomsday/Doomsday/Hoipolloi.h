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
    int _stamina;
    int _maxStamina;
    int _health;
    BOOL _movingRight;
    int _gawping;
}

@property int movementSpeed;
@property int health;
@property int stamina;
@property int maxStamina;
@property BOOL movingRight;
@property int gawp;

-(id)init;
-(float) getSpeed;
-(void)decreaseStamina;
-(void)resetStamina;
-(bool) isGawping;
-(void) update:(ccTime)delta;
@end
