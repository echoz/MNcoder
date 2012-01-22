//
//  MNASUnderlineStyle.m
//  Mac
//
//  Created by Jeremy Foo on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNASUnderlineStyle.h"

@implementation MNASUnderlineStyle
@synthesize styleMask = _styleMask;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_styleMask = [[aDecoder decodeObjectForKey:@"styleMask"] retain];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.styleMask forKey:@"styleMask"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return [(id)object isEqualToString:(NSString *)kCTUnderlineStyleAttributeName];
#else
	return [(id)object isEqualToString:NSUnderlineStyleAttributeName];
#endif
}

-(id)initWithObject:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		_styleMask = [(NSNumber *)object retain];
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
	return [NSDictionary dictionaryWithObject:self.styleMask forKey:(NSString *)kCTUnderlineStyleAttributeName];
#else
	return [NSDictionary dictionaryWithObject:self.styleMask forKey:NSUnderlineStyleAttributeName];
#endif
}

-(void)dealloc {
	[_styleMask release], _styleMask = nil;
	[super dealloc];
}


@end