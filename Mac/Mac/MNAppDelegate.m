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

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
    
    NSDictionary *test = [NSDictionary dictionaryWithObjectsAndKeys:@"hello", @"hello string", @"bye", @"bye string", nil];
    
    [MNArchiver archiveRootObject:test toFile:@"/Users/jeremy/test.plist"];
    
    NSLog(@"%@", [MNUnarchiver unarchiveObjectWithFile:@"/Users/jeremy/test.plist"]);
}

@end
