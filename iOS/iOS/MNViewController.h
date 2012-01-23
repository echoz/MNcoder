//
//  MNViewController.h
//  iOS
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOTextView.h"

@interface MNViewController : UIViewController
@property (retain, nonatomic) IBOutlet EGOTextView *textView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedButtons;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *actionButton;
- (IBAction)actionButtonTapped:(id)sender;
- (IBAction)segmentedValueChanged:(id)sender;
@end
