//
//  WDUTConfig.m
//  WDUT
//
//  Created by WeiDian on 15/12/25.
//  Copyright © 2018 WeiDian. All rights reserved.
//


#import "WDUTConfig.h"
#import "WDUTManager.h"

#define WDUT_UPLOAD_INTERVAL             10

/// 后台停留超过xx秒后重启会话
#define WDUT_RESTART_BG_REMAIN_TIME     30

/// 触发日志上传最少条数
#ifdef DEBUG
#define WDUT_UPLOAD_WIFI_MIN_COUNT        10
#define WDUT_UPLOAD_MOBILE_MIN_COUNT        10
#else
#define WDUT_UPLOAD_WIFI_MIN_COUNT        10
#define WDUT_UPLOAD_MOBILE_MIN_COUNT        10
#endif


@implementation WDUTConfig

+ (instancetype)instance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.uploadRetryInterval = WDUT_UPLOAD_INTERVAL;
        self.sessionRefreshDuration = WDUT_RESTART_BG_REMAIN_TIME;
        self.batchNumOfUpload = @{@"wifi": @(WDUT_UPLOAD_WIFI_MIN_COUNT), @"mobile": @(WDUT_UPLOAD_MOBILE_MIN_COUNT)};
        self.selfSampleRate = 10;
        
        self.utEnable = YES;
        self.uploadEnable = YES;
        
        self.envType = WDUT_ENV_RELEASE;
//        self.debugMode = NO;

        self.pageTrackManually = NO;
        self.locationTrackManually = NO;

        _maxConcurrentCount = 3;
        _timedProcessorInterval = 300;

        _threadSafeUsingLock = YES;
        
        _filteredPageList = [NSMutableSet set];
        [_filteredPageList addObjectsFromArray:@[
                @"UIAlertController",
                @"UINavigationController",
                @"UIInputWindowController",
                @"UICompatibilityInputViewController",
                @"UISystemInputAssistantViewController",
                @"UICandidateViewController",
        ]];
        
        _specialPages = [NSMutableSet set];
    }

    return self;
}

#pragma mark - update

- (void)setSampleMap:(NSArray *)sampleRateList {
    if (sampleRateList == nil || sampleRateList.count <= 0) {
        _sampleRateMap = nil;
    }

    NSMutableDictionary *sampleMap = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in sampleRateList) {
        if (dict && dict[@"eventID"]) {
            NSString *key = @"";
            if ([dict[@"eventID"] isKindOfClass:[NSString class]]) {
                key = dict[@"eventID"];
            } else {
                key = [dict[@"eventID"] stringValue];
            }
            if (key.length > 0) {
                sampleMap[key] = dict;
            }
        }
    }

    _sampleRateMap = sampleMap;
}

- (void)setPriorityMap:(NSArray *)eventPriorityList {
    if (eventPriorityList == nil || eventPriorityList.count <= 0) {
        _eventPriorityMap = nil;
    }

    NSMutableDictionary *priorityMap = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in eventPriorityList) {
        if (dic && dic[@"eventID"]) {
            NSString *key = @"";
            if ([dic[@"eventID"] isKindOfClass:[NSString class]]) {
                key = dic[@"eventID"];
            } else {
                key = [dic[@"eventID"] stringValue];
            }
            if (key.length > 0) {
                priorityMap[key] = dic[@"priority"];
            }

        }
    }
    _eventPriorityMap = priorityMap;
}

- (void)setMaxConcurrentCount:(NSInteger)maxConcurrentCount {
    _maxConcurrentCount = MIN(WDUT_MAX_CONCURRENT_OPERATION_NUMBER, maxConcurrentCount);
    [[WDUTManager sharedInstance] resetOperationQueue];
}

- (void)setTimedProcessorInterval:(NSInteger)timedProcessorInterval {
    _timedProcessorInterval = MAX(WDUT_MIN_TIMED_PROCESSOR_INTERVAL, timedProcessorInterval);
    [[WDUTManager sharedInstance] resetTimer];
}

@end
