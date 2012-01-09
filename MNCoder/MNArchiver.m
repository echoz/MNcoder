//
//  MNArchiver.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNArchiver.h"
#import "MNCIntermediateObjectProtocol.h"

@implementation MNArchiver

#pragma mark - Object Life Cycle

-(id)init {
	NSAssert(YES, @"Use initForWritingWithMutableData: instead of init", nil);
	return nil;
}

-(id)initForWritingWithMutableData:(NSMutableData *)data {
	if ((self = [super init])) {
		__archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		__archiver.delegate = self;
        
        __subsituteClasses = [[NSMutableSet setWithCapacity:0] retain];
	}
	
	return self;
}

-(void)dealloc {	
    [__subsituteClasses release], __subsituteClasses = nil;
    
	__archiver.delegate = nil;
	[__archiver release], __archiver = nil;
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

#pragma mark - NSKeyedArchiver Delegate Methods

-(id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
    NSString *objClassName = NSStringFromClass([object class]);

    for (Class cls in __subsituteClasses) {
        if ([[cls subsituteClasses] indexOfObject:objClassName] != NSNotFound) {
            return [cls initWithSubsituteObject:object];
        }
    }
    
	return object;
}

@end
