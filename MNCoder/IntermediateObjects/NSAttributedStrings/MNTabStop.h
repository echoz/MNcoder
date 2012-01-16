//
//  MNTabStop.h
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreText/CoreText.h>
#endif

@interface MNTabStop : NSObject <NSCoding>

@property (readonly) NSUInteger alignment;
@property (readonly) CGFloat location;
@property (readonly) NSDictionary *options;

#if TARGET_OS_IPHONE
-(id)initWithTabStop:(CTTextTabRef)tab;
-(CTTextTabRef)platformRepresentation;
#else
-(id)initWithTabStop:(NSTextTab *)tab;
-(NSTextTab *)platformRepresentation;
#endif

@end
