//
//  MNUnarchiver.m
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

#ifndef __has_feature
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#import "MNUnarchiver.h"
#import "MNCIntermediateObjectProtocol.h"

// preconfigured intermediate objects
#import "MNFont.h"
#import "MNColor.h"
#import "MNAttributedString.h"

@implementation MNUnarchiver
@synthesize decodedRootObject=_decodedRootObject;

#pragma mark - Object Life Cycle

-(id)init {
	NSAssert(YES, @"Use initForReadingWithData: instead of init", nil);
	return nil;
}

-(id)initForReadingWithData:(NSData *)data {
	if ((self = [super init])) {
		__unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		__unarchiver.delegate = self;
		_decodedRootObject = nil;
	}
	return self;
}

-(void)dealloc {
	[_decodedRootObject release], _decodedRootObject = nil;
    [__unarchiver release], __unarchiver = nil;
	[super dealloc];
}

#pragma mark - Instance Methods
-(id)decodedRootObject {
	if (!_decodedRootObject) {
		_decodedRootObject = [[__unarchiver decodeObjectForKey:MNCoderRootObjectName] retain];

        // after finishing the decode, the unarchiver can't be used anymore,
        // lets proactively release it to reclaim memory.
		[__unarchiver finishDecoding];
        [__unarchiver release], __unarchiver = nil;
    }
    
    id test = [[_decodedRootObject retain] autorelease];
    
    return test;
}

#pragma mark - Static Methods

+(id)unarchiveObjectWithData:(NSData *)data {
    MNUnarchiver *unarchiver = [[[MNUnarchiver alloc] initForReadingWithData:data] autorelease];
    [unarchiver registerSubstituteClass:[MNFont class]];
    [unarchiver registerSubstituteClass:[MNColor class]];
	[unarchiver registerSubstituteClass:[MNAttributedString class]];
    
    return [[[unarchiver decodedRootObject] retain] autorelease];
}

+(id)unarchiveObjectWithFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
        return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    id unarchivedObj = [MNUnarchiver unarchiveObjectWithData:data];
    
    return [[unarchivedObj retain] autorelease];
}

#pragma mark - NSKeyedUnarchiver Delegate Methods

-(Class)unarchiver:(NSKeyedUnarchiver *)unarchiver cannotDecodeObjectOfClassName:(NSString *)name originalClasses:(NSArray *)classNames {
    NSString *platformName;
    
#if TARGET_OS_IPHONE
    platformName = @"TARGET_OS_IPHONE";
#else
    platformName = @"TARGET_OS_MAC";
#endif
    
    NSLog(@"Class %@ does not exist for this platform (%@) -> %@", name, platformName, classNames);
    return nil;
}

-(id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object NS_RETURNS_RETAINED {
    
    for (Class cls in __subsituteClasses) {
        
        if ([object isKindOfClass:cls]) {
            id platformRepresentation = [[object platformRepresentation] retain];
            [object release];
            
            // NSKeyedUnarchiver does not retain the replacement object thus a temp workaround with analyzer warning
            // is not to autorelease it.
            //
            // Checking Instruments using the leaks profiler shows that this does not leak at all. Adding the 
            // "autorelease" prior to returning will show you a nice backtrace in Instruments that will allow
            // inference that this is not retained upon the return.
            //
            // Will be filing a radar for this issue. (http://openradar.appspot.com/radar?id=1517414)
            return platformRepresentation;
        }
    }
    
	return object;
}

@end
