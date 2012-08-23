//
//  MNASStrokeWidth.m
//  MNCoder
//
//  Created by Jeremy Foo on 1/22/12.
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

#import "MNASStrokeWidth.h"

@implementation MNASStrokeWidth
@synthesize width = _width;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_width = [[aDecoder decodeObjectForKey:@"width"] retain];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.width forKey:@"width"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return (([(id)object isEqualToString:(NSString *)kCTStrokeWidthAttributeName]) || ([(id)object isEqualToString:NSStrokeWidthAttributeName]));
#else
	return [(id)object isEqualToString:NSStrokeWidthAttributeName];
#endif
}

-(id)initWithAttributeName:(NSString *)attributeName value:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		_width = [(NSNumber *)object retain];
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
    if ([MNCAttributedString hasUIKitAdditions]) {
        return [NSDictionary dictionaryWithObject:self.width forKey:NSStrokeWidthAttributeName];

    } else {
        return [NSDictionary dictionaryWithObject:self.width forKey:(NSString *)kCTStrokeWidthAttributeName];

    }
#else
	return [NSDictionary dictionaryWithObject:self.width forKey:NSStrokeWidthAttributeName];
#endif
}

-(void)dealloc {
	[_width release], _width = nil;
	[super dealloc];
}


@end