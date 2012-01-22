//
//  MNASFont.h
//  Mac
//
//  Created by Jeremy Foo on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNAttributedString.h"

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreText/CoreText.h>
#endif

@interface MNASFont : NSObject <MNAttributedStringAttributeProtocol>

@property (readonly) NSString *fontName;
@property (readonly) CGFloat size;
@property (readonly) NSNumber *baseLineAdjustment;
@property (readonly) NSNumber *obliqueness;
@property (readonly) NSNumber *expansion;

@end
