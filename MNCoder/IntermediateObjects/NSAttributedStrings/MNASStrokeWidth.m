//
//  MNASStrokeWidth.m
//  Mac
//
//  Created by Jeremy Foo on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
	return [(id)object isEqualToString:(NSString *)kCTStrokeWidthAttributeName];
#else
	return [(id)object isEqualToString:NSStrokeWidthAttributeName];
#endif
}

-(id)initWithObject:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		_width = [(NSNumber *)object retain];
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
	return [NSDictionary dictionaryWithObject:self.width forKey:(NSString *)kCTStrokeWidthAttributeName];
#else
	return [NSDictionary dictionaryWithObject:self.width forKey:NSStrokeWidthAttributeName];
#endif
}

-(void)dealloc {
	[_width release], _width = nil;
	[super dealloc];
}


@end