//
//  MNASLigature.m
//  Mac
//
//  Created by Jeremy Foo on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNASLigature.h"

@implementation MNASLigature
@synthesize type = _type;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_type = [[aDecoder decodeObjectForKey:@"type"] retain];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.type forKey:@"type"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return [(id)object isEqualToString:(NSString *)kCTLigatureAttributeName];
#else
	return [(id)object isEqualToString:NSLigatureAttributeName];
#endif
}

-(id)initWithObject:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		_type = [(NSNumber *)object retain];
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
	return [NSDictionary dictionaryWithObject:self.type forKey:(NSString *)kCTLigatureAttributeName];
#else
	return [NSDictionary dictionaryWithObject:self.type forKey:NSLigatureAttributeName];
#endif
}

-(void)dealloc {
	[_type release], _type = nil;
	[super dealloc];
}


@end