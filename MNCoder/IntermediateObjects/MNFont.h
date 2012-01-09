//
//  MNFont.h
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Foundation/Foundation.h>
#endif

#import "MNCIntermediateObjectProtocol.h"

@interface MNFont : NSObject <NSCoding, MNCIntermediateObjectProtocol>

@property (nonatomic, retain) NSString *fontName;
@property (readwrite) CGFloat size;

#if TARGET_OS_IPHONE
-(id)initWithFont:(UIFont *)font;
-(UIFont *)font;
#else 
-(id)initWithFont:(NSFont *)font;
-(NSFont *)font;
#endif

@end
