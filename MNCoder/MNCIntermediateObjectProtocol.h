//
//  MNKeyedArchiver.h
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MNCIntermediateObjectProtocol <NSObject>
@required
-(id)platformRepresetnation;
@end