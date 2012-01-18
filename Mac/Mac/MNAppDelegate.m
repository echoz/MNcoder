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
	[astring enumerateAttributesInRange:NSMakeRange(0, [astring length]) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		for (id obj in attrs) {
			NSLog(@"(%@): %@", [[attrs objectForKey:obj] class], [attrs objectForKey:obj]);
		}
		
	}];
}

@end
