//
//  MNCoder.h
//  iOS
//
//  Created by Jeremy Foo on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNCoder : NSObject {
    NSMutableSet *__subsituteClasses;
}
-(void)registerSubstituteClass:(Class)cls;
-(void)unregisterSubtituteClass:(Class)cls;
@end
