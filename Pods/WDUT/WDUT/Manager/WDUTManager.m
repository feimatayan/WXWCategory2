//
//  WDUTManager.m
//  WDUTManager
//
//  Created by yuping on 15/12/24.
//  Copyright © 2015年 yuping. All rights reserved.
//

#import "WDUTManager.h"
#import "WDUTConfig.h"
#import "WDUTLogModel.h"
#import "UIViewController+WDUT.h"
#import "WDUTContextInfo.h"
#import "NSMutableDictionary+WDUT.h"
#import "WDUTUtils.h"
#import "WDUTSampleRateUtils.h"
#import "WDUTLocationManager.h"
#import "WDUTManager+Push.h"
#import <objc/runtime.h>
#import "WDUTConfig.h"
#import "WDUTSessionManager.h"
#import "WDUTStorageManager.h"
#import "WDUTManager+LifeCycle.h"
#import "WDUTMacro.h"
#import "WDUTTimedProcessor.h"
#import "NSString+WDUT.h"

@interface WDUTManager ()

@property (nonatomic, strong) WDUTTimedProcessor *processor;

@property (nonatomic, strong) dispatch_queue_t processQueue;

@property (nonatomic, assign) BOOL needSyncFromDB;

@end

@implementation WDUTManager

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.processQueue = dispatch_queue_create("com.vdian.wdut.handler", DISPATCH_QUEUE_SERIAL);

        self.pageNameDictionary = [NSMutableDictionary dictionary];

        self.appFgTimeInterval = [[NSDate date] timeIntervalSince1970] * 1000;

        self.pageDepth = 1;
        
        //抢先生成一下cuid
        [WDUTContextInfo instance];

        [self registerObserver];

        //storage初始化
        [WDUTStorageManager instance];
        
        self.processor = [[WDUTTimedProcessor alloc] init];
    }
    return self;
}

#pragma mark - setup

- (void)startWithAppKey:(NSString *)appKey channelId:(NSString *)channelId {
    if (!appKey || appKey.length < 1) {
        WDUTLog(@"appKey is empty");
        return;
    }
    
    [WDUTConfig instance].appKey = appKey;

    [WDUTContextInfo instance].channel = channelId;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 启动定位
        [[WDUTLocationManager sharedInstance] updateCurrentLocation];

        /// 是否越狱上报
        [self commitJailBrokenEvent];
    });
    
    
//    [self.processor start];
    // 延迟启动定时上报任务
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.processor start];
    });
}

#pragma mark -Jailbroken
- (void)commitJailBrokenEvent {
    BOOL isJailBroken = [WDUTContextInfo isJailbroken];
    [self commitEvent:WDUT_EVENT_TYPE_JAILBROKEN
             pageName:WDUT_PAGE_FIELD_UT
                 arg1:isJailBroken ? @"1" : @"0"
                 arg2:nil
                 arg3:nil
                 args:nil
             reserved:nil
            isSuccess:YES
             priority:WDUTReportStrategyBatch];
}

#pragma mark - commit event
- (void)commitClickEvent:(NSString *)controlName
                    args:(NSDictionary *)args
                priority:(int)priority {
    if (controlName.length == 0) {
        return;
    }

    [self commitEvent:WDUT_EVENT_TYPE_CLICK
             pageName:nil
                 arg1:controlName arg2:nil arg3:nil
                 args:args
             reserved:nil
            isSuccess:YES
             priority:priority];

}

- (void)itemExposure:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args
            pageName:(NSString *)pageName
          controller:(UIViewController *)controller {
    [self commitEvent:WDUT_EVENT_TYPE_ITEM_EXPOSURE
             pageName:pageName
                 arg1:arg1
                 arg2:arg2
                 arg3:arg3
                 args:args
             reserved:nil
            isSuccess:YES
             priority:WDUTReportStrategyBatch
           controller:controller];
}

