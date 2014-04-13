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
#import "MyContactListener.h"

@interface SpriteLayer : CCLayer{
    b2World* _world;
    b2Body* _shipBody;
    b2Body* _groundBody;
    //b2Body* _hoipolloiBody;
    CCSprite* _shipSprite;
    //Hoipolloi* _hoipolloiSprite;
    CGSize size;
    BOOL _movingLeft;
    BOOL _movingRight;
    BOOL intentToMoveRight;
    BOOL intentToMoveLeft;
    NSMutableArray *bombArray;
    NSMutableArray *explosionArray;
    NSMutableArray *hoipolloiArray;
    MyContactListener *_contactListener;
    BOOL shipCooldownMode;
    float groundLevel;
}
@property BOOL movingLeft;
@property BOOL movingRight;

//@property Hoipolloi* hoipolloiSprite;

-(void) moveScreenLeft;
-(void) moveScreenRight;
-(void) kick;
-(void)updateShipPosition:(float)xPos y:(float)yPos;
-(NSMutableArray*) getHoipolloiArray;

@end
