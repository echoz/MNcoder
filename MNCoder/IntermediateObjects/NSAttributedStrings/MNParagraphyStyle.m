//
//  MNParagraphyStyle.m
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNParagraphyStyle.h"

@implementation MNParagraphyStyle
@synthesize alignment = _alignment, firstLineHeadIndent = _firstLineHeadIndent, headIndent = _headIndent;
@synthesize tailIndent = _tailIndent, tabStops = _tabStops, defaultTabInterval = _defaultTabInterval, lineHeightMultiple = _lineHeightMultiple;
@synthesize maximumLineHeight = _maximumLineHeight, minimumLineHeight = _minimumLineHeight, lineSpacing = _lineSpacing;
@synthesize paragraphSpacing = _paragraphSpacing, paragraphSpacingBefore = _paragraphSpacingBefore;
@synthesize lineBreakMode = _lineBreakMode, baseWritingDirection = _baseWritingDirection;

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	
}

#if TARGET_OS_IPHONE
-(id)initwithParagraphStyle:(CTParagraphStyleRef)paragraphStyle {
	if ((self = [super init])) {

	}
	return self;
}

-(CTParagraphStyleRef)platformRepresentation {
	return nil;
}

#else

-(id)initwithParagraphStyle:(NSParagraphStyle *)paragraphStyle {
	if ((self = [super init])) {
		
	}
	
	return self;
}

-(NSParagraphStyle *)platformRepresentation {
	return nil;
}

#endif

-(void)dealloc {
	[_tabStops release], _tabStops = nil;
	[super dealloc];
}

@end
