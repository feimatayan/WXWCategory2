//
// Created by shazhou on 2018/7/12.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import "WDUTStorageManager.h"
#import <FMDB/FMDB.h>
#import "WDUTLogModel.h"
#import "NSData+WDUT.h"
#import <time.h>
#import <UIKit/UIKit.h>
#import "WDUTDef.h"
#import "WDUTThreadSafeMutableArray.h"
#import "WDUTMacro.h"

#define WDUT_DB_NAME @"wdut.sqlite"

#define WDUT_DB_TIMEOUT 300

#define WDUT_DB_MAX_ITEMS_COUNT 10000

#define WDUT_DB_WARNING_ITEMS_COUNT 1000

#define WDUT_DB_USELESS_LOG_DAY_COUNT 7

#define WDUT_CACHE_CAPACITY 3000

@implementation WDUTStorageManager {
    FMDatabaseQueue *_database;

    WDUTThreadSafeMutableArray *_mutableArray;
}

+ (WDUTStorageManager *)instance {
    static WDUTStorageManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self prepareDB];
        [self prepareCache];
    }

    return self;
}

- (void)prepareDB {
    NSError *error = nil;
    NSString *filePath = [self dbFilePath];
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"db file path create failed!");
        return;
    }
    NSString *dbPath = [filePath stringByAppendingPathComponent:WDUT_DB_NAME];
    _database = [FMDatabaseQueue databaseQueueWithPath:dbPath];

    if (_database) {
        [_database inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                NSString *createTableStatement = @"CREATE TABLE if not exists t_log ('local_id' PRIMARY KEY, event_id NOT NULL, content NOT NULL, priority, create_time, status, extra)";
                if (![db executeUpdate:createTableStatement]) {
                    NSLog(@"create table failed");
                }
            }
        }];

        [self cleanUselessLogs];
    }
}

- (void)prepareCache {
    _cacheEnabled = YES;
    _mutableArray = [[WDUTThreadSafeMutableArray alloc] init];
    [self syncFromDB];
}

- (void)syncFromDB {
    if (!_cacheEnabled) {
        return;
    }
    _lastSyncTime = [[NSDate date] timeIntervalSince1970];

    NSInteger dbCount = [self getTotalCountFromDB];
    if (dbCount <= 0) {
        return;
    }

    NSInteger cacheCount = [self getTotalCount];
    if (cacheCount == dbCount) {
        return;
    }

    NSArray *logs = [self getLogsFromDBLimited:WDUT_CACHE_CAPACITY orderByPriority:YES];
    if (logs.count > 0) {
        [_mutableArray refillObjectsFromArray:logs sortUsingComparator:logComparator()];
    }
}

#pragma mark - public func.
- (BOOL)saveLog:(WDUTLogModel *)log {
    if (![NSJSONSerialization isValidJSONObject:log.content]) {
        return NO;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:log.content options:0 error:nil];
    
    //限制单条日志最大长度 1MB
    if (jsonData.length > WDUT_MAX_LENGTH_SINGLE_LOG) {
        return NO;
    }
    
    //加密
    jsonData = [jsonData wdutAes256EncryptWithKey:[WDUTStorageManager getAesKey]];

    if (jsonData == nil) {
        return NO;
    }
    __block BOOL result = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [_database inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"INSERT INTO t_log(local_id, event_id, content, priority, create_time) VALUES (?, ?, ?, ?, ?)", log.localId, log.eventID, jsonData, @(log.priority), [NSDate date]];
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t) WDUT_DB_TIMEOUT * NSEC_PER_SEC));

    //同时加入缓存
    if (result && _cacheEnabled) {
        if (_mutableArray.count < WDUT_CACHE_CAPACITY) {
            [_mutableArray addObject:log sortUsingComparator:logComparator()];
        } else {
            WT.eventId(WDUT_EVENT_TYPE_UT_CACHE_FULL).page(WDUT_PAGE_FIELD_UT).arg1([@(_mutableArray.count) stringValue]).arg2([@(WDUT_CACHE_CAPACITY) stringValue]).commit();
            [[WDUTManager sharedInstance] syncFromDB];
        }
    }

    return result;
}

- (WDUTLogModel *)firstLog {
    if (_mutableArray.count <= 0) {
        return nil;
    }
    return [_mutableArray firstObject];
}

- (NSArray *)getLogsLimited:(NSInteger)count {
    if (count <= 0) {
        return nil;
    }
    NSInteger aCount = MIN(count, _mutableArray.count);
    return [_mutableArray popObjectsWithRange:NSMakeRange(0, aCount)];
}

