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

#import "MNUnarchiver.h"
#import "MNCIntermediateObjectProtocol.h"

// preconfigured intermediate objects
#import "MNFont.h"
#import "MNColor.h"
#import "MNAttributedString.h"

@implementation MNUnarchiver
@synthesize decodedObject = _decodedObject;

#pragma mark - Object Life Cycle

-(id)init {
	NSAssert(YES, @"Use initForReadingWithData: instead of init", nil);
	return nil;
}

-(id)initForReadingWithData:(NSData *)data {
	if ((self = [super init])) {
		__unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		__unarchiver.delegate = self;
		_decodedObject = nil;
	}
	return self;
}

-(void)dealloc {
	[_decodedObject release], _decodedObject = nil;
    [__unarchiver release], __unarchiver = nil;
	[super dealloc];
}

#pragma mark - Instance Methods
-(id)decodedRootObject {
	if (!_decodedObject) {
		_decodedObject = [[__unarchiver decodeObjectForKey:MNCoderRootObjectName] retain];
		[__unarchiver finishDecoding];
        [__unarchiver release], __unarchiver = nil;
        
        NSLog(@"%lu", [_decodedObject retainCount]);
	}
    
    id test = [[_decodedObject retain] autorelease];
    
    NSLog(@"%lu", [test retainCount]);
    
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
    NSLog(@"Class %@ does not exist for this platform -> %@", name, classNames);
    return nil;
}

-(id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object {
    
    for (Class cls in __subsituteClasses) {
        
        if ([object isKindOfClass:cls]) {
            id platformRepresentation = [[object platformRepresentation] retain];
            [object release];
            
            return [platformRepresentation autorelease];
        }
    }
    
	return object;
}

@end
