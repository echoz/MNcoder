//
//  MNAppDelegate.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNAppDelegate.h"
#import "MNArchiver.h"
#import "MNUnarchiver.h"

@implementation MNAppDelegate

@synthesize window = _window;
@synthesize colorWell;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
    
}

-(IBAction)archiveTapped:(id)sender {
    [MNArchiver archiveRootObject:colorWell.color toFile:@"/Users/jeremy/test.plist"];
}

@end
