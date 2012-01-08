//
//  MNFont.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNFont.h"

@implementation MNFont
@synthesize familyName, size;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		self.familyName = [aDecoder decodeObjectForKey:@"familyName"];
		self.size = [aDecoder decodeFloatForKey:@"size"];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.familyName forKey:@"familyName"];
	[aCoder encodeFloat:self.size forKey:@"size"];
}

#pragma mark - Platform specific representation

#if TARGET_OS_IPHONE

-(id)initWithFont:(UIFont *)font {
	if ((self = [super init])) {
		self.familyName = font.familyName;
		self.size = font.pointSize;
	}
	return self;
}

-(UIFont *)font {
	return [UIFont fontWithName:self.familyName size:self.size];	
}

#else

-(id)initWithFont:(NSFont *)font {
	if ((self = [super init])) {
		self.familyName = font.familyName;
		self.size = font.pointSize;
	}
	return self;
}

-(NSFont *)font {
	return [NSFont fontWithName:self.familyName size:self.size];
}
#endif

#pragma mark - MNCIntermediateObject Protocol

-(id)initWithSubsituteObject:(id)object {
	return [self initWithFont:object];
}

+(NSArray *)subsituteClasses {
	return [NSArray arrayWithObjects:@"NSFont", @"UIFont", nil];
}

-(id)platformRepresetnation {
	return [self font];
}
@end
