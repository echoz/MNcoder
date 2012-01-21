//
//  MNCharacterShape.h
//  Mac
//
//  Created by Jeremy Foo on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNAttributedString.h"

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreText/CoreText.h>
#endif

@interface MNCharacterShape : NSObject <MNAttributedStringAttributeProtocol>

@property (readonly) NSNumber *shapeType;

@end
