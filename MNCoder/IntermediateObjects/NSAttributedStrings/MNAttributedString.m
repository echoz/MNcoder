//
//  MNAttributedString.m
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNAttributedString.h"
#import "MNParagraphyStyle.h"
#import "MNGlyphInfo.h"

@interface MNAttributedString (/* Private Methods */)
-(void)_buildIntermediateRepresentationFromString:(NSAttributedString *)string;
-(NSDictionary *)_dictionaryForAttributes:(NSDictionary *)attrs range:(NSRange)aRange;

@end

@implementation MNAttributedString
@synthesize string = _string, attributes = _attributes;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_string = [[aDecoder decodeObjectForKey:@"string"] copy];
		_attributes = [[aDecoder decodeObjectForKey:@"attributes"] copy];
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
		[self _buildIntermediateRepresentationFromString:string];
	}
	
	return self;
}

-(NSAttributedString *)attributedString {

#if TARGET_OS_IPHONE
	// translate for iOS
#else
	// translate for Mac
	
#endif

	return nil;
}

-(void)_buildIntermediateRepresentationFromString:(NSAttributedString *)string {
	_string = [string.string copy];
	NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:0];

#if TARGET_OS_IPHONE
	[string enumerateAttributesInRange:NSMakeRange(0, [_string length]) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		
		
		
		[attributes insertObject:[self _dictionaryForAttributes:attrs range:range] atIndex:([attributes count]-1)];
	}];
#else
	[string enumerateAttributesInRange:NSMakeRange(0, [_string length]) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		NSMutableDictionary *finalAttributes = [NSMutableDictionary dictionaryWithCapacity:[attrs count]];
		
		for (NSString *key in attrs) {
			if ([[attrs objectForKey:key] isKindOfClass:[NSParagraphStyle class]]) {
				[finalAttributes setObject:[MNParagraphyStyle paragraphStyleWithStyle:[attrs objectForKey:key]] forKey:@"MNParagraphStyle"];
			} else {
				[finalAttributes setObject:[attrs objectForKey:key] forKey:key];
			}
		}
		
		[attributes insertObject:[self _dictionaryForAttributes:finalAttributes range:range] atIndex:(([attributes count] > 0)?([attributes count] - 1):0)];
	}];
	
#endif
	
	_attributes = [attributes copy];
}

-(void)dealloc {
	[_string release], _string = nil;
	[_attributes release], _string = nil;
	[super dealloc];
}

-(NSDictionary *)_dictionaryForAttributes:(NSDictionary *)attrs range:(NSRange)aRange {
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
	[dict setObject:[NSValue valueWithRange:aRange] forKey:@"range"];
	[dict setObject:attrs forKey:@"attrs"];
	
	return dict;
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
