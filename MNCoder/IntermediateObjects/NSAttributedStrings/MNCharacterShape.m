//
//  MNCharacterShape.m
//  Mac
//
//  Created by Jeremy Foo on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MNCharacterShape.h"

@implementation MNCharacterShape
@synthesize shapeType = _shapeType;

+(BOOL)isSubstituteForObject:(void *)object {
	
}

-(id)initWithObject:(void *)object range:(NSRange)range forAttributedString:(NSAttributedString *)string {
	
}

-(NSDictionary *)platformRepresentation {
	
}

-(void)dealloc {
	[_shapeType release], _shapeType = nil;
	[super dealloc];
}


@end
