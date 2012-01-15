//
//  MNParagraphyStyle.h
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNParagraphyStyle : NSObject <NSCoding>

@property (readonly) NSUInteger alignment;
@property (readonly) CGFloat firstLineHeadIndent;
@property (readonly) CGFloat headIndent;
@property (readonly) CGFloat tailIndent;
// ADD tab stops
@property (readonly) CGFloat defaultTabInterval;
@property (readonly) CGFloat lineHeightMultiple;
@property (readonly) CGFloat maximumLineHeight;
@property (readonly) CGFloat minimumLineHeight;
@property (readonly) CGFloat lineSpacing;
@property (readonly) CGFloat paragraphSpacing;
@property (readonly) CGFloat paragraphSpacingBefore;

// ADD Text Blocks

@property (readonly) NSUInteger lineBreakMode;

// ADD hyphenationFactor
// ADD tighteningFactorForTruncation

@property (readonly) NSInteger baseWritingDirection;

#if TARGET_OS_IPHONE
-(id)initWithParagraphStyle:(CTParagraphStyleRef)paragraphStyle;
-(CTParagraphStyleRef)platformRepresentation;
#else
-(id)initwithParagraphStyle:(NSParagraphStyle *)paragraphStyle;
-(NSParagraphStyle *)platformRepresentation;
#endif

@end
