//
//  MNUnarchiver.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNUnarchiver.h"
#import "MNCIntermediateObjectProtocol.h"

@implementation MNUnarchiver

#pragma mark - Object Life Cycle

-(id)init {
	NSAssert(YES, @"Use initForReadingWithData: instead of init", nil);
	return nil;
}

-(id)initForReadingWithData:(NSData *)data {
	if ((self = [super init])) {
		__unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		__unarchiver.delegate = self;
	}
	return self;
}

-(void)dealloc {
	__unarchiver.delegate = nil;
	[__unarchiver release], __unarchiver = nil;
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

#pragma mark - NSKeyedUnarchiver Delegate Methods

-(id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object {
    NSString *objClassName = NSStringFromClass([object class]);
    
    for (Class cls in __subsituteClasses) {
        if ([NSStringFromClass(cls) isEqualToString:objClassName]) {
            return [object platformRepresetnation];
        }
    }
    
	return object;
}

@end
