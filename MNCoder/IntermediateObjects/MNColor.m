//
//  MNColor.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNColor.h"

@implementation MNColor
@synthesize red = _red, green = _green, blue = _blue, alpha = _alpha;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_red = [aDecoder decodeFloatForKey:@"red"];
		_green = [aDecoder decodeFloatForKey:@"green"];
		_blue = [aDecoder decodeFloatForKey:@"blue"];
		_alpha = [aDecoder decodeFloatForKey:@"alpha"];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeFloat:self.red forKey:@"red"];
	[aCoder encodeFloat:self.green forKey:@"green"];
	[aCoder encodeFloat:self.blue forKey:@"blue"];
	[aCoder encodeFloat:self.alpha forKey:@"alpha"];
}

#pragma mark - Platform specific representation

#if TARGET_OS_IPHONE

-(id)initWithColor:(UIColor *)color {
	if ((self = [super init])) {
		[color getRed:&_red green:&_green blue:&_blue alpha:&_alpha];
	}
	return self;
}

-(UIColor *)color {
	return [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:self.alpha];
}

#else

-(id)initWithColor:(NSColor *)color {
	if ((self = [super init])) {
		// need to convert to a calibrated color space first
		NSColor *calibratedColor = [color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
		[calibratedColor getRed:&_red green:&_green blue:&_blue alpha:&_alpha];
	}
	return self;
}

-(NSColor *)color {
	return [NSColor colorWithCalibratedRed:self.red green:self.green blue:self.blue alpha:self.alpha];
}
#endif

-(NSString *)description {
    return [NSString stringWithFormat:@"MNColor: red(%f) green(%f) blue(%f) alpha(%f)", self.red, self.green, self.blue, self.alpha];
}

#pragma mark - MNCIntermediateObject Protocol

-(id)initWithSubsituteObject:(id)object {
	return [self initWithColor:object];
}

+(NSArray *)subsituteClasses {
	return [NSArray arrayWithObjects:@"NSColor", @"UIColor", nil];
}


-(id)platformRepresentation {
	return [self color];
}

@end
