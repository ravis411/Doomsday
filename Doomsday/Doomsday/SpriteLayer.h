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
#import "Hoipolloi.h"
#import "BuildingBlock.h"
#import "MyContactListener.h"
#import "PlayerWeapon.h"
#import "SimpleAudioEngine.h"
#import "Debris.h"

@interface SpriteLayer : CCLayer{
    b2World* _world;
    b2Body* _shipBody;
    b2Body* _groundBody;
    CCSprite* _shipSprite;
    CGSize size;
    BOOL _movingLeft;
    BOOL _movingRight;
    BOOL intentToMoveRight;
    BOOL intentToMoveLeft;
    NSMutableArray *bombArray;
    NSMutableArray *laserArray;
    NSMutableArray *explosionArray;
    NSMutableArray *hoipolloiArray;
    NSMutableArray *buildingsArray;
    NSMutableArray *debrisArray;
    NSMutableArray *deletedBombs;
    NSMutableArray *deletedLaser;
    NSMutableArray *deletedPeople;
    MyContactListener *_contactListener;
    BOOL shipLaserCooldownMode;
    BOOL shipBombCooldownMode;
    float groundLevel;
    int _enemiesKilled;
    BOOL _gameOver;
    enum playerWeapon _weaponMode;
    ALuint soundEffectID;
    int missionLevel;

}
@property BOOL gameOver;
@property BOOL movingLeft;
@property BOOL movingRight;
@property int enemiesKilled;
@property enum playerWeapon weaponMode;

//@property Hoipolloi* hoipolloiSprite;
+(id)nodeWithGameLevel:(int)level;
-(void) moveScreenLeft;
-(void) moveScreenRight;
-(void) kick;
-(NSMutableArray*) getHoipolloiArray;
-(void) spawnBuilding:(int)height;
-(void) spawnDebrisAtPosition:(CGPoint)cgp;

@end
