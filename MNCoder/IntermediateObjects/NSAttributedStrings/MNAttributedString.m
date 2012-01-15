//
//  MNAttributedString.m
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNAttributedString.h"

@interface MNAttributedString (/* Private Methods */)
-(void)_buildIntermediateRepresentationFromString:(NSAttributedString *)string;
-(NSDictionary *)dictionaryForAttribute:(NSString *)attributeName value:(id<NSCoding>)value range:(NSRange)aRange;
@end

@implementation MNAttributedString
@synthesize string = _string, attributes = _attributes;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_string = [[aDecoder decodeObjectForKey:@"string"] copy];
		_attributes = [[aDecoder decodeObjectForKey:@"attributes"] retain];
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
	
#if TARGET_OS_IPHONE
	// translate for iOS
#else
	// translate for Mac
	
#endif
}

-(NSDictionary *)dictionaryForAttribute:(NSString *)attributeName value:(id<NSCoding>)value range:(NSRange)aRange {
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
	[dict setObject:attributeName forKey:@"attributeName"];
	[dict setObject:[NSValue valueWithRange:aRange] forKey:@"range"];
	[dict setObject:value forKey:@"value"];
	
	return dict;
}

#pragma mark - MNCIntermediateObject Protocol

-(id)initWithSubsituteObject:(id)object {
	return [self initWithAttributedString:object];
}

+(NSArray *)subsituteClasses {
	return [NSArray arrayWithObjects:@"NSAttributedString", nil];
}


-(id)platformRepresentation {
	return [self attributedString];
}

@end
