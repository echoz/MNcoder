//
//  MNArchiver.h
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCoder.h"

@interface MNArchiver : MNCoder <NSKeyedArchiverDelegate> {
@private
	NSKeyedArchiver *__archiver;
}
-(id)initForWritingWithMutableData:(NSMutableData *)data;
@end
