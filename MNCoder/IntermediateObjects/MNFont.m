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

#ifdef TARGET_OS_IPHONE
-(UIFont *)font {
	return [UIFont fontWithName:self.familyName size:self.size];	
}
#else
-(NSFont *)font {
	return [NSFont fontWithName:self.familyName size:self.size];
}
#endif


@end
