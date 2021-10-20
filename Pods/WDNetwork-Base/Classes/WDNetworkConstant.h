//
//  WDNetworkConstant.h
//  WDNetworkingDemo
//
//  Created by yangxin02 on 2018/8/28.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>


@class AFHTTPSessionManager;

extern dispatch_queue_t wdn_create_default_queue(const char * label, long identifier);

extern dispatch_queue_t wdn_context_serial_queue(void);
extern dispatch_queue_t wdn_request_queue(void);
extern dispatch_queue_t wdn_reponse_queue(void);

extern AFHTTPSessionManager * wdn_session_manager(void);
extern NSOperationQueue * wdn_queue(void);


extern NSString * const kWDNetworkTaskStartTimeKey;


@interface WDNetworkConstant : NSObject

+ (NSArray<id<NSURLSessionDataDelegate>> *)URLSessionDelegates;
+ (void)setURLSessionDelegate:(id<NSURLSessionDataDelegate>)delegate;

+ (NSArray *)customizeProtocolClasses;
+ (void)setCustomizeProtocolClasses:(NSArray *)protocolClasses;

@end
