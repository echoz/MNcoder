//
//  MNUnarchiver.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNUnarchiver.h"
#import "MNCIntermediateObjectProtocol.h"

// preconfigured intermediate objects
#import "MNFont.h"
#import "MNColor.h"
#import "MNAttributedString.h"

@implementation MNUnarchiver

#pragma mark - Object Life Cycle

#pragma mark - Object Life Cycle

-(id)initForReadingWithData:(NSData *)data {
	if ((self = [super initForReadingWithData:data])) {
		__subsituteClasses = [[NSMutableSet setWithCapacity:3] retain];
		[self registerSubstituteClass:[MNFont class]];
		[self registerSubstituteClass:[MNColor class]];
		[self registerSubstituteClass:[MNAttributedString class]];
		
	}
	return self;
}

-(void)dealloc {
    [__subsituteClasses release], __subsituteClasses = nil;
    [super dealloc];
}

#pragma mark - Instance Methods
-(void)registerSubstituteClass:(Class)cls {	
    if ([cls conformsToProtocol:@protocol(MNCIntermediateObjectProtocol)])
        [__subsituteClasses addObject:cls];
}

-(void)unregisterSubtituteClass:(Class)cls {
    if ([cls conformsToProtocol:@protocol(MNCIntermediateObjectProtocol)])
        [__subsituteClasses removeObject:cls];
}

#pragma mark - Override

-(id)decodeObjectForKey:(NSString *)key {
	id object = [super decodeObjectForKey:key];
	
	if (object) {
		for (Class cls in __subsituteClasses) {
			
			if ([object isKindOfClass:cls]) {
				return [object platformRepresentation];
			}
		}
		
		return object;		
	} else {
		return nil;		
	}
}

@end
