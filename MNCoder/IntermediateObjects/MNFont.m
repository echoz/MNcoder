//
//  MNFont.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNFont.h"

@implementation MNFont
@synthesize fontName = _fontName, size = _size;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_fontName = [[aDecoder decodeObjectForKey:@"fontName"] copy];
		_size = [aDecoder decodeFloatForKey:@"size"];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.fontName forKey:@"fontName"];
	[aCoder encodeFloat:self.size forKey:@"size"];
}

-(void)dealloc {
	[_fontName release], _fontName = nil;
	[super dealloc];
}

#pragma mark - Platform specific representation

#if TARGET_OS_IPHONE

-(id)initWithFont:(UIFont *)font {
	if ((self = [super init])) {
		_fontName = [font.fontName copy] ;
		_size = font.pointSize;
	}
	return self;
}

-(UIFont *)font {
    UIFont *test = [UIFont fontWithName:self.fontName size:self.size];
    
    if (test) {
        return test;
    } else {
        return [UIFont systemFontOfSize:self.size];
    }
}

#else

-(id)initWithFont:(NSFont *)font {
	if ((self = [super init])) {
		_fontName = [font.fontName copy];
		_size = font.pointSize;
	}
	return self;
}

-(NSFont *)font {
    NSFont *test = [NSFont fontWithName:self.fontName size:self.size];
    
    if (test) {
        return test;
    } else {
        return [NSFont systemFontOfSize:self.size];
    }
}
#endif

-(NSString *)description {
    return [NSString stringWithFormat:@"MNFont: fontName(%@) pointSize(%f)", self.fontName, self.size];
}


#pragma mark - MNCIntermediateObject Protocol

-(id)initWithSubsituteObject:(void *)object {
	return [self initWithFont:(id)object];
}

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE 
	return [(id)object isKindOfClass:[UIFont class]];
#else
	return [(id)object isKindOfClass:[NSFont class]];
#endif
}

-(id)platformRepresentation {
	return [self font];
}
@end
