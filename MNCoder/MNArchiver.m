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
@synthesize outputFormat = _outputFormat;

#pragma mark - Object Life Cycle

-(id)init {
	NSAssert(YES, @"Use initForWritingWithMutableData: instead of init", nil);
	return nil;
}

-(id)initForWritingWithMutableData:(NSMutableData *)data {
	if ((self = [super init])) {
		__archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		__archiver.delegate = self;
        encoded = NO;
    }
	
	return self;
}

-(void)dealloc {	
	__archiver.delegate = nil;
	[__archiver release], __archiver = nil;
	[super dealloc];
}

#pragma mark - Override Accessors

-(void)setOutputFormat:(NSPropertyListFormat)outputFormat {
    [__archiver setOutputFormat:outputFormat];
}

-(NSPropertyListFormat)outputFormat {
    return __archiver.outputFormat;
}

#pragma mark - Instance Methods

-(void)encodeRootObject:(id)object {
    if (!encoded) {
        NSDictionary *rootDict = [NSDictionary dictionaryWithObject:object forKey:MNCoderRootObjectName];
		NSLog(@"%@", rootDict);
        [__archiver encodeObject:rootDict forKey:MNCoderRootObjectName];
        [__archiver finishEncoding];
        encoded = YES;        
    }
}

#pragma mark - Static Methods

+(NSData *)archivedDataWithRootObject:(id)object {
    NSMutableData *resultData = [NSMutableData dataWithCapacity:0];
    
    MNArchiver *archiver = [[[MNArchiver alloc] initForWritingWithMutableData:resultData] autorelease];
    archiver.outputFormat = NSPropertyListBinaryFormat_v1_0;
    [archiver registerSubstituteClass:[MNFont class]];
    [archiver registerSubstituteClass:[MNColor class]];
	[archiver registerSubstituteClass:[MNAttributedString class]];
    
    [archiver encodeRootObject:object];
    
    return resultData;
}

+(BOOL)archiveRootObject:(id)object toFile:(NSString *)path {
    NSData *serializedData = [MNArchiver archivedDataWithRootObject:object];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        if (![fileManager isWritableFileAtPath:path])
            return NO;        
    } 
    
    return [serializedData writeToFile:path atomically:YES];
}

#pragma mark - NSKeyedArchiver Delegate Methods

-(id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
	//    NSLog(@"Object(%@): %@", NSStringFromClass([object class]), object);
    
    for (Class cls in __subsituteClasses) {
		
		if ([cls isSubstituteForObject:object]) {
			return [[[cls alloc] initWithSubsituteObject:object] autorelease];
		}
    }
    
	return object;
}

@end
