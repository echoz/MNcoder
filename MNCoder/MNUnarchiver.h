//
//  MNUnarchiver.h
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCoder.h"

@interface MNUnarchiver : MNCoder <NSKeyedUnarchiverDelegate> {
@private
	NSKeyedUnarchiver *__unarchiver;
}
@property (readonly) id decodedObject;

+(id)unarchiveObjectWithData:(NSData *)data;
+(id)unarchiveObjectWithFile:(NSString *)path;

-(id)initForReadingWithData:(NSData *)data;
-(id)decodedRootObject;
@end
