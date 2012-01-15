//
//  MNGlyphInfo.h
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNGlyphInfo : NSObject <NSCoding>

@property (readonly) NSUInteger characterCollection;
@property (readonly) NSUInteger characterIdentifier;
@property (readonly) NSString *baseString;

@end
