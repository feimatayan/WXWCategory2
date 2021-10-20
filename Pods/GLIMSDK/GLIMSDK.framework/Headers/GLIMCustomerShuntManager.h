//
//  GLIMCustomerShuntManager.h
//  GLIMSDK
//
//  Created by jiakun on 2018/12/28.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLIMCustomerShuntManager : NSObject

+ (void)loadCustomerShuntConfigListcompletion:(void (^)(NSDictionary *dic))completion;

+ (void)setCustomerShuntConfigWithPam:(NSDictionary *)pam
                           completion:(void (^)(NSDictionary *dic))completion;

@end

NS_ASSUME_NONNULL_END
