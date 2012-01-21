//
//  MNParagraphyStyle.m
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNParagraphyStyle.h"
#import "MNTextTab.h"

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
+(id)paragraphStyleWithStyle:(CTParagraphStyleRef)paragraphStyle {
	return [[[self alloc] initWithParagraphStyle:paragraphStyle] autorelease];
}

-(id)initWithParagraphStyle:(CTParagraphStyleRef)paragraphStyle {
	if ((self = [super init])) {
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &_alignment);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineBreakMode, sizeof(NSUInteger), &_lineBreakMode);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(NSUInteger), &_baseWritingDirection);
		
		NSArray *tempTabStops;
		
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tempTabStops);
		
		NSMutableArray *mntexttabs = [NSMutableArray arrayWithCapacity:[tempTabStops count]];
		for (id tabStop in tempTabStops) {
			[mntexttabs addObject:[MNTextTab textTabWithTabStop:(CTTextTabRef)tabStop]];
		}
		_tabStops = [mntexttabs copy];		
		
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &_firstLineHeadIndent);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &_headIndent);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &_tailIndent);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), &_defaultTabInterval);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &_lineHeightMultiple);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &_maximumLineHeight);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &_minimumLineHeight);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &_lineSpacing);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &_paragraphSpacing);
		CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &_paragraphSpacingBefore);
	}
	return self;
}

-(CTParagraphStyleRef)platformRepresentation {

	NSMutableArray *tempTabStops = [NSMutableArray arrayWithCapacity:[self.tabStops count]];
	for (MNTextTab *textTab in self.tabStops) {
		CFArrayAppendValue((CFMutableArrayRef)tempTabStops, [textTab platformRepresentation]);
	}

	CTParagraphStyleSetting settings[] = {
		{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &_alignment },
		{ kCTParagraphStyleSpecifierLineBreakMode, sizeof(NSUInteger), &_lineBreakMode },
		{ kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(NSUInteger), &_baseWritingDirection },
		{ kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tempTabStops },
		
		{ kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &_firstLineHeadIndent },
		{ kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &_headIndent },
		{ kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &_tailIndent },
		{ kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), &_defaultTabInterval },
		{ kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &_lineHeightMultiple },
		{ kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &_maximumLineHeight },
		{ kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &_minimumLineHeight },
		{ kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &_lineSpacing },
		{ kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &_paragraphSpacing },
		{ kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &_paragraphSpacingBefore }

	};
	
	return CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(CTParagraphStyleSetting));
}

#else

+(id)paragraphStyleWithStyle:(NSParagraphStyle *)paragraphStyle {
	return [[self alloc] initWithParagraphStyle:paragraphStyle];
}

-(id)initWithParagraphStyle:(NSParagraphStyle *)paragraphStyle {
	if ((self = [super init])) {
		_alignment = paragraphStyle.alignment;
		_lineBreakMode = paragraphStyle.lineBreakMode;
		_baseWritingDirection = paragraphStyle.baseWritingDirection;

		NSMutableArray *mntexttabs = [NSMutableArray arrayWithCapacity:[paragraphStyle.tabStops count]];
		for (NSTextTab *tabStop in paragraphStyle.tabStops) {
			[mntexttabs addObject:[MNTextTab textTabWithTabStop:tabStop]];
		}
		_tabStops = [mntexttabs copy];		
		
		_firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
		_headIndent = paragraphStyle.headIndent;
		_tailIndent = paragraphStyle.tailIndent;
		_defaultTabInterval = paragraphStyle.defaultTabInterval;
		_lineHeightMultiple = paragraphStyle.lineHeightMultiple;
		_maximumLineHeight = paragraphStyle.maximumLineHeight;
		_minimumLineHeight = paragraphStyle.minimumLineHeight;
		_lineSpacing = paragraphStyle.lineSpacing;
		_paragraphSpacing = paragraphStyle.paragraphSpacing;
		_paragraphSpacingBefore = paragraphStyle.paragraphSpacingBefore;
		
	}
	
	return self;
}

-(NSParagraphStyle *)platformRepresentation {
	NSMutableParagraphStyle *platRep = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	
	platRep.alignment = self.alignment;
	platRep.lineBreakMode = self.lineBreakMode;
	platRep.baseWritingDirection = self.baseWritingDirection;
	
	NSMutableArray *tempTabStops = [NSMutableArray arrayWithCapacity:[self.tabStops count]];
	for (MNTextTab *textTab in self.tabStops) {
		[tempTabStops addObject:[textTab platformRepresentation]];
	}
	
	platRep.tabStops = tempTabStops;
	
	platRep.firstLineHeadIndent = self.firstLineHeadIndent;
	platRep.headIndent = self.headIndent;
	platRep.tailIndent = self.tailIndent;
	platRep.defaultTabInterval = self.defaultTabInterval;
	platRep.lineHeightMultiple = self.lineHeightMultiple;
	platRep.maximumLineHeight = self.maximumLineHeight;
	platRep.minimumLineHeight = self.minimumLineHeight;
	platRep.lineSpacing = self.lineSpacing;
	platRep.paragraphSpacing = self.paragraphSpacing;
	platRep.paragraphSpacingBefore = self.paragraphSpacingBefore;
	
	return [platRep autorelease];
}

#endif

-(void)dealloc {
	[_tabStops release], _tabStops = nil;
	[super dealloc];
}

#pragma mark - MNCIntermediateObject Protocl

+(BOOL)isSubstituteForObject:(void *)object {
#if TARGET_OS_IPHONE
	return [(id)object isEqualToString:(NSString *)kCTParagraphStyleAttributeName];
#else
	return [(id)object isEqualToString:NSParagraphStyleAttributeName];
#endif
}

-(id)initWithSubsituteObject:(void *)object {
#if TARGET_OS_IPHONE
	return [self initWithParagraphStyle:(CTParagraphStyleRef)object];
#else
	return [self initWithParagraphStyle:(id)object];
#endif
}

@end
