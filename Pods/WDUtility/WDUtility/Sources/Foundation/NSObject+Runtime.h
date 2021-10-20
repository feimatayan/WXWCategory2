//
//  NSObject+Runtime.h
//  WDUtility
//
//  Created by HamGuy on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Runtime)

- (NSArray *)getAllIvar;

- (NSArray *)getAllProperty;

@end

NS_ASSUME_NONNULL_END
