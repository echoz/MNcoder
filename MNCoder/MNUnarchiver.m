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
	__unarchiver.delegate = nil;
	[__unarchiver release], __unarchiver = nil;
	[super dealloc];
}

#pragma mark - Instance Methods
-(id)decodedRootObject {
	if (!_decodedObject) {
		NSDictionary *rootDict = [__unarchiver decodeObjectForKey:MNCoderRootObjectName];
		[__unarchiver finishDecoding];
		
		_decodedObject = [[rootDict objectForKey:MNCoderRootObjectName] retain];
		
	}
    
    return _decodedObject;
}

#pragma mark - Static Methods

+(id)unarchiveObjectWithData:(NSData *)data {
    MNUnarchiver *unarchiver = [[MNUnarchiver alloc] initForReadingWithData:data];
    [unarchiver registerSubstituteClass:[MNFont class]];
    [unarchiver registerSubstituteClass:[MNColor class]];
	[unarchiver registerSubstituteClass:[MNAttributedString class]];
    
	id decodedObject = [unarchiver decodedRootObject];
	[unarchiver release];
	
    return decodedObject;
}

+(id)unarchiveObjectWithFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
        return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [MNUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - NSKeyedUnarchiver Delegate Methods

-(Class)unarchiver:(NSKeyedUnarchiver *)unarchiver cannotDecodeObjectOfClassName:(NSString *)name originalClasses:(NSArray *)classNames {
    NSLog(@"Class %@ does not exist for this platform -> %@", name, classNames);
    return nil;
}

-(id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object {
    
    for (Class cls in __subsituteClasses) {
        
        if ([object isKindOfClass:cls]) {
            return [object platformRepresentation];
        }
    }
    
	return object;
}

@end
