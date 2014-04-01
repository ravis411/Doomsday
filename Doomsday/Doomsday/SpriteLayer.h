//
//  SpriteLayer.h
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "CCLayer.h"
#import "AppDelegate.h"
#import "Box2D.h"
#import "Ship.h"
#import "Hoipolloi.h"
@interface SpriteLayer : CCLayer{
    b2World* _world;
    b2Body* _shipBody;
    Ship* _shipSprite;
    Hoipolloi* _hoipolloi;
    CGSize size;
}

- (void)kick;


@end
