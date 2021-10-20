//
//  WDTNNetworkManager+Thor.h
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/11/7.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import "WDTNNetworkManager.h"


@class WDTNPerformTask;

@interface WDTNNetworkManager (Thor)

- (void)thor_processData:(NSData *)data
                    task:(WDTNPerformTask *)performTask
                response:(NSHTTPURLResponse *)response
                 cfError:(NSError *)cfError
             reSendBlock:(void(^)(WDTNPerformTask *, double))reSendBlock
                callback:(void(^)(NSDictionary *, NSError *))callback;

@end
