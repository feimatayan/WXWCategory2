//
// Created by shazhou on 2018/7/12.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WDUT_ERROR_GZIP_FAILED 1000
#define WDUT_ERROR_SERIALIZE_FAILED 1001
#define WDUT_ERROR_DATA_EMPTY 1002
#define WDUT_ERROR_REQUEST_CANCELED 1003

@interface WDUTService : NSObject

+ (void)requestSuid:(NSDictionary *)info complete:(void (^)(BOOL isSuccess, NSDictionary *result, NSError *error))completeBlock;

+ (void)uploadLogs:(NSArray *)logArray complete:(void (^)(BOOL isSuccess, NSDictionary *result, NSError *error))completeBlock;

@end
