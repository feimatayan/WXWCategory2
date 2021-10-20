//
//  WDUTManager.h
//  WDUTManager
//
//  Created by yuping on 15/12/24.
//  Copyright © 2015年 yuping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WDUTConfig.h"

@class WDUTContextInfo;

@interface WDUTManager : NSObject

/// 页面深度
@property (nonatomic, assign) NSInteger pageDepth;

@property (nonatomic, weak) UIViewController *preViewController;
@property (nonatomic, weak) UIViewController *currentViewController;

@property (nonatomic, copy) NSString *lastCtrlName;

@property (nonatomic, copy) NSString *lastPageName;

@property (nonatomic, strong) NSDictionary *lastPageArgs;

/// app前台停留时间（切换到后台少于30s，算作是前台停留时间）
@property (nonatomic, assign) NSTimeInterval appFgTimeInterval;
@property (nonatomic, assign) NSTimeInterval appTotalFgTimeInterval;

/// 缓存所有viewcontroller和对应的别名
@property (atomic, strong) NSMutableDictionary *pageNameDictionary;

+ (instancetype)sharedInstance;

- (void)startWithAppKey:(NSString *)appKey channelId:(NSString *)channelId;

- (void)commitClickEvent:(NSString *)controlName
                    args:(NSDictionary *)args
                priority:(int)priority;

- (void)itemExposure:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args
            pageName:(NSString *)pageName
          controller:(UIViewController *)controller;

- (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
           reserved:(NSDictionary *)reserved
          isSuccess:(BOOL)isSuccess
           priority:(int)priority;

- (void)tick:(BOOL)flush;

- (void)resetOperationQueue;

- (void)resetTimer;

- (void)syncFromDB;

@end
