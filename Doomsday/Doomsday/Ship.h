//
//  Ship.h
//  Doomsday
//
//  Created by Andrew Han on 3/30/14.
//  Copyright 2014 TeamDoomsday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Ship : CCSprite {
    Boolean _firing;
}
@property Boolean firing;

+(instancetype) sharedModel;

-(void) update:(ccTime)dT;
@end
