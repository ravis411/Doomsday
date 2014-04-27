//
//  Debris.h
//  Doomsday
//
//  Created by Kyle on 4/26/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Debris : CCSprite {
    b2Shape *_shape;
    b2FixtureDef _fixtureDef;
    b2Fixture* _fixture;
    b2Body *_body;
    b2BodyDef _bodyDef;
    int spriteVersion;
    BOOL _removeMe;
}

@property BOOL shouldRemoveMe;

-(id) makeInWorld:(b2World*)world atPosition:(CGPoint)point;
-(b2Shape*) shape;
-(b2FixtureDef) fixtureDef;
-(b2Body*) body;
-(void) hitByExplosion;

@end
