//
//  GLIPUTUtil.h
//  GLImagePicker
//
//  Created by zhangylong on 2021/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLIPUTUtil : NSObject


+ (NSString *)getCuid;

+ (NSString *)getSuid;

+ (void)commitEvent:(NSString *)eventId args:(NSDictionary *)args;

+ (void)commitTechEvent:(NSString *)pageName
                   arg1:(NSString *)arg1
                   arg2:(NSString *)arg2
                   arg3:(NSString *)arg3
                   args:(NSDictionary *)args;

@end

NS_ASSUME_NONNULL_END
