//
//  WDTNUT.h
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/10/26.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WDTNPerformTask;

@interface WDTNUT : NSObject

+ (void)commitEvent:(NSString *)eventId args:(NSDictionary *)args;

+ (void)commitException:(NSString *)pageName
                   arg1:(NSString *)arg1
                   arg2:(NSString *)arg2
                   arg3:(NSString *)arg3
                   args:(NSDictionary *)args;

+ (void)commitThor:(BOOL)success
              task:(WDTNPerformTask *)task
          dataSize:(NSInteger)dataSize
            status:(NSDictionary *)status
             error:(NSError *)error;

+ (NSString *)getCuid;

+ (NSString *)getSuid;

@end
