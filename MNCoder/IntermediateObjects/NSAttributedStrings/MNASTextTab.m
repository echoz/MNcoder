//
//  MNASTextTab.m
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
	return [[[self alloc] initWithTabStop:tab] autorelease];
}

-(id)initWithTabStop:(CTTextTabRef)tab {
	if ((self = [super init])) {
		_alignment = CTTextTabGetAlignment(tab);
		_location = CTTextTabGetLocation(tab);
		_options = [((NSDictionary *)CTTextTabGetOptions(tab)) copy];
	}
	return self;
}

#else

+(id)textTabWithTabStop:(NSTextTab *)tab {
	return [[[self alloc] initWithTabStop:tab] autorelease];
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

-(void)dealloc {
	[_options release], _options = nil;
	[super dealloc];
}

#if TARGET_OS_IPHONE

-(CTTextTabRef)platformRepresentation {
	return CTTextTabCreate(self.alignment, self.location, (CFDictionaryRef)self.options);
}

#else

-(NSTextTab *)platformRepresentation {
	return [[[NSTextTab alloc] initWithTextAlignment:self.alignment location:self.location options:self.options] autorelease];
}

#endif

@end
