//
// Created by shazhou on 2018/9/5.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import "WDUTTimedProcessor.h"
#import "WDUTConfig.h"
#import "WDUTContextInfo.h"
#import "WDUTStorageManager.h"
#import "WDUTLogModel.h"
#import "WDUTService.h"
#import "WDUTDef.h"
#import "WDUTUploadOperation.h"
#import "WDUTMacro.h"
#import "WDUTUtils.h"

@interface WDUTTimedProcessor()

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) NSInteger continuousFailedCount;

@property (nonatomic, assign) NSTimeInterval maxContinuousFailedTime;

@property (nonatomic, strong) NSOperationQueue *uploadQueue;

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, assign) uint64_t interval;

@property (nonatomic, assign) BOOL forceSync;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, strong) NSError *lastError;

@end

#define WDUT_MAX_FAILED_COUNT 10

@implementation WDUTTimedProcessor

+ (NSInteger)getBatchNumOfUpload {
    NSInteger batchNum = 20;
    
    NSDictionary *batchDict = [[WDUTConfig instance].batchNumOfUpload copy];
    if (batchDict.count > 0) {
        if ([WDUTContextInfo instance].currentNetworkStatus == ReachableViaWiFi) {
            batchNum = [batchDict[@"wifi"] integerValue];
        } else {
            batchNum = [batchDict[@"mobile"] integerValue];
        }
        
        if (batchNum <= 0) {
            batchNum = 20;
        }
    }
    
    return batchNum;
}

- (instancetype)init {
    if (self = [super init]) {

        self.continuousFailedCount = 0;
        self.maxContinuousFailedTime = 0;
        
        _uploadQueue = [[NSOperationQueue alloc] init];
        _uploadQueue.maxConcurrentOperationCount = [WDUTConfig instance].maxConcurrentCount;

        _flushing = NO;

        //初始化计时器
        _queue = dispatch_queue_create("com.vdian.wdut.timed.processor", DISPATCH_QUEUE_SERIAL);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);

        [self resetTimer];

        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(self.timer, ^{
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            
            [strongSelf tick];
        });
    }

    return self;
}

- (void)setFlushing:(BOOL)flushing {
    dispatch_async(_queue, ^{
        _flushing = flushing;

        if (flushing) {
            _uploadQueue.maxConcurrentOperationCount = WDUT_MAX_CONCURRENT_OPERATION_NUMBER;
            uint64_t interval = (uint64_t)(WDUT_MIN_TIMED_PROCESSOR_INTERVAL * NSEC_PER_MSEC);
            dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, interval, 0);

            [self startBackgroundTask];
        } else {
            [self resetTimer];
            [self resetOperationQueue];

            [self endBackgroundTask];
        }
    });
}

- (void)forceSyncFromDB {
    //只是置位，会在下一个loop里做同步操作。
    _forceSync = YES;
}

- (void)start {
    dispatch_resume(self.timer);
}

- (void)stop {
    dispatch_source_cancel(self.timer);
    
    self.timer = nil;
}

- (void)pause {
    dispatch_suspend(self.timer);
}

- (void)resetOperationQueue {
    _uploadQueue.maxConcurrentOperationCount = [WDUTConfig instance].maxConcurrentCount;
}

- (void)resetTimer {
    _interval = (uint64_t)([WDUTConfig instance].timedProcessorInterval * NSEC_PER_MSEC);
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, _interval), _interval, 0);
}

//线程安全
- (void)tick {
    //主动同步过程
    if (_forceSync) {
        //优先上传，上传队列为空的时候，启动数据同步过程
        if ([_uploadQueue operationCount] <= 0) {
            [[WDUTStorageManager instance] syncFromDB];
            _forceSync = NO;
        }
        return;
    }
    
    if ([self checkUploadConditions]) {
        [self uploadBatchLogs];
    } else {
        //定时同步过程
        //利用这个loop做一次同步
        if ([self checkSyncConditions]) {
            [[WDUTStorageManager instance] syncFromDB];
        }
    }

    //如果后台flush完成
    if (_flushing) {
        if ([_uploadQueue operationCount] <= 0 && [[WDUTStorageManager instance] getTotalCountFromDB] <= 0) {
            [self endBackgroundTask];
        }
    }
}

- (void)uploadBatchLogs {
    NSArray *totalLogs = [self fetchUploadingLogs];
    NSInteger batchNumber = [WDUTTimedProcessor getBatchNumOfUpload];
    for (int i = 0; i < _uploadQueue.maxConcurrentOperationCount; i ++) {
        NSInteger start = i * batchNumber;
        if (start >= totalLogs.count) {
            break;
        }

        NSInteger length = batchNumber;
        if (start + length > totalLogs.count) {
            length = totalLogs.count - start;
        }
        NSArray *subArray = [totalLogs subarrayWithRange:NSMakeRange(start, length)];
        [self uploadLogs:subArray retryCount:0];

    }

}

