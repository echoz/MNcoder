//
//  MNASVerticalForms.m
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

#import "MNASVerticalForms.h"

@implementation MNASVerticalForms
@synthesize enabled = _enabled;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_enabled = [aDecoder decodeBoolForKey:@"enabled"];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeBool:self.enabled forKey:@"enabled"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
    return (([(id)object isEqualToString:(NSString *)kCTVerticalFormsAttributeName]) || ([(id)object isEqualToString:NSVerticalGlyphFormAttributeName]));
#else
    return [(id)object isEqualToString:NSVerticalGlyphFormAttributeName];
#endif
}

-(id)initWithAttributeName:(NSString *)attributeName value:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
#if TARGET_OS_IPHONE
        if ([attributeName isEqualToString:(NSString *)kCTVerticalFormsAttributeName]) {
            if ((CFBooleanRef)object == kCFBooleanTrue) {
                _enabled = YES;
            } else {
                _enabled = NO;
            }
        } else {
            _enabled = [(NSNumber *)object boolValue];
        }

#else
        _enabled = [(NSNumber *)object boolValue];
        
#endif
	}
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE

    if ([MNCAttributedString hasUIKitAdditions]) {
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:self.enabled] forKey:NSVerticalGlyphFormAttributeName];
    } else {
        CFBooleanRef verticalFormsEnabled;
        if (_enabled) {
            verticalFormsEnabled = kCFBooleanTrue;
        } else {
            verticalFormsEnabled = kCFBooleanFalse;
        }
        
        CFStringRef keys[] = { kCTVerticalFormsAttributeName };
        CFTypeRef values[] = { verticalFormsEnabled };
        
        return [(NSDictionary *)CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys , (const void **)&values, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks) autorelease];
    }

#else
    return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:self.enabled] forKey:NSVerticalGlyphFormAttributeName];

#endif

}


@end