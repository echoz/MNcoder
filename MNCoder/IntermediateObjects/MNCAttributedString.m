//
//  MNAttributedString.m
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

#import "MNCAttributedString.h"

#import "MNASParagraphyStyle.h"
#import "MNASGlyphInfo.h"
#import "MNASCharacterShape.h"
#import "MNASKern.h"
#import "MNASStrokeWidth.h"
#import "MNASLigature.h"
#import "MNASSuperScript.h"
#import "MNASUnderlineStyle.h"
#import "MNASForegroundColor.h"
#import "MNASStrokeColor.h"
#import "MNASUnderlineColor.h"
#import "MNASVerticalForms.h"
#import "MNASFont.h"

NSString *const kMNAttributedStringAttributeAttributeKey = @"kMNAttributedStringAttributeAttributeKey";
NSString *const kMNAttributedStringAttributeRangeKey = @"kMNAttributedStringAttributeRangeKey";

@interface MNCAttributedString (/* Private Methods */)
-(void)_buildIntermediateRepresentationFromString:(NSAttributedString *)string;
-(NSDictionary *)_dictionaryForAttributes:(NSDictionary *)attrs range:(NSRange)aRange;
+(NSRange)_rangeFromRangeDictionaryItem:(id)rangeItem;
+(NSString *)_rangeStringFromRange:(NSRange)range;
@end

@implementation MNCAttributedString
@synthesize string = _string, attributes = _attributes;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_string = [[aDecoder decodeObjectForKey:@"string"] copy];
		_attributes = [[aDecoder decodeObjectForKey:@"attributes"] copy];
		__substituteClasses = [[NSMutableSet setWithCapacity:0] retain];
        
        [self registerSubstituteClass:[MNASParagraphyStyle class]];
		[self registerSubstituteClass:[MNASGlyphInfo class]];
		[self registerSubstituteClass:[MNASCharacterShape class]];
		[self registerSubstituteClass:[MNASKern class]];
		[self registerSubstituteClass:[MNASLigature class]];
		[self registerSubstituteClass:[MNASStrokeWidth class]];
		[self registerSubstituteClass:[MNASSuperScript class]];
		[self registerSubstituteClass:[MNASUnderlineStyle class]];
		[self registerSubstituteClass:[MNASForegroundColor class]];
		[self registerSubstituteClass:[MNASStrokeColor class]];
		[self registerSubstituteClass:[MNASUnderlineColor class]];
		[self registerSubstituteClass:[MNASVerticalForms class]];
		[self registerSubstituteClass:[MNASFont class]];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.string forKey:@"string"];
	[aCoder encodeObject:self.attributes forKey:@"attributes"];
}

#pragma mark - Platform specific representation

-(id)initWithAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		__substituteClasses = [[NSMutableSet setWithCapacity:0] retain];
		
		[self registerSubstituteClass:[MNASParagraphyStyle class]];
		[self registerSubstituteClass:[MNASGlyphInfo class]];
		[self registerSubstituteClass:[MNASCharacterShape class]];
		[self registerSubstituteClass:[MNASKern class]];
		[self registerSubstituteClass:[MNASLigature class]];
		[self registerSubstituteClass:[MNASStrokeWidth class]];
		[self registerSubstituteClass:[MNASSuperScript class]];
		[self registerSubstituteClass:[MNASUnderlineStyle class]];
		[self registerSubstituteClass:[MNASForegroundColor class]];
		[self registerSubstituteClass:[MNASStrokeColor class]];
		[self registerSubstituteClass:[MNASUnderlineColor class]];
		[self registerSubstituteClass:[MNASVerticalForms class]];
		[self registerSubstituteClass:[MNASFont class]];

		[self _buildIntermediateRepresentationFromString:string];
	}
	
	return self;
}

-(NSAttributedString *)attributedString {
	NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:self.string];
    id attributeObj = nil;
    id attributeToInsert = nil;
    
#if TARGET_OS_IPHONE
    NSRange range;
#endif

	for (NSDictionary *dict in self.attributes) {

        attributeObj = [dict objectForKey:kMNAttributedStringAttributeAttributeKey];
        
        if ([attributeObj conformsToProtocol:@protocol(MNCAttributedStringAttributeProtocol)]) {
            attributeToInsert = [attributeObj platformRepresentation];
        } else {
            attributeToInsert = attributeObj;
        }

#if TARGET_OS_IPHONE
	// translate for iOS
        range = [[self class] _rangeFromRangeDictionaryItem:[dict objectForKey:kMNAttributedStringAttributeRangeKey]];
		CFAttributedStringSetAttributes((CFMutableAttributedStringRef)aString, CFRangeMake(range.location, range.length) , (CFDictionaryRef)attributeToInsert, false);
	
#else
	// translate for Mac
		[aString addAttributes:attributeToInsert range:[[self class] _rangeFromRangeDictionaryItem:[dict objectForKey:kMNAttributedStringAttributeRangeKey]]];
#endif
	}

	return [aString autorelease];
}

