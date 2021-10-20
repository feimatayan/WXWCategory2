//
//  GLDIYAlert.h
//  GLUIKit
//
//  Created by smallsao on 2021/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLDIYAlert : NSObject
+ (void)show:(NSString *)title msg:(NSString *)msg content:(nullable UIView *)view actions:(NSArray *)actions;
@end

NS_ASSUME_NONNULL_END
