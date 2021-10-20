//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WDFoundation)

- (void)wd_insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)wd_removeObjectAtIndex:(NSUInteger)index;

- (void)wd_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end