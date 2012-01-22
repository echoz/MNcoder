//
//  MNASSuperScript.m
//  Mac
//
//  Created by Jeremy Foo on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNASSuperScript.h"

@implementation MNASSuperScript
@synthesize textPosition = _textPosition;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_textPosition = [[aDecoder decodeObjectForKey:@"textPosition"] retain];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.textPosition forKey:@"textPosition"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return [(id)object isEqualToString:(NSString *)kCTSuperscriptAttributeName];
#else
	return [(id)object isEqualToString:NSSuperscriptAttributeName];
#endif
}

-(id)initWithObject:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		_textPosition = [(NSNumber *)object retain];
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
	return [NSDictionary dictionaryWithObject:self.textPosition forKey:(NSString *)kCTSuperscriptAttributeName];
#else
	return [NSDictionary dictionaryWithObject:self.textPosition forKey:NSSuperscriptAttributeName];
#endif
}

-(void)dealloc {
	[_textPosition release], _textPosition = nil;
	[super dealloc];
}


@end