-(Class)_substituteClassForObject:(void *)object {
	for (Class cls in __substituteClasses) {
		if ([cls isSubstituteForObject:object]) {
			return cls;
		}
	 }
	return nil;	
}

-(void)_buildIntermediateRepresentationFromString:(NSAttributedString *)string {
	_string = [string.string copy];
	NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:0];
	[attributes addObject:[NSNull null]];

	[string enumerateAttributesInRange:NSMakeRange(0, [_string length]) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		
		Class subsituteClass = nil;
		id subsituteObject = nil;
		
        NSUInteger idx = 0;
        
		for (NSString *key in attrs) {
			subsituteClass = [self _substituteClassForObject:key];
			if (subsituteClass) {
				subsituteObject = [[subsituteClass alloc] initWithAttributeName:key value:[attrs objectForKey:key] range:range forAttributedString:string];
				[attributes insertObject:[self _dictionaryForAttributes:subsituteObject range:range] atIndex:([attributes count]-1)];
				[subsituteObject release], subsituteObject = nil;
			} else {
				NSLog(@"Attribute not translated ->> (%@): %@", key, [attrs objectForKey:key]);
				
				if (([MNCAttributedString lossless]) && ([[attrs objectForKey:key] conformsToProtocol:@protocol(NSCoding)])) {
					[attributes insertObject:[self _dictionaryForAttributes:[NSDictionary dictionaryWithObject:[attrs objectForKey:key] forKey:key] range:range] atIndex:([attributes count]-1)];
				}
			}
            idx++;
		}
	}];

	[attributes removeLastObject];
    [_attributes release], _attributes = nil;
    
	_attributes = [attributes copy];
}

-(void)dealloc {
	[__substituteClasses release], __substituteClasses = nil;
	[_string release], _string = nil;
	[_attributes release], _string = nil;
	[super dealloc];
}

-(NSDictionary *)_dictionaryForAttributes:(NSDictionary *)attrs range:(NSRange)aRange {
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dict setObject:[[self class] _rangeStringFromRange:aRange]
             forKey:kMNAttributedStringAttributeRangeKey];    
	[dict setObject:attrs forKey:kMNAttributedStringAttributeAttributeKey];
	
	return dict;
}

#pragma mark - Deal with NSRange

+(NSRange)_rangeFromRangeDictionaryItem:(id)rangeItem {
    if ([rangeItem isKindOfClass:[NSString class]]) {
        return NSRangeFromString(rangeItem);
    } else if ([rangeItem isKindOfClass:[NSValue class]]) {
        return [rangeItem rangeValue];
    } else {
        return NSMakeRange(0, 0);
    }
}

+(NSString *)_rangeStringFromRange:(NSRange)range {
    return NSStringFromRange(range);
}

#pragma mark - Substitute Class Methods
-(void)registerSubstituteClass:(Class)cls {
    if ([cls conformsToProtocol:@protocol(MNCAttributedStringAttributeProtocol)])
        [__substituteClasses addObject:cls];
}

-(void)unregisterSubtituteClass:(Class)cls {
    if ([cls conformsToProtocol:@protocol(MNCAttributedStringAttributeProtocol)])
        [__substituteClasses removeObject:cls];
}

#pragma mark - Detection of UIKit Additions

#if TARGET_OS_IPHONE
+(BOOL)hasUIKitAdditions {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedDescending);
}
#endif


#pragma mark - Lossy switch
static BOOL _MNAttributedStringLossless = YES;

+(BOOL)lossless {	
	return _MNAttributedStringLossless;
}

+(void)setLossless:(BOOL)lossless {
	_MNAttributedStringLossless = lossless;
}

#pragma mark - MNCIntermediateObject Protocol

-(id)initWithSubsituteObject:(void *)object {
	return [self initWithAttributedString:(id)object];
}

+(BOOL)isSubstituteForObject:(void *)object {
	return [(id)object isKindOfClass:[NSAttributedString class]];	
}


-(id)platformRepresentation {
	return [self attributedString];
}

@end
