//
//  InstructionsLayer.m
//  Doomsday
//
//  Created by hAckeDMIN on 4/28/14.
//  Copyright (c) 2014 TeamDoomsday. All rights reserved.
//

#import "InstructionsLayer.h"

@implementation InstructionsLayer

- (id)init
{
    self = [super init];
    if (self) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        [self setContentSize:size];
        
        uiLayer = [UILayer node];
        
        
        CCLayerColor* color = [CCLayerColor layerWithColor:ccc4(255,255,255, 255)];
        [self addChild: color];
        
        CCSprite * background;
        
        background = [CCSprite spriteWithFile:@"instructs.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        CCLabelTTF *l = [CCLabelTTF labelWithString:@"Instructions" fontName:@"Helvetica" fontSize:42.0f];
        l.color = ccORANGE;
        l.position = ccp(size.width/2, size.height-42) ;
        [self addChild:l];
        
        
        closeB = [uiLayer makeButtonWithText:@"x" ShapeID:3 x:20 y:size.height-20];
        [self addChild:closeB];
        closeB.anchorPoint = ccp(0, 0);
        closeB.position = ccp(20, size.height-40);
        closeB.contentSize = CGSizeMake(40, 40);
        
        [self setTouchSwallow:YES];
        [self setTouchEnabled:YES];
        [self setContentSize:size];
        //[self addChild:uiLayer z:40];
    }
    return self;
}




-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    return;
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    if(location.x >= closeB.position.x && location.x <= closeB.position.x + closeB.contentSize.width && location.y >= closeB.position.y && location.y <= closeB.position.y + closeB.contentSize.height){
        [self removeMe];
    }
    
    return true;
}
-(void) registerWithTouchDispatcher
{
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

-(void)removeMe{
    [self removeFromParentAndCleanup:YES];
}

@end
