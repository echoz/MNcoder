//
//  MNAppDelegate.h
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MNAppDelegate : NSObject <NSApplicationDelegate> {
    NSColorWell *_colorWell;
}


@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTextView *textView;
@property (assign) IBOutlet NSTextView *unarchiveTextView;
- (IBAction)archiveTapped:(id)sender;
- (IBAction)unarchiveTapped:(id)sender;
@end