- (void)uploadLogs:(NSArray *)logArray retryCount:(NSInteger)currentRetryCount {
    if (logArray.count <= 0) {
        return;
    }

    if (currentRetryCount >= WDUT_RETRY_MAX_COUNT) {
        //TODO, 标记一下，缓存和数据库不同步
        self.continuousFailedCount ++;
        if (self.continuousFailedCount > WDUT_MAX_FAILED_COUNT) {
            //记录连续错误到达临界值的时间
            _maxContinuousFailedTime = [[NSDate date] timeIntervalSince1970];
            //关闭storage的缓存功能
            [WDUTStorageManager instance].cacheEnabled = NO;
            //如果触发了连续错误到达临界值，埋个点
            WT.eventId(WDUT_EVENT_TYPE_UT_CRITICAL_ERROR).args(@{
                    @"error_msg": self.lastError.description ?: @"",
            }).commit();
        }
        return;
    }

    //需要再次判断网络情况
    if ([WDUTContextInfo instance].currentNetworkStatus == NotReachable) {
        return;
    }

    NSArray *uploadingLogs = [self buildData:logArray];

    WDUTUploadOperation *uploadOperation = [[WDUTUploadOperation alloc] initWithLogs:uploadingLogs];
    [uploadOperation setOperationCompletionBlock:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            NSArray *uploadedLogIds = [self pickLocalIds:logArray];
            [[WDUTStorageManager instance] deleteLogsWithLocalIds:uploadedLogIds];
        } else {
            self.lastError = error;
            uint64_t randomInterval = _interval + arc4random() % 100;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomInterval), _queue, ^{
                [self uploadLogs:logArray retryCount:currentRetryCount + 1];
            });
        }
    }];

    [_uploadQueue addOperation:uploadOperation];
}

- (BOOL)checkUploadConditions {
    if (![WDUTConfig instance].utEnable) {
        return NO;
    }

    if (![WDUTConfig instance].uploadEnable) {
        return NO;
    }

    //熔断策略，如果连续错误超过一定次数，直到下次初始化之前都不再上报了
    if (self.continuousFailedCount > WDUT_MAX_FAILED_COUNT) {
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        //如果触发最大连续失败次数的时间已经超过24小时，那就重置一下
        if (now - _maxContinuousFailedTime > 3600 * 24) {
            self.continuousFailedCount = 0;
            [WDUTStorageManager instance].cacheEnabled = YES;
        } else {
            return NO;
        }
    }

    if ([self.uploadQueue operationCount] > _uploadQueue.maxConcurrentOperationCount * 3) {
        //如果队列中未完成的操作太多，先return
        return NO;
    }
    

    if ([WDUTContextInfo instance].currentNetworkStatus == NotReachable) {
        return NO;
    }

    if ([self haveInstantLogs]) {
        return YES;
    }

    NSInteger logCount = [[WDUTStorageManager instance] getTotalCount];
    if (_flushing || logCount >= [WDUTTimedProcessor getBatchNumOfUpload]) {
        return YES;
    }

    return NO;
}

- (BOOL)checkSyncConditions {
    if (![WDUTConfig instance].utEnable) {
        return NO;
    }

    if (![WDUTConfig instance].uploadEnable) {
        return NO;
    }

    if (self.continuousFailedCount > WDUT_MAX_FAILED_COUNT) {
        return NO;
    }

    if ([self.uploadQueue operationCount] > 0) {
        return NO;
    }


    if ([WDUTContextInfo instance].currentNetworkStatus == NotReachable) {
        return NO;
    }

    //控制一下同步的频率，放在读数据库之前
    if ([[NSDate date] timeIntervalSince1970] - [WDUTStorageManager instance].lastSyncTime < 10.0) {
        return NO;
    }

    return YES;
}

- (BOOL)haveInstantLogs {
    WDUTLogModel *firstLog = [[WDUTStorageManager instance] firstLog];
    if (firstLog != nil) {
        if (firstLog.priority <= 10) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)fetchUploadingLogs {
    NSInteger count = [WDUTTimedProcessor getBatchNumOfUpload];
    count = count * _uploadQueue.maxConcurrentOperationCount;
    return [[WDUTStorageManager instance] getLogsLimited:count];
}

- (NSArray *)buildData:(NSArray *)logs {
    NSMutableArray *connectArray = [NSMutableArray array];
    for (WDUTLogModel *event in logs) {
        NSDictionary *eventDict = [event getEventDictionary];
        [connectArray addObject:eventDict];
    }

    return connectArray;
}

- (NSArray *)pickLocalIds:(NSArray *)logs {
    NSMutableArray *localIds = [NSMutableArray array];
    for (WDUTLogModel *event in logs) {
        if (event.localId.length > 0) {
            [localIds addObject:event.localId];
        }
    }

    return localIds;
}

#pragma mark - background task
- (void)startBackgroundTask {
    if (self.backgroundTaskIdentifier == UIBackgroundTaskInvalid) {
        self.backgroundTaskIdentifier = [WDUTSharedApplication() beginBackgroundTaskWithExpirationHandler:^{
            [self endBackgroundTask];
        }];
    }

}

- (void)endBackgroundTask {
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [WDUTSharedApplication() endBackgroundTask:self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
}

@end