//所有埋点事件都会调用这个方法，在这里对部分事件做自动处理：2101;
- (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
           reserved:(NSDictionary *)reserved
          isSuccess:(BOOL)isSuccess
           priority:(int)priority {

    [self commitEvent:eventId pageName:pageName arg1:arg1 arg2:arg2 arg3:arg3 args:args reserved:reserved isSuccess:isSuccess priority:priority controller:nil];
}

- (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
           reserved:(NSDictionary *)reserved
          isSuccess:(BOOL)isSuccess
           priority:(int)priority
         controller:(UIViewController *)controller {
    
    if ([eventId isKindOfClass:[NSNumber class]]) {
        eventId = [(NSNumber *)eventId stringValue];
    }
    WDUTPerformBlockOnMainThread(^{
        
        //如果eventId为空或者不是纯数字，直接抛弃
        if (eventId.length <= 0 || ![eventId wdutIsInteger]) {
            return;
        }
        
        //如果topController不是过滤页面，则当前页面取top，而非currentController
        //这段逻辑为了兼容childViewController，因为当前页面为弱引用，可能为nil，也可能不是正确的页面。
        //如果为nil，即child已经被释放，而current未更新，则取top
        //如果不是正确的页面，这段逻辑只能保证，永远取未过滤的parent作为页面
        UIViewController *currentController = _currentViewController;
        if (controller != nil) {
            currentController = controller;
        }
        if (currentController == nil) {
            UIViewController *topController = [WDUTUtils topViewController];
            if (topController != nil && ![WDUTUtils isFilteredPage:topController]) {
                currentController = topController;
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        //预处理
        NSMutableDictionary *argsDict = [NSMutableDictionary dictionaryWithDictionary:args];
        NSString *pArg3 = arg3;
        if ([eventId isEqualToString:WDUT_EVENT_TYPE_CLICK]) {
            //如果是click事件,忽略传入的arg3
            pArg3 = [self getLastControllerName:currentController];
            
            //填充reserve1字段
            [dict wdutSetObject:[WDUTUtils wdutToJSONString:[self getControllerArgs:currentController]] forKey:WDUT_EVENT_FIELD_RESERVE1];

            //过滤value为""或null的键值对
            argsDict = [argsDict wdFilterNullValue];
        } else if ([eventId isEqualToString:WDUT_EVENT_TYPE_ITEM_EXPOSURE]) {
            //曝光事件 页面信息通过reserve1上传
            //http://wf.vdian.net/browse/BUYER-2671
            [dict wdutSetObject:[WDUTUtils wdutToJSONString:[self getControllerArgs:currentController]] forKey:WDUT_EVENT_FIELD_RESERVE1];

            //过滤value为""或null的键值对
            argsDict = [argsDict wdFilterNullValue];
        } else if  ([eventId isEqualToString:WDUT_EVENT_TYPE_PAGE]) {
            //过滤value为""或null的键值对
            argsDict = [argsDict wdFilterNullValue];
        }
        
        NSString *page = pageName;
        if (!page || [page length] < 1) {
            page = [self getPageNameWithController:currentController];
        }
        
        [dict wdutSetObject:page forKey:WDUT_EVENT_FIELD_PAGE];
        [dict wdutSetObject:arg1 forKey:WDUT_EVENT_FIELD_ARG1];
        [dict wdutSetObject:arg2 forKey:WDUT_EVENT_FIELD_ARG2];
        [dict wdutSetObject:pArg3 forKey:WDUT_EVENT_FIELD_ARG3];
        
        [argsDict wdutSetObject:[WDUTUtils numberToString:_pageDepth] forKey:@"dep"];
        [dict wdutSetObject:argsDict forKey:WDUT_EVENT_FIELD_ARGS];
        
        //保留字段直接赋值，保留字段一定在最后添加，可以覆盖以上同字段的值
        [dict addEntriesFromDictionary:reserved];
        
        [self addEvent:eventId content:dict isSuccess:isSuccess priority:priority];
        
        //如果click事件通过通用接口上报，在这里补一下lastControlName
        if ([eventId isEqualToString:WDUT_EVENT_TYPE_CLICK]) {
            if (arg1.length > 0) {
                self.lastCtrlName = arg1;
            }
        }
    });
}

void WDUTPerformBlockOnMainThread(void (^block)(void))
{
    //TODO, 和旧版UT保持一致，如果已经在mainthread，同步执行，可能会导致page为空
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/// 所有埋点事件都会汇集到这里
- (BOOL)addEvent:(NSString *)eventId
         content:(NSDictionary *)content
       isSuccess:(BOOL)isSuccess
        priority:(int)priority {

    BOOL success = NO;

    if ([WDUTConfig instance].utEnable) {
        BOOL needReport = NO;

        //第一个判断是不是UT自身的网络埋点，避免循环埋点
        if ([WDUTLogModel isUTEvent:eventId content:content]) {
            if ([WDUTSampleRateUtils isSelfNeedCollection]) {
                needReport = YES;
            }
        } else if ([WDUTSampleRateUtils isNeedCollection:eventId isSuccess:isSuccess]) {
            needReport = YES;
        }

        if (needReport) {
            [self addEventAsync:eventId content:content priority:priority];
            success = YES;
        }
    }

    return success;
}

- (void)addEventAsync:(NSString *)eventId content:(NSDictionary *)content priority:(int)priority {
    /// 比如切换到前台时候，sessionID可能已经变化
    NSString *oldSessionID = [WDUTSessionManager getSessionId];
    dispatch_barrier_async(self.processQueue, ^{

        //组装数据
        WDUTLogModel *logModel = [self wrapperModel:eventId sessionId:oldSessionID content:content priority:priority];

        //存入storage
        [[WDUTStorageManager instance] saveLog:logModel];
    });
}

- (WDUTLogModel *)wrapperModel:(NSString *)eventId sessionId:(NSString *)sessionId content:(NSDictionary *)content priority:(int)priority {
    WDUTLogModel *logModel = [[WDUTLogModel alloc] init];

    logModel.localId = [[NSUUID UUID].UUIDString wdutMD5];

    logModel.eventID = eventId;

    //优先取config，其次取传参，最后默认值
    if ([[WDUTConfig instance].eventPriorityMap objectForKey:logModel.eventID]) {
        int priority = [[[WDUTConfig instance].eventPriorityMap objectForKey:logModel.eventID] intValue];
        if (priority >= 0 && priority <= 100) {
            logModel.priority = priority;
        } else {
            logModel.priority = WDUTReportStrategyBatch;
        }
    } else if (priority >= 0 && priority <= 100) {
        logModel.priority = priority;
    } else {
        logModel.priority = WDUTReportStrategyBatch;
    }

    NSMutableDictionary *dict = [WDUTContextInfo getContextInfo];

    [dict wdutSetObject:sessionId forKey:WDUT_EVENT_FIELD_SESSIONID];

    //补一下timestamp
    if ([content objectForKey:WDUT_EVENT_FIELD_LOCAL_TIMESTAMP] == nil) {
        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        [dict wdutSetObject:[@((unsigned long long)timestamp) stringValue] forKey:WDUT_EVENT_FIELD_LOCAL_TIMESTAMP];
    }
    
    if (content) {
        [dict addEntriesFromDictionary:content];
    }

    logModel.content = dict;
    return logModel;
}

#pragma mark - trigger processor

- (void)tick:(BOOL)flush {
    [self.processor setFlushing:flush];
}

- (void)resetOperationQueue {
    [self.processor resetOperationQueue];
}

- (void)resetTimer {
    [self.processor resetTimer];
}

- (void)syncFromDB {
    dispatch_async(self.processQueue, ^{
        //如果数量一致，什么都不做
        if ([[WDUTStorageManager instance] getTotalCount] == [[WDUTStorageManager instance] getTotalCountFromDB]) {
            return;
        }
        //如果已经置位，什么都不做
        if (!_needSyncFromDB) {
            _needSyncFromDB = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10.0 * NSEC_PER_SEC), self.processQueue, ^{
                //可以在这里再检查下DB和cache的数量
                [self.processor forceSyncFromDB];
                _needSyncFromDB = NO;
            });
        }
    });
}

@end
