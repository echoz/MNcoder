//
//  MNAttributedString.h
//  Mac
//
//  Created by Jeremy Foo on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCIntermediateObjectProtocol.h"

@interface MNAttributedString : NSObject <MNCIntermediateObjectProtocol>

@property (readonly) NSString *string;
@property (readonly) NSArray *attributes;

-(id)initWithAttributedString:(NSAttributedString *)string;
-(NSAttributedString *)attributedString;

@end
