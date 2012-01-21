//
//  MNGlyphInfo.m
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNGlyphInfo.h"

@implementation MNGlyphInfo
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

-(CTGlyphInfoRef)platformRepresentation {
	return CTGlyphInfoCreateWithCharacterIdentifier(self.characterIdentifier, self.characterCollection, (CFStringRef)self.baseString);
}

#else

-(NSGlyphInfo *)platformRepresentation {
	return [NSGlyphInfo glyphInfoWithCharacterIdentifier:self.characterIdentifier collection:self.characterCollection baseString:self.baseString];
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

-(id)initWithSubsituteObject:(void *)object {
#if TARGET_OS_IPHONE
	CFDictionaryRef userinfo = object;
	CTGlyphInfoRef glyph = CFDictionaryGetValue(userinfo, (CFStringRef)@"glyph");
	NSString *baseString = (NSString *)CFDictionaryGetValue(userinfo, (CFStringRef)@"baseString");
	
	return [self initWithGlyph:glyph baseString:baseString];
#else
	NSDictionary *userinfo = (id)object;
	return [self initWithGlyph:[userinfo objectForKey:@"glyph"] baseString:[userinfo objectForKey:@"baseString"]];	
#endif
}

@end
