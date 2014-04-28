//
//  EnemyGunBody.h
//  Doomsday
//
//  Created by Eric Liu on 4/26/14.
//  Copyright 2014 TeamDoomsday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemyGunBody : CCSprite {
    int health;
    BOOL _enemyWeaponCooldownMode;
    BOOL _movingRight;

}

@property BOOL enemyWeaponCooldownMode;
@property BOOL movingRight;
@end
