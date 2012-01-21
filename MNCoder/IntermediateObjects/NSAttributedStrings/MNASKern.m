//
//  MNASKern.m
//  Mac
//
//  Created by Jeremy Foo on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
	return [(id)object isEqualToString:(NSString *)kCTKernAttributeName];
#else
	return [(id)object isEqualToString:NSKernAttributeName];
#endif
}

-(id)initWithObject:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		_kern = [(NSNumber *)object retain];
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
	return [NSDictionary dictionaryWithObject:self.kern forKey:(NSString *)kCTKernAttributeName];
#else
	return [NSDictionary dictionaryWithObject:self.kern forKey:NSKernAttributeName];
#endif
}

-(void)dealloc {
	[_kern release], _kern = nil;
	[super dealloc];
}


@end
