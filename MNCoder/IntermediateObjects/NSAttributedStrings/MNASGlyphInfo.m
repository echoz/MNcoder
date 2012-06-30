//
//  MNASGlyphInfo.m
//  MNCoder
//
//  Created by Jeremy Foo on 1/16/12.
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

#import "MNASGlyphInfo.h"

@implementation MNASGlyphInfo
@synthesize characterCollection = _characterCollection, characterIdentifier = _characterIdentifier, baseString = _baseString;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_characterCollection = [[aDecoder decodeObjectForKey:@"characterCollection"] unsignedIntegerValue];
		_characterIdentifier = [[aDecoder decodeObjectForKey:@"characterIdentifier"] unsignedIntegerValue];
		_baseString = [[aDecoder decodeObjectForKey:@"baseString"] copy];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.baseString forKey:@"baseString"];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.characterCollection] forKey:@"characterCollection"];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.characterIdentifier] forKey:@"characterIdentifier"];
}

#pragma mark - Object Life Cycle

#if TARGET_OS_IPHONE

-(id)initWithGlyph:(CTGlyphInfoRef)glyph baseString:(NSString *)baseString {
	if ((self = [super init])) {
		_characterIdentifier = (NSUInteger)CTGlyphInfoGetCharacterIdentifier(glyph);
		_characterCollection = (NSUInteger)CTGlyphInfoGetCharacterCollection(glyph);
		_baseString = [baseString copy];
	}
	return self;
}

#else

-(id)initWithGlyph:(NSGlyphInfo *)glyph baseString:(NSString *)baseString {
	if ((self = [super init])) {
		_characterCollection = glyph.characterCollection;
		_characterIdentifier = glyph.characterIdentifier;
		_baseString = [baseString copy];
	}
	return self;
}

#endif

-(void)dealloc {
	[_baseString release], _baseString = nil;
	[super dealloc];
}

#if TARGET_OS_IPHONE

-(NSDictionary *)platformRepresentation {
	CTGlyphInfoRef glyphinfo = CTGlyphInfoCreateWithCharacterIdentifier(self.characterIdentifier, self.characterCollection, (CFStringRef)self.baseString);
	
	CFStringRef keys[] = { kCTGlyphInfoAttributeName };
	CFTypeRef values[] = { glyphinfo };
	
	CFDictionaryRef dict = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys , (const void **)&values, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	CFRelease(glyphinfo);
	
	return [(NSDictionary *)dict autorelease];	
}

#else

-(NSDictionary *)platformRepresentation {
	return [NSDictionary dictionaryWithObject:[NSGlyphInfo glyphInfoWithCharacterIdentifier:self.characterIdentifier collection:self.characterCollection baseString:self.baseString] forKey:NSGlyphInfoAttributeName];
}

#endif

#pragma mark - MNCIntermediateObject Protocl

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return [(id)object isEqualToString:(NSString *)kCTGlyphInfoAttributeName];
#else
	return [(id)object isEqualToString:NSGlyphInfoAttributeName];
#endif
}

-(id)initWithAttributeName:(NSString *)attributeName value:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
#if TARGET_OS_IPHONE
	
	return [self initWithGlyph:(CTGlyphInfoRef)object baseString:[string.string substringWithRange:range]];
#else
	return [self initWithGlyph:object baseString:[string.string substringWithRange:range]];	
#endif
}

@end
