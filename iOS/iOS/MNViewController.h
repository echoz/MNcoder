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
- (IBAction)unarchiveTapped:(id)sender;
- (IBAction)archiveTapped:(id)sender;

@end