- (NSArray *)getLogsFromDBLimited:(NSInteger)count orderByPriority:(BOOL)orderByPriority {
    //构造查询语句
    NSMutableString *queryStatement = [NSMutableString string];
    [queryStatement appendString:@"select * from t_log"];
    if (orderByPriority) {
        [queryStatement appendString:@" order by priority asc"];
    }
    if (count > 0) {
        [queryStatement appendFormat:@" limit %ld", (long) count];
    }

    NSMutableArray *result = [NSMutableArray array];

    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [_database inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:queryStatement];

        while ([set next]) {
            WDUTLogModel *recordEvent = [WDUTLogModel new];
            recordEvent.localId = [set stringForColumn:@"local_id"];
            NSData *data = [set dataForColumn:@"content"];

            //解密
            data = [data wdutAes256DecryptWithKey:[WDUTStorageManager getAesKey]];
            
            if (data.length > 0) {
                recordEvent.content = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                recordEvent.priority = [set intForColumn:@"priority"];
                recordEvent.eventID = [set stringForColumn:@"event_id"];
                [result addObject:recordEvent];
            }
        }

        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t) WDUT_DB_TIMEOUT * NSEC_PER_SEC));
    return result;
}

- (NSInteger)getTotalCountFromDB {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    __block NSInteger totalCount = 0;
    [_database inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select count(*) as total from t_log"];
        while ([set next]) {
            totalCount = [set intForColumn:@"total"];
        }

        dispatch_semaphore_signal(sema);
    }];

    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t) WDUT_DB_TIMEOUT * NSEC_PER_SEC));
    return totalCount;
}

- (NSInteger)getTotalCount {
    return _mutableArray.count;
}

- (BOOL)deleteLogsWithLocalIds:(NSArray *)localIds {
    if (localIds.count <= 0) {
        return YES;
    }
    __block BOOL result = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [_database inDatabase:^(FMDatabase *db) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *localId in localIds) {
            [array addObject:[NSString stringWithFormat:@"'%@'", localId]];
        }
        NSString *ids = [array componentsJoinedByString:@","];
        NSString *sqlStatement = [NSString stringWithFormat:@"delete from t_log where local_id in (%@)", ids];
        result = [db executeUpdate:sqlStatement];
        if (db.changes < localIds.count) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                WT.eventId(WDUT_EVENT_TYPE_UT_ERROR).arg1([@(db.changes) stringValue]).arg2([@(localIds.count) stringValue]).commit();
            });
        }
        dispatch_semaphore_signal(sema);
    }];

    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t) WDUT_DB_TIMEOUT * NSEC_PER_SEC));
    return result;
}

#pragma mark - private func.

/*
 * 先做2个简单的逻辑
 * 如果总数大于 WDUT_DB_MAX_ITEMS_COUNT, 清理掉最旧的10%的日志
 * 如果总数大于 WDUT_DB_WARNING_ITEMS_COUNT，清理掉7天前的日志
 * */
- (void)cleanUselessLogs {
    NSInteger totalCount = [self getTotalCountFromDB];
    if (totalCount > WDUT_DB_MAX_ITEMS_COUNT) {
        NSInteger deleteCount = totalCount * 0.1;
        [self deleteOldestLogsWithCount:deleteCount];
    } else if (totalCount > WDUT_DB_WARNING_ITEMS_COUNT) {
        [self deleteLogsBeforeDays:WDUT_DB_USELESS_LOG_DAY_COUNT];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        WT.eventId(WDUT_EVENT_TYPE_UT_DB).arg1(@"init").arg2([@(totalCount) stringValue]).commit();
    });
    
}

- (NSString *)dbFilePath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    NSString *filePath = [documentPath stringByAppendingPathComponent:@"wdut2"];
    return filePath;
}

//1. priority越小，排序越靠前
//2. 时间戳越大，排序越靠前
NSComparator logComparator() {
    return ^NSComparisonResult(WDUTLogModel *obj1, WDUTLogModel *obj2) {
        if (obj1.priority == obj2.priority) {
            //时间戳越大，排序越靠前
            return [[NSNumber numberWithDouble:[obj2 getLogTimeInterval]] compare:[NSNumber numberWithDouble:[obj1 getLogTimeInterval]]];
        }
        //priority越小，排序越靠前
        return [[NSNumber numberWithInt:obj1.priority] compare:[NSNumber numberWithInt:obj2.priority]];
    };
}

- (void)deleteLogsBeforeDays:(NSInteger)day {
    [_database inDatabase:^(FMDatabase *db) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - day * 24 * 3600;
        NSString *sqlStatement = [NSString stringWithFormat:@"delete from t_log where create_time < %f", time];
        [db executeUpdate:sqlStatement];
    }];
}

- (void)deleteOldestLogsWithCount:(NSInteger)count {
    [_database inDatabase:^(FMDatabase *db) {
        NSString *sqlStatement = [NSString stringWithFormat:@"delete from t_log where local_id in (select local_id from t_log order by create_time limit %ld)", (long)count];
        [db executeUpdate:sqlStatement];
    }];
}

- (void)appWillTerminate {
    if (_database) {
        [_database close];
    }
}

+ (NSString *)getAesKey {
    NSArray *keys = @[@"TmeMY",@"jLfLb",@"W315o",@"fgLny",@"oA=="];
    return [keys componentsJoinedByString:@""];
}

@end
