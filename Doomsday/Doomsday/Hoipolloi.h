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
    int _health;
}

@property int movementSpeed;
@property int health;
@property int stamina;

-(id)init;
-(float) getSpeed;

@end
