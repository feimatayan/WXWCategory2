//
// Created by reeceran on 14-9-15.
// Copyright (c) 2014 reeceran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (WDFoundation)

/** Loops through an array and executes the given block with each object.
 
 @param block A single-argument, void-returning code block.
 */
- (void)wd_each:(void (^)(id obj))block;

/** Enumerates through an array concurrently and executes
 the given block once for each object.
 
 Enumeration will occur on appropriate background queues. This
 will have a noticeable speed increase, especially on dual-core
 devices, but you *must* be aware of the thread safety of the
 objects you message from within the block. Be aware that the
 order of objects is not necessarily the order each block will
 be called in.
 
 @param block A single-argument, void-returning code block.
 */
- (void)wd_apply:(void (^)(id obj))block;

/** Loops through an array to find the object matching the block.
 
 wd_match: is functionally identical to tb_select:, but will stop and return
 on the first match.
 
 @param block A single-argument, `BOOL`-returning code block.
 @return Returns the object, if found, or `nil`.
 @see wd_select:
 */
- (id)wd_match:(BOOL (^)(id obj))block;

/** Loops through an array to find the objects matching the block.
 
 @param block A single-argument, BOOL-returning code block.
 @return Returns an array of the objects found.
 @see wd_match:
 */
- (NSArray *)wd_select:(BOOL (^)(id obj))block;

/** Loops through an array to find the objects not matching the block.
 
 This selector performs *literally* the exact same function as wd_select: but in reverse.
 
 This is useful, as one may expect, for removing objects from an array.
 NSArray *new = [computers wd_reject:^BOOL(id obj) {
 return ([obj isUgly]);
 }];
 
 @param block A single-argument, BOOL-returning code block.
 @return Returns an array of all objects not found.
 */
- (NSArray *)wd_reject:(BOOL (^)(id obj))block;

/** Call the block once for each object and create an array of the return values.
 
 This is sometimes referred to as a transform, mutating one of each object:
 NSArray *new = [stringArray wd_map:^id(id obj) {
 return [obj stringByAppendingString:@".png"]);
 }];
 
 @param block A single-argument, object-returning code block.
 @return Returns an array of the objects returned by the block.
 */
- (NSArray *)wd_map:(id (^)(id obj))block;

/** Arbitrarily accumulate objects using a block.
 
 The concept of this selector is difficult to illustrate in words. The sum can
 be any NSObject, including (but not limited to) a string, number, or value.
 
 For example, you can concentate the strings in an array:
 NSString *concentrated = [stringArray tb_reduce:@"" withBlock:^id(id sum, id obj) {
 return [sum stringByAppendingString:obj];
 }];
 
 You can also do something like summing the lengths of strings in an array:
 NSUInteger value = [[[stringArray tb_reduce:nil withBlock:^id(id sum, id obj) {
 return @([sum integerValue] + obj.length);
 }]] unsignedIntegerValue];
 
 @param initial The value of the reduction at its start.
 @param block A block that takes the current sum and the next object to return the new sum.
 @return An accumulated value.
 */
- (id)wd_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block;

/** Loops through an array to find whether any object matches the block.
 
 This method is similar to the Scala list `exists`. It is functionally
 identical to tb_match: but returns a `BOOL` instead. It is not recommended
 to use tb_any: as a check condition before executing wd_match:, since it would
 require two loops through the array.
 
 For example, you can find if a string in an array starts with a certain letter:
 
 NSString *letter = @"A";
 BOOL containsLetter = [stringArray wd_any:^(id obj) {
 return [obj hasPrefix:@"A"];
 }];
 
 @param block A single-argument, BOOL-returning code block.
 @return YES for the first time the block returns YES for an object, NO otherwise.
 */
- (BOOL)wd_any:(BOOL (^)(id obj))block;

/** Loops through an array to find whether no objects match the block.
 
 This selector performs *literally* the exact same function as wd_all: but in reverse.
 
 @param block A single-argument, BOOL-returning code block.
 @return YES if the block returns NO for all objects in the array, NO otherwise.
 */
- (BOOL)wd_none:(BOOL (^)(id obj))block;

/** Loops through an array to find whether all objects match the block.
 
 @param block A single-argument, BOOL-returning code block.
 @return YES if the block returns YES for all objects in the array, NO otherwise.
 */
- (BOOL)wd_all:(BOOL (^)(id obj))block;

/** Tests whether every element of this array relates to the corresponding element of another array according to match by block.
 
 For example, finding if a list of numbers corresponds to their sequenced string values;
 NSArray *numbers = @[ @(1), @(2), @(3) ];
 NSArray *letters = @[ @"1", @"2", @"3" ];
 BOOL doesCorrespond = [numbers tb_corresponds:letters withBlock:^(id number, id letter) {
 return [[number stringValue] isEqualToString:letter];
 }];
 
 @param list An array of objects to compare with.
 @param block A two-argument, BOOL-returning code block.
 @return Returns a BOOL, true if every element of array relates to corresponding element in another array.
 */
- (BOOL)wd_corresponds:(NSArray *)list withBlock:(BOOL (^)(id obj1, id obj2))block;

/**
 Get reverse array
 */
- (NSArray *)wd_reverse;

/**
 Get new array without duplicate obj
 */
- (NSArray *)wd_unique;

/**
 safe get no index out of array
 */
- (id)wd_objectAtIndex:(NSUInteger)index;

#define WDObjectAtIndex(array,index) ([array wd_objectAtIndex:index])

@end

