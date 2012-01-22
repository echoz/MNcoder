//
//  MNAttributedString.m
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNAttributedString.h"

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
		__substituteClasses = [[NSMutableSet setWithCapacity:0] retain];
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

#if TARGET_OS_IPHONE
	// translate for iOS
#else
	// translate for Mac
	
#endif

	return nil;
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

	[string enumerateAttributesInRange:NSMakeRange(0, [_string length]) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		
		Class subsituteClass = nil;
		id subsituteObject = nil;
		
		for (NSString *key in attrs) {
			subsituteClass = [self _substituteClassForObject:key];
			if (subsituteClass) {
				subsituteObject = [[subsituteClass alloc] initWithObject:[attrs objectForKey:key] range:range forAttributedString:string];
				[attributes insertObject:subsituteObject atIndex:([attributes count]-1)];
				[subsituteObject release], subsituteObject = nil;
			} else {
				NSLog(@"Attribute not translated ->> (%@): %@", key, [attrs objectForKey:key]);
			}
		}
	}];

	
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
	[dict setObject:[NSValue valueWithRange:aRange] forKey:@"range"];
	[dict setObject:attrs forKey:@"attrs"];
	
	return dict;
}

#pragma mark - Substitute Class Methods
-(void)registerSubstituteClass:(Class)cls {
    if ([cls conformsToProtocol:@protocol(MNCIntermediateObjectProtocol)])
        [__substituteClasses addObject:cls];
}

-(void)unregisterSubtituteClass:(Class)cls {
    if ([cls conformsToProtocol:@protocol(MNCIntermediateObjectProtocol)])
        [__substituteClasses removeObject:cls];
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
