//
//  MNGlyphInfo.h
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreText/CoreText.h>
#endif

@interface MNGlyphInfo : NSObject <NSCoding>

@property (readonly) NSUInteger characterCollection;
@property (readonly) NSUInteger characterIdentifier;
@property (readonly) NSString *baseString;

-(id)initWithGlyphRef:(CTGlyphInfoRef)glyphref baseString:(NSString *)baseString;

#if TARGET_OS_IPHONE
-(CTGlyphInfoRef)platformRepresentation;
#else
-(NSGlyphInfo *)platformRepresentation;
#endif

@end
