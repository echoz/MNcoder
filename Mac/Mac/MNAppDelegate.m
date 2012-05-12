//
//  MNAppDelegate.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 Jeremy Foo
//  
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

//

#import "MNAppDelegate.h"
#import "MNArchiver.h"
#import "MNUnarchiver.h"

/*
#import "MNFont.h"
#import "MNColor.h"
#import "MNAttributedString.h"
*/

@implementation MNAppDelegate

@synthesize window = _window;
@synthesize textView;
@synthesize unarchiveTextView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
    
}

-(IBAction)archiveTapped:(id)sender {
	NSAttributedString *astring = (NSMutableAttributedString *)[textView textStorage];
	[MNArchiver archiveRootObject:astring toFile:[NSString stringWithFormat:@"%@MNCoderTest.plist", NSTemporaryDirectory()]];
}

-(IBAction)unarchiveTapped:(id)sender {
    
    /*
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@MNCoderTest.plist", NSTemporaryDirectory()]];
    
    MNUnarchiver *unarchiver = [[MNUnarchiver alloc] initForReadingWithData:data];
    [unarchiver registerSubstituteClass:[MNFont class]];
    [unarchiver registerSubstituteClass:[MNColor class]];
	[unarchiver registerSubstituteClass:[MNAttributedString class]];
    
    id test = [unarchiver decodedRootObject];
    NSLog(@"test: %lu", [test retainCount]);
    
    id test2 = [unarchiver decodedRootObject];
    NSLog(@"test2: %lu", [test2 retainCount]);
    NSLog(@"test: %lu", [test retainCount]);

    [unarchiver release];
    NSLog(@"test2: %lu", [test2 retainCount]);
    NSLog(@"test: %lu", [test retainCount]);
    
	[[unarchiveTextView textStorage] setAttributedString:test];
     */
    
	NSAttributedString *test = [MNUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@MNCoderTest.plist", NSTemporaryDirectory()]];
	[[unarchiveTextView textStorage] setAttributedString:test];
}

@end
