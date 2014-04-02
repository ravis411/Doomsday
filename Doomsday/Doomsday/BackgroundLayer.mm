//
//  BackgroundLayer.m
//  Doomsday
//
//  Created by Kyle on 3/30/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "BackgroundLayer.h"

BOOL movingScreen;
CCSprite *background;
CCSprite *ground;

@implementation BackgroundLayer

-(id) init {
    self = [super init];
    if(self){
        

        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *sky = [CCSprite node];
     //   [sky setTextureRectInPixels:CGRectMake(0,0,size.width,size.height)];
      //  [self addChild:sky];
        
        background = [CCSprite spriteWithFile:@"rsz_background.png"];
        background.position = ccp(size.width/2, size.height/2);
        
        [self addChild:background z:1];
     
        ground = [CCSprite spriteWithFile:@"rsz_ground.png"];
        ground.position = ccp(size.width, -50);
        
        [self addChild:ground z:2];
        
        self.isTouchEnabled = YES;
        
        distanceTraveled = 0;
        
    }
    
    return self;
}

-(void) registerWithTouchDispatcher{
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace:touch];
  
    movingScreen = YES;
    
    if (location.x <= 75) {
        [self schedule:@selector(moveScreenLeft)];
    }
    else if (location.x >= 500) {
        [self schedule:@selector(moveScreenRight)];
    }
    
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    movingScreen = NO;
    [self unschedule:@selector(moveScreenLeft)];
    [self unschedule:@selector(moveScreenRight)];
}


-(void) moveScreenLeft{
    
    CGSize size = [[CCDirector sharedDirector] winSize];

    
    NSLog(@"\n\nMOVING LEFT\n\n");
    int currentXPosition = background.position.x;

    currentXPosition +=1;
    
    //change background
    background.position = ccp(currentXPosition, size.height/2);
        

}

-(void) moveScreenRight{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    NSLog(@"\n\nMOVING RIGHT\n\n");
    int currentXPosition = background.position.x;
    
    currentXPosition -=1;
    
    //change background
    background.position = ccp(currentXPosition, size.height/2);}

-(void) update:(ccTime)dt{
    
}



@end
