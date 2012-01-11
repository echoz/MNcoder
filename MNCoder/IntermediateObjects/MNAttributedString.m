//
//  MNAttributedString.m
//  Mac
//
//  Created by Jeremy Foo on 11/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNAttributedString.h"

@implementation MNAttributedString

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
}

#pragma mark - MNCIntermediateObject Protocol

-(id)initWithSubsituteObject:(id)object {
	return nil;
}

+(NSArray *)subsituteClasses {
	return [NSArray arrayWithObjects:@"NSAttributedString", nil];
}


-(id)platformRepresentation {
    return nil;
}

@end
