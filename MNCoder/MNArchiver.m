//
//  MNArchiver.m
//  MNCoder
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 Jeremy Foo
//  
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

//

#import "MNArchiver.h"
#import "MNCIntermediateObjectProtocol.h"

#import "MNFont.h"
#import "MNColor.h"
#import "MNAttributedString.h"

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

-(void)setOutputFormat:(NSPropertyListFormat)_outputFormat {
    [__archiver setOutputFormat:_outputFormat];
}

-(NSPropertyListFormat)outputFormat {
    return __archiver.outputFormat;
}

#pragma mark - Instance Methods

-(void)encodeRootObject:(id)object {
    if (!encoded) {
        [__archiver encodeObject:object forKey:MNCoderRootObjectName];
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
