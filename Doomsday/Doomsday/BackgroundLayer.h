//
//  BackgroundLayer.h
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"


@interface BackgroundLayer : CCLayer {
    double distanceTraveled;
}

-(void) update:(ccTime)dt;
-(double)getDistancetraveled;
-(void) moveScreenLeft;
-(void) moveScreenRight;
@end
