//
//  MNFont.m
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

#import "MNCFont.h"

@implementation MNCFont
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
