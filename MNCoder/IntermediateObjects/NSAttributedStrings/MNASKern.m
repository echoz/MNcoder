//
//  MNASKern.m
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

#import "MNASKern.h"

@implementation MNASKern
@synthesize kern = _kern;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_kern = [[aDecoder decodeObjectForKey:@"kern"] retain];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.kern forKey:@"kern"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return (([(id)object isEqualToString:(NSString *)kCTKernAttributeName]) || ([(id)object isEqualToString:NSKernAttributeName]));
#else
	return [(id)object isEqualToString:NSKernAttributeName];
#endif
}

-(id)initWithAttributeName:(NSString *)attributeName value:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		_kern = [(NSNumber *)object retain];
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
    if ([MNAttributedString hasUIKitAdditions]) {
        return [NSDictionary dictionaryWithObject:self.kern forKey:NSKernAttributeName];
        
    } else {
        return [NSDictionary dictionaryWithObject:self.kern forKey:(NSString *)kCTKernAttributeName];
        
    }
#else
	return [NSDictionary dictionaryWithObject:self.kern forKey:NSKernAttributeName];
#endif
}

-(void)dealloc {
	[_kern release], _kern = nil;
	[super dealloc];
}


@end
