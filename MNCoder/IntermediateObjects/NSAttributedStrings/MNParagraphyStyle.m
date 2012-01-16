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
		_tabStops = [[aDecoder decodeObjectForKey:@"tabStops"] copy];
		_alignment = [[aDecoder decodeObjectForKey:@"alignment"] unsignedIntegerValue];
		_lineBreakMode = [[aDecoder decodeObjectForKey:@"lineBreakMode"] unsignedIntegerValue];
		_baseWritingDirection = [[aDecoder decodeObjectForKey:@"baseWritingDirection"] unsignedIntegerValue];
		
		_firstLineHeadIndent = [aDecoder decodeFloatForKey:@"firstLineHeadIdent"];
		_headIndent = [aDecoder decodeFloatForKey:@"headIndent"];
		_tailIndent = [aDecoder decodeFloatForKey:@"tailIndent"];
		_defaultTabInterval = [aDecoder decodeFloatForKey:@"defaultTabInterval"];
		_lineHeightMultiple = [aDecoder decodeFloatForKey:@"lineHeightMultiple"];
		_maximumLineHeight = [aDecoder decodeFloatForKey:@"maximumLineHeight"];
		_minimumLineHeight = [aDecoder decodeFloatForKey:@"minimumLineHeight"];
		_lineSpacing = [aDecoder decodeFloatForKey:@"lineSpacing"];
		_paragraphSpacing = [aDecoder decodeFloatForKey:@"paragraphSpacing"];
		_paragraphSpacingBefore = [aDecoder decodeFloatForKey:@"paragraphSpacingBefore"];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.tabStops forKey:@"tabStops"];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.alignment] forKey:@"alignment"];
	
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.lineBreakMode] forKey:@"lineBreakMode"];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.baseWritingDirection] forKey:@"baseWritingDirection"];
	
	[aCoder encodeFloat:self.firstLineHeadIndent forKey:@"firstLineHeadIdent"];
	[aCoder encodeFloat:self.headIndent forKey:@"headIndent"];
	[aCoder encodeFloat:self.tailIndent forKey:@"tailIndent"];
	[aCoder encodeFloat:self.defaultTabInterval forKey:@"defaultTabInterval"];
	[aCoder encodeFloat:self.lineHeightMultiple forKey:@"lineHeightMultiple"];
	[aCoder encodeFloat:self.maximumLineHeight forKey:@"maximumLineHeight"];
	[aCoder encodeFloat:self.minimumLineHeight forKey:@"minimumLineHeight"];
	[aCoder encodeFloat:self.lineSpacing forKey:@"lineSpacing"];
	[aCoder encodeFloat:self.paragraphSpacing forKey:@"paragraphSpacing"];
	[aCoder encodeFloat:self.paragraphSpacingBefore forKey:@"paragraphSpacingBefore"];
	
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
