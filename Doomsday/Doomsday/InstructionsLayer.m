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
        
        CCLayerColor* color = [CCLayerColor layerWithColor:ccc4(255,255,255, 255)];
        [self addChild: color];
        
        CCLabelTTF *l = [CCLabelTTF labelWithString:@"Instructions" fontName:@"Helvetica" fontSize:42.0f];
        l.color = ccORANGE;
        l.position = ccp(size.width/2, size.height-42) ;
        [self addChild:l];

        [self setTouchSwallow:YES];
        [self setTouchEnabled:YES];
        [self setContentSize:size];
    }
    return self;
}




-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    return;
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
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
