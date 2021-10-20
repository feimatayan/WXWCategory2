//
// Created by shazhou on 2018/7/18.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDUTConfig.h"


@interface WDUTBuilder : NSObject

@property (nonatomic, strong) WDUTBuilder *click;

@property (nonatomic, strong) WDUTBuilder *exposure;

@property (nonatomic, strong) WDUTBuilder *pushToken;

@property (nonatomic, strong) WDUTBuilder *pushArrive;

@property (nonatomic, strong) WDUTBuilder *pushDisplay;

@property (nonatomic, strong) WDUTBuilder *pushOpen;

- (WDUTBuilder *(^)(NSString *eventId))eventId;

- (WDUTBuilder *(^)(NSString *page))page;

- (WDUTBuilder *(^)(NSString *arg1))arg1;

- (WDUTBuilder *(^)(NSString *controlName))controlName;

- (WDUTBuilder *(^)(NSString *arg2))arg2;

- (WDUTBuilder *(^)(NSString *arg3))arg3;

- (WDUTBuilder *(^)(NSDictionary *args))args;

- (WDUTBuilder *(^)(NSString *module))module;

- (WDUTBuilder *(^)(BOOL isSuccess))isSuccess;

- (WDUTBuilder *(^)(WDUTReportStrategy policy))policy;

- (void (^)())commit;

@end

@interface WDUTCommitter : NSObject

@property (nonatomic, copy) NSString *eventId;

@property (nonatomic, copy) NSString *pageName;

@property (nonatomic, copy) NSString *arg1;

@property (nonatomic, copy) NSString *arg2;

@property (nonatomic, copy) NSString *arg3;

@property (nonatomic, strong) NSDictionary *args;

@property (nonatomic, copy) NSString *module;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) WDUTReportStrategy reportStrategy;

- (void)commit;

@end
