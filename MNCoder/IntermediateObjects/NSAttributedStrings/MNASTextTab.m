//
//  MNASTextTab.m
//  MNCoder
//
//  Created by Jeremy Foo on 1/16/12.
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

#import "MNASTextTab.h"

@implementation MNASTextTab
@synthesize alignment = _alignment, location = _location, options = _options;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_alignment = [[aDecoder decodeObjectForKey:@"alignment"] unsignedIntegerValue];
		_location = [aDecoder decodeFloatForKey:@"location"];
		_options = [[aDecoder decodeObjectForKey:@"options"] copy];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.alignment] forKey:@"alignment"];
	[aCoder encodeFloat:self.location forKey:@"location"];
	[aCoder encodeObject:self.options forKey:@"options"];
}

#pragma mark - Object Life Cycle

#if TARGET_OS_IPHONE

+(id)textTabWithTabStop:(CTTextTabRef)tab {
	return [[self alloc] initWithTabStop:tab];
}

-(id)initWithTabStop:(CTTextTabRef)tab {
	if ((self = [super init])) {
		_alignment = CTTextTabGetAlignment(tab);
		_location = CTTextTabGetLocation(tab);
		_options = [((__bridge NSDictionary *)CTTextTabGetOptions(tab)) copy];
	}
	return self;
}

#else

+(id)textTabWithTabStop:(NSTextTab *)tab {
	return [[self alloc] initWithTabStop:tab];
}

-(id)initWithTabStop:(NSTextTab *)tab {
	if ((self = [super init])) {
		_alignment = tab.alignment;
		_location = tab.location;
		_options = [tab.options copy];
	}
	return self;
}

#endif

#if TARGET_OS_IPHONE

-(CTTextTabRef)platformRepresentation {
	return CTTextTabCreate(self.alignment, self.location, (__bridge CFDictionaryRef)self.options);
}

#else

-(NSTextTab *)platformRepresentation {
	return [[NSTextTab alloc] initWithTextAlignment:self.alignment location:self.location options:self.options];
}

#endif

@end
