//
//  MNASFont.m
//  Mac
//
//  Created by Jeremy Foo on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNASFont.h"

@implementation MNASFont
@synthesize fontName = _fontName, size = _size, baseLineAdjustment = _baseLineAdjustment, obliqueness = _obliqueness, expansion = _expansion;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_fontName = [[aDecoder decodeObjectForKey:@"fontName"] retain];
		_size = [[aDecoder decodeObjectForKey:@"size"] floatValue];
		_baseLineAdjustment = [[aDecoder decodeObjectForKey:@"baselineAdjustment"] retain];
		_obliqueness = [[aDecoder decodeObjectForKey:@"obliqueness"] retain];
		_expansion = [[aDecoder decodeObjectForKey:@"expansion"] retain];

	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.fontName forKey:@"fontName"];
	[aCoder encodeObject:[NSNumber numberWithFloat:self.size] forKey:@"size"];
	[aCoder encodeObject:self.baseLineAdjustment forKey:@"baselineAdjustment"];
	[aCoder encodeObject:self.obliqueness forKey:@"obliqueness"];
	[aCoder encodeObject:self.expansion forKey:@"expansion"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return [(id)object isEqualToString:(NSString *)kCTFontAttributeName];
#else
	return [(id)object isEqualToString:NSFontAttributeName];
#endif
}

-(id)_valueForAttribute:(NSString *)attributeName atRange:(NSRange)theRange forAttributedString:(NSAttributedString *)string {
	__block id retValue = nil;
	
	[string enumerateAttribute:attributeName inRange:theRange options:NSAttributedStringEnumerationReverse usingBlock:^(id value, NSRange range, BOOL *stop) {
		if (NSEqualRanges(range, theRange)) {
			retValue = value;
			*stop = YES;
		}
	}];
	
	return retValue;
}

-(id)initWithObject:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
#if TARGET_OS_IPHONE
		CTFontDescriptorRef fontDesc = CTFontCopyFontDescriptor(object);
		
		_fontName = CTFontDescriptorCopyAttribute(fontDesc, kCTFontNameAttribute);
		_baseLineAdjustment = CTFontDescriptorCopyAttribute(fontDesc, kCTFontBaselineAdjustAttribute);
		
		CFNumberRef pointSize = CTFontDescriptorCopyAttribute(fontDesc, kCTFontSizeAttribute);
		_size = [(NSNumber *)pointSize floatValue];
		CFRelease(pointSize);
		
		CFDictionaryRef traits = CTFontDescriptorCopyAttribute(fontDesc, kCTFontTraitsAttribute);
		_obliqueness = CFDictionaryGetValue(traits, kCTFontSlantTrait);
		_expansion = CFDictionaryGetValue(traits, kCTFontWidthTrait);
		
		CFRetain(_obliqueness);
		CFRetain(_expansion);
		
		CFRelease(traits);		
		CFRelease(fontDesc);
		
#else
		_fontName = [((NSFont *)object).fontName copy];
		_size = ((NSFont *)object).pointSize;
		
		_baseLineAdjustment = [[self _valueForAttribute:NSBaselineOffsetAttributeName atRange:range forAttributedString:string] copy];
		_obliqueness = [[self _valueForAttribute:NSObliquenessAttributeName atRange:range forAttributedString:string] copy];
		_expansion = [[self _valueForAttribute:NSExpansionAttributeName atRange:range forAttributedString:string] copy];
		
		// set default values if they are not filled in
		
		if (!_baseLineAdjustment)
			_baseLineAdjustment = [[NSNumber numberWithFloat:0.0] retain];

		if (!_obliqueness)
			_obliqueness = [[NSNumber numberWithFloat:0.0] retain];

		if (!_expansion)
			_expansion = [[NSNumber numberWithFloat:0.0] retain];
		
#endif
		
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE

	CFStringRef traitskeys[] = { kCTFontSlantTrait, kCTFontWidthTrait };
	CFTypeRef traitsvalues[] = { (CFNumberRef)self.obliqueness, (CFNumberRef)self.expansion };

	CFDictionaryRef traitsDict = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&traitskeys , (const void **)&traitsvalues, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	
	CFStringRef desckeys[] = { kCTFontAttributeName, kCTFontBaselineAdjustAttribute, kCTFontTraitsAttribute };
	CFTypeRef descvalues[] = { (CFStringRef)self.fontName, (CFNumberRef)self.baseLineAdjustment, traitsDict };
	
	CFDictionaryRef descDict = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&desckeys , (const void **)&descvalues, 3, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes(descDict);
	CFRelease(traitsDict);
	CFRelease(descDict);
	
	CFStringRef keys[] = { kCTFontAttributeName };
	CFTypeRef values[] = { CTFontCreateWithFontDescriptor(descriptor, self.size, NULL) };
	
	return [(NSDictionary *)CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys , (const void **)&values, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks) autorelease];	
#else
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
	[dict setObject:self.baseLineAdjustment forKey:NSBaselineOffsetAttributeName];
	[dict setObject:self.obliqueness forKey:NSObliquenessAttributeName];
	[dict setObject:self.expansion forKey:NSExpansionAttributeName];
	[dict setObject:[NSFont fontWithName:self.fontName size:self.size] forKey:NSFontAttributeName];
	
	return dict;

#endif
}

-(void)dealloc {
	[_fontName release], _fontName = nil;
	[_baseLineAdjustment release], _baseLineAdjustment = nil;
	[_obliqueness release], _obliqueness = nil;
	[_expansion release], _expansion = nil;
	[super dealloc];
}


@end