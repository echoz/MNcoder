//
//  MNArchiver.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNArchiver.h"
#import "MNCIntermediateObjectProtocol.h"

#import "MNFont.h"
#import "MNColor.h"
#import "MNAttributedString.h"

@implementation MNArchiver

#pragma mark - Object Life Cycle

-(id)initForWritingWithMutableData:(NSMutableData *)data {
	if ((self = [super initForWritingWithMutableData:data])) {
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

-(void)encodeObject:(id)object {
	
	id objectToEncode = object;
	
	for (Class cls in __subsituteClasses) {
		
		if ([cls isSubstituteForObject:object]) {
			objectToEncode = [[[cls alloc] initWithSubsituteObject:object] autorelease];
		}
    }
	
	[super encodeObject:objectToEncode];
}

@end
