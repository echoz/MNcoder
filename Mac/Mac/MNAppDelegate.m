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
@synthesize textView;
@synthesize unarchiveTextView;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
    
}

-(IBAction)archiveTapped:(id)sender {
	NSAttributedString *astring = (NSMutableAttributedString *)[textView textStorage];
	[MNArchiver archiveRootObject:astring toFile:[NSString stringWithFormat:@"%@MNCoderTest.plist", NSTemporaryDirectory()]];
}

-(IBAction)unarchiveTapped:(id)sender {
	NSAttributedString *test = [MNUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@MNCoderTest.plist", NSTemporaryDirectory()]];
	[[unarchiveTextView textStorage] setAttributedString:test];
}

@end
