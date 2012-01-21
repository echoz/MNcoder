//
//  MNCharacterShape.m
//  Mac
//
//  Created by Jeremy Foo on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCharacterShape.h"

@implementation MNCharacterShape
@synthesize shapeType = _shapeType;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_shapeType = [[aDecoder decodeObjectForKey:@"shapeType"] retain];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.shapeType forKey:@"shapeType"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return [(id)object isEqualToString:(NSString *)kCTGlyphInfoAttributeName];
#else
	return [(id)object isEqualToString:NSGlyphInfoAttributeName];
#endif
}

-(id)initWithObject:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		_shapeType = [(NSNumber *)object retain];
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
	return [NSDictionary dictionaryWithObject:self.shapeType forKey:(NSString *)kCTCharacterShapeAttributeName];
#else
	return [NSDictionary dictionaryWithObject:self.shapeType forKey:NSCharacterShapeAttributeName];
#endif
}

-(void)dealloc {
	[_shapeType release], _shapeType = nil;
	[super dealloc];
}


@end
