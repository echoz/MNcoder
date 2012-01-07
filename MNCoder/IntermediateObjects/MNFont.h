//
//  MNFont.h
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#ifdef TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Foundation/Foundation.h>
#endif

@interface MNFont : NSObject <NSCoding>

@property (nonatomic, retain) NSString *familyName;
@property (readwrite) CGFloat size;

#ifdef TARGET_OS_IPHONE
-(UIFont *)font;
#else 
-(NSFont *)font;
#endif

@end
