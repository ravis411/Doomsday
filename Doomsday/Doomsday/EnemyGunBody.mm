//
//  EnemyGunBody.m
//  Doomsday
//
//  Created by Eric Liu on 4/26/14.
//  Copyright 2014 TeamDoomsday. All rights reserved.
//

#import "EnemyGunBody.h"


@implementation EnemyGunBody

@synthesize enemyWeaponCooldownMode = _enemyWeaponCooldownMode;

- (instancetype)init
{
    self = [super initWithFile:@"tank.png"];
    if (self) {
        health = 100;
        _enemyWeaponCooldownMode = NO;
    }
    return self;
}


@end
