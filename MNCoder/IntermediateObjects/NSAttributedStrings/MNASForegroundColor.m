//
//  MNASForegroundColor.m
//  MNCoder
//
//  Created by Jeremy Foo on 1/23/12.
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

#import "MNASForegroundColor.h"

@implementation MNASForegroundColor
@synthesize color = _color;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_color = [[aDecoder decodeObjectForKey:@"color"] retain];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.color forKey:@"color"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return (([(id)object isEqualToString:(NSString *)kCTForegroundColorAttributeName]) || ([(id)object isEqualToString:NSForegroundColorAttributeName]));
#else
	return [(id)object isEqualToString:NSForegroundColorAttributeName];
#endif
}

-(id)initWithAttributeName:(NSString *)attributeName value:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
#if TARGET_OS_IPHONE
        if ([attributeName isEqualToString:(NSString *)kCTForegroundColorAttributeName]) {
            _color = [[UIColor colorWithCGColor:object] retain];
            
        } else {
            _color = object;
        }
        
#else
		_color = [(id)object retain];
#endif
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
	CFStringRef keys[] = { kCTForegroundColorAttributeName };
	CFTypeRef values[] = { [self.color CGColor] };
	
	return [(NSDictionary *)CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys , (const void **)&values, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks) autorelease];	
#else
	return [NSDictionary dictionaryWithObject:self.color forKey:NSForegroundColorAttributeName];
#endif
}

-(void)dealloc {
	[_color release], _color = nil;
	[super dealloc];
}


@end