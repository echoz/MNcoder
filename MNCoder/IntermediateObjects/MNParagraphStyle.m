//
//  MNParagraphStyle.m
//  Mac
//
//  Created by Jeremy Foo on 11/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNParagraphStyle.h"

@implementation MNParagraphStyle

#pragma mark - NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        // process and decode into platform specific substitute
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    // process and encode into platform neutral subsitute.
}

#pragma mark - MNCIntermediateObject Protocol

-(id)initWithSubsituteObject:(id)object {
	return nil;
}

+(NSArray *)subsituteClasses {
	return [NSArray arrayWithObjects:@"NSParagraphStyle", nil];
}


-(id)platformRepresentation {
    return nil;
}

@end
