//
//  MNASVerticalForms.m
//  Mac
//
//  Created by Jeremy Foo on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNASVerticalForms.h"

@implementation MNASVerticalForms
@synthesize enabled = _enabled;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		_enabled = [aDecoder decodeBoolForKey:@"enabled"];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeBool:self.enabled forKey:@"enabled"];
}

#pragma mark - MNAttributedStringAttribute Protocol

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return [(id)object isEqualToString:(NSString *)kCTVerticalFormsAttributeName];
#else
	return [(id)object isEqualToString:NSVerticalGlyphFormAttributeName];
#endif
}

-(id)initWithObject:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	if ((self = [super init])) {
		
#if TARGET_OS_IPHONE
		if ((CFBooleanRef)object == kCFBooleanTrue) {
			_enabled = YES;
		} else {
			_enabled = NO;			
		}
#else
		_enabled = [(NSNumber *)object boolValue];
#endif
	}	
	return self;
}

-(NSDictionary *)platformRepresentation {
#if TARGET_OS_IPHONE
	CFBooleanRef verticalFormsEnabled;
	if (_enabled) {
		verticalFormsEnabled = kCFBooleanTrue;
	} else {
		verticalFormsEnabled = kCFBooleanFalse;
	}
	
	CFStringRef keys[] = { kCTVerticalFormsAttributeName };
	CFTypeRef values[] = { verticalFormsEnabled };
	
	return [(NSDictionary *)CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys , (const void **)&values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks) autorelease];	
#else
	return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:self.enabled] forKey:NSVerticalGlyphFormAttributeName];
#endif
}


@end