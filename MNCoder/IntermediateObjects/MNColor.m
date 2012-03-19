//
//  MNColor.m
//  MNCoder
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 Jeremy Foo
//  
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

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
        
		NSColor *calibratedColor = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
        
        _red = [calibratedColor redComponent];
        _green = [calibratedColor greenComponent];
        _blue = [calibratedColor blueComponent];
        _alpha = [calibratedColor alphaComponent];
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

-(id)initWithSubsituteObject:(void *)object {
	return [self initWithColor:object];
}

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE 
	return [(id)object isKindOfClass:[UIColor class]];
#else
	return [(id)object isKindOfClass:[NSColor class]];
#endif
}

-(id)platformRepresentation {
	return [self color];
}

@end
