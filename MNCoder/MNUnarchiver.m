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
-(id)decodedRootObject {
    id root = [__unarchiver decodeObjectForKey:MNCoderRootObjectName];
    [__unarchiver finishDecoding];
    
    return root;
}

#pragma mark - Static Methods

+(id)unarchiveObjectWithData:(NSData *)data {
    MNUnarchiver *unarchiver = [[MNUnarchiver alloc] initForReadingWithData:data];
    [unarchiver registerSubstituteClass:[MNFont class]];
    [unarchiver registerSubstituteClass:[MNColor class]];
    
    return [unarchiver decodedRootObject];
}

+(id)unarchiveObjectWithFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
        return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [MNUnarchiver unarchiveObjectWithData:data];
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
