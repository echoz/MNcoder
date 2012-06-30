//
//  MNASParagraphyStyle.h
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

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreText/CoreText.h>
#endif

#import "MNAttributedString.h"

@interface MNASParagraphyStyle : NSObject <MNAttributedStringAttributeProtocol> {
@private
    NSUInteger _alignment;
    CGFloat _firstLineHeadIndent;
    CGFloat _headIndent;
    CGFloat _tailIndent;
    NSArray *_tabStops;
    CGFloat _defaultTabInterval;
    CGFloat _lineHeightMultiple;
    CGFloat _maximumLineHeight;
    CGFloat _minimumLineHeight;
    CGFloat _lineSpacing;
    CGFloat _paragraphSpacing;
    CGFloat _paragraphSpacingBefore;
    
    NSUInteger _lineBreakMode;
    CGFloat _hyphenationFactor;
    NSInteger _baseWritingDirection;

}

@property (readonly) NSUInteger alignment;
@property (readonly) CGFloat firstLineHeadIndent;
@property (readonly) CGFloat headIndent;
@property (readonly) CGFloat tailIndent;
@property (readonly) NSArray *tabStops;
@property (readonly) CGFloat defaultTabInterval;
@property (readonly) CGFloat lineHeightMultiple;
@property (readonly) CGFloat maximumLineHeight;
@property (readonly) CGFloat minimumLineHeight;
@property (readonly) CGFloat lineSpacing;
@property (readonly) CGFloat paragraphSpacing;
@property (readonly) CGFloat paragraphSpacingBefore;

// ADD Text Blocks

@property (readonly) NSUInteger lineBreakMode;
@property (readonly) CGFloat hyphenationFactor;

// ADD tighteningFactorForTruncation

@property (readonly) NSInteger baseWritingDirection;

@end
