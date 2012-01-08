//
//  MNUnarchiver.m
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNUnarchiver.h"

@implementation MNUnarchiver

#pragma mark - Object Life Cycle

-(id)initForReadingWithData:(NSData *)data {
	if ((self = [super init])) {
		__unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	}
	return self;
}

-(void)dealloc {
	[__unarchiver release], __unarchiver = nil;
	[super dealloc];
}

@end
