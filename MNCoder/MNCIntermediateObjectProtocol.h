//
//  MNCIntermediateObjectProtocol.h
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MNCIntermediateObjectProtocol <NSObject>
@required
+(NSArray *)subsituteClasses;
-(id)initWithSubsituteObject:(id)object;
-(id)platformRepresetnation;
@end