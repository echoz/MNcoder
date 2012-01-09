//
//  MNCoder.m
//  iOS
//
//  Created by Jeremy Foo on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCoder.h"
#import "MNCIntermediateObjectProtocol.h"

@implementation MNCoder

#pragma mark - Object Life Cycle

-(id)init {
    if ((self = [super init])) {
        __subsituteClasses = [[NSMutableSet setWithCapacity:0] retain];
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

@end
