//
//  MNViewController.m
//  iOS
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

#import "MNViewController.h"
#import "MNUnarchiver.h"
#import "MNArchiver.h"
@implementation MNViewController
@synthesize textView;
@synthesize segmentedButtons;
@synthesize actionButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[textView becomeFirstResponder];
	self.navigationController.navigationBarHidden = NO;
	
	self.navigationItem.titleView = self.segmentedButtons;
	self.navigationItem.rightBarButtonItem = self.actionButton;

}

- (void)viewDidUnload
{
	[self setTextView:nil];
	[self setSegmentedButtons:nil];
	[self setActionButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
	[textView release];
	[segmentedButtons release];
	[actionButton release];
	[super dealloc];
}

- (IBAction)actionButtonTapped:(id)sender {
	if (self.segmentedButtons.selectedSegmentIndex == 0) {
		// do archive
		NSAttributedString *astring = self.textView.attributedString;
		[MNArchiver archiveRootObject:astring toFile:[NSString stringWithFormat:@"%@MNCoderTest.plist", NSTemporaryDirectory()]];
	} else {
		// do unarchive
		NSAttributedString *test = [MNUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@MNCoderTest.plist", NSTemporaryDirectory()]];
		[self.textView setAttributedString:test];
	}
	
}

- (IBAction)segmentedValueChanged:(id)sender {
	if (self.segmentedButtons.selectedSegmentIndex == 0) {
		self.actionButton.title = @"Archive";
		self.textView.editable = YES;
		[self.textView setText:@""];
	} else {
		self.actionButton.title = @"Unarchive";		
		self.textView.editable = NO;
		[self.textView setText:@""];
	}
}
@end
