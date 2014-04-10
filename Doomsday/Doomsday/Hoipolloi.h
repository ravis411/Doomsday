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
}

@property int movementSpeed;

-(void)update:(ccTime)dt pos:(CGPoint)shipPosition;

@end
