//
//  GLDIYActionSheet.h
//  GLUIKit
//
//  Created by smallsao on 2021/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLDIYActionSheet : NSObject
+ (void)show:(NSString *)title msg:(NSString *)msg content:(nullable UIView *)view actions:(NSArray *)actions cancel:(NSDictionary *)cancel;

@end

NS_ASSUME_NONNULL_END
