//
//  GLIMSystemMessageShowManager.h
//  GLIMSDK
//
//  Created by jiakun on 2019/7/15.
//  Copyright © 2019 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLIMSystemMessageShowManager : NSObject

+ (void)loadSystemMessageShowConfigListcompletion:(void (^)(NSDictionary *dic))completion;
+ (void)setSystemMessageShowConfigWithPam:(NSDictionary *)pam completion:(void (^)(NSDictionary *dic))completion;


+ (void)loadCustomerSystemMessageShowConfigListWithList:(NSString *)list completion:(void (^)(NSDictionary *dic))completion;
+ (void)setCustomerSystemMessageShowConfigWithPam:(NSDictionary *)pam
                                       completion:(void (^)(NSDictionary *dic))completion;


+ (void)loadCustomerUserOwnerGroupLisCompletion:(void (^)(NSDictionary *dic))completion;

@end

NS_ASSUME_NONNULL_END
