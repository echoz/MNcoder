//
//  MNArchiver.h
//  Mac
//
//  Created by Jeremy Foo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNArchiver : NSObject <NSKeyedArchiverDelegate> {
@private
	NSKeyedArchiver *__archiver;
    NSMutableSet *__subsituteClasses;    
}
-(id)initForWritingWithMutableData:(NSMutableData *)data;
-(void)registerSubstituteClass:(Class)cls;
-(void)unregisterSubtituteClass:(Class)cls;
@end
