//
//  MNAttributedString.h
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
#import "MNCIntermediateObjectProtocol.h"

extern NSString *const kMNAttributedStringAttributeAttributeKey;
extern NSString *const kMNAttributedStringAttributeRangeKey;

@protocol MNCAttributedStringAttributeProtocol <NSObject, NSCoding>
@required
-(NSDictionary *)platformRepresentation;
+(BOOL)isSubstituteForObject:(void *)object;
-(id)initWithAttributeName:(NSString *)attributeName value:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string;
@end

@interface MNCAttributedString : NSObject <MNCIntermediateObjectProtocol> {
@private
	NSMutableSet *__substituteClasses;
    
    NSString *_string;
    NSArray *_attributes;
}

@property (readonly) NSString *string;
@property (readonly) NSArray *attributes;

-(id)initWithAttributedString:(NSAttributedString *)string;
-(NSAttributedString *)attributedString;

-(void)registerSubstituteClass:(Class)cls;
-(void)unregisterSubtituteClass:(Class)cls;

+(BOOL)lossless;
+(void)setLossless:(BOOL)lossless;

#if TARGET_OS_IPHONE
+(BOOL)hasUIKitAdditions;
#endif

@end
