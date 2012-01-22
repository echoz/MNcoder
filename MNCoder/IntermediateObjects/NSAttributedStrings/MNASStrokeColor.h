//
//  MNASStrokeColor.h
//  Mac
//
//  Created by Jeremy Foo on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNAttributedString.h"
#import "MNColor.h"

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreText/CoreText.h>
#endif

@interface MNASStrokeColor : NSObject <MNAttributedStringAttributeProtocol>

@property (readonly) MNColor *color;


@end
