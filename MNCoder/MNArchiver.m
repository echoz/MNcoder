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
	__resultData = [[NSMutableData dataWithCapacity:0] retain];
	return [self initForWritingWithMutableData:__resultData];
}

-(id)initForWritingWithMutableData:(NSMutableData *)data {
	if ((self = [super init])) {
		__archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		__archiver.delegate = self;
	}
	
	return self;
}

-(void)dealloc {
	[__resultData release], __resultData = nil;
	
	__archiver.delegate = nil;
	[__archiver release], __archiver = nil;
	[super dealloc];
}

#pragma mark - NSKeyedArchiver Delegate Methods

-(id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
	return nil;
}

@end
