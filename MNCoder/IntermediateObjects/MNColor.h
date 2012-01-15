//
//  MNColor.h
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

@interface MNColor : NSObject <MNCIntermediateObjectProtocol>

@property (readonly) CGFloat red;
@property (readonly) CGFloat green;
@property (readonly) CGFloat blue;
@property (readonly) CGFloat alpha;

#if TARGET_OS_IPHONE
-(id)initWithColor:(UIColor *)color;
-(UIColor *)color;
#else 
-(id)initWithColor:(NSColor *)color;
-(NSColor *)color;
#endif

@end
