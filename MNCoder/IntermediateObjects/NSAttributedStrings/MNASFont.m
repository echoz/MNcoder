//
//  MNASFont.m
//  MNCoder
//
//  Created by Jeremy Foo on 1/23/12.
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
	return (([(id)object isEqualToString:(NSString *)kCTFontAttributeName]) || ([(id)object isEqualToString:NSFontAttributeName]));
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

-(id)initWithAttributeName:(NSString *)attributeName value:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
#if TARGET_OS_IPHONE
        
        CTFontDescriptorRef fontDesc;
        
        if ([MNCAttributedString hasUIKitAdditions]) {
            if ([attributeName isEqualToString:NSFontAttributeName]) {
                UIFont *theFont = (UIFont *)object;
                                
                CFStringRef desckeys[] = { kCTFontNameAttribute, kCTFontSizeAttribute };
                CFTypeRef descvalues[] = { (CFStringRef)theFont.fontName, (CFNumberRef)[NSNumber numberWithFloat:theFont.pointSize] };
                CFDictionaryRef descDict = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&desckeys , (const void **)&descvalues, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
                
                fontDesc = CTFontDescriptorCreateWithAttributes(descDict);
                CFRelease(descDict);
                
            } else {
                fontDesc = CTFontCopyFontDescriptor(object);
            }
        } else {
            fontDesc = CTFontCopyFontDescriptor(object);
        }
        		
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
		
		_fontName = (NSString *)CTFontCopyPostScriptName(object);

		_size = ((NSFont *)object).pointSize;
		
		_baseLineAdjustment = [[self _valueForAttribute:NSBaselineOffsetAttributeName atRange:range forAttributedString:string] copy];
		_obliqueness = [[self _valueForAttribute:NSObliquenessAttributeName atRange:range forAttributedString:string] copy];
		_expansion = [[self _valueForAttribute:NSExpansionAttributeName atRange:range forAttributedString:string] copy];
		
#endif
		// set default values if they are not filled in
		
		if (!_baseLineAdjustment)
			_baseLineAdjustment = [[NSNumber numberWithFloat:0.0] retain];
		
		if (!_obliqueness)
			_obliqueness = [[NSNumber numberWithFloat:0.0] retain];
		
		if (!_expansion)
			_expansion = [[NSNumber numberWithFloat:0.0] retain];
		
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
    
    CFStringRef traitskeys[] = { kCTFontSlantTrait, kCTFontWidthTrait };
    CFTypeRef traitsvalues[] = { (CFNumberRef)self.obliqueness, (CFNumberRef)self.expansion };

    CFDictionaryRef traitsDict = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&traitskeys , (const void **)&traitsvalues, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFStringRef desckeys[] = { kCTFontNameAttribute, kCTFontBaselineAdjustAttribute, kCTFontTraitsAttribute };
    CFTypeRef descvalues[] = { (CFStringRef)self.fontName, (CFNumberRef)self.baseLineAdjustment, traitsDict };
    
    CFDictionaryRef descDict = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&desckeys , (const void **)&descvalues, 3, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes(descDict);
    CFRelease(traitsDict);
    CFRelease(descDict);
    
    CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, self.size, NULL);
    
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    
    NSDictionary *platformRepresentation = (NSDictionary *)CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys , (const void **)&values, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFRelease(descriptor);
    CFRelease(font);

    return [platformRepresentation autorelease];

#else
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
	if (self.baseLineAdjustment)
		[dict setObject:self.baseLineAdjustment forKey:NSBaselineOffsetAttributeName];
	if (self.obliqueness)
		[dict setObject:self.obliqueness forKey:NSObliquenessAttributeName];
	if (self.expansion)
		[dict setObject:self.expansion forKey:NSExpansionAttributeName];
	
	CFStringRef desckeys[] = { kCTFontNameAttribute  };
	CFTypeRef descvalues[] = { (CFStringRef)self.fontName };
	
	CFDictionaryRef descDict = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&desckeys , (const void **)&descvalues, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes(descDict);
	CFRelease(descDict);

	CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, self.size, NULL);
	CFRelease(descriptor);
	
	[dict setObject:(NSFont *)font forKey:NSFontAttributeName];
	CFRelease(font);
    
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