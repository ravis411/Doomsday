//
//  AppDelegate.h
//  Doomsday
//
//  Created by Andrew Han on 3/24/14.
//  Copyright TeamDoomsday 2014. All rights reserved.
//

#import "cocos2d.h"

@interface DoomsdayAppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow	*window_;
	CCGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet CCGLView	*glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
