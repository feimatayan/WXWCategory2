//
// Created by shazhou on 2018/7/12.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDUTLogModel;


@interface WDUTStorageManager : NSObject

@property (nonatomic, assign) NSTimeInterval lastSyncTime;

@property (nonatomic, assign) BOOL cacheEnabled;

+ (WDUTStorageManager *)instance;

- (void)syncFromDB;

/*
 * 保存日志到数据库 & 缓存
 * */
- (BOOL)saveLog:(WDUTLogModel *)log;

/*
 * 从数据库中提取多条日志
 * limit = count
 * order by priority
 *
 * */
- (NSArray *)getLogsFromDBLimited:(NSInteger)count orderByPriority:(BOOL)orderByPriority;

/*
 * 从缓存中提取多条日志
 *
 * */
- (NSArray *)getLogsLimited:(NSInteger)count;

- (WDUTLogModel *)firstLog;

/*
 * DB中的日志总数
 *
 * */
- (NSInteger)getTotalCountFromDB;

/*
 * 缓存中的日志总数
 *
 * */
- (NSInteger)getTotalCount;

/*
 * 删除数据库中的日志
 *
 * */
- (BOOL)deleteLogsWithLocalIds:(NSArray *)localIds;

/*
 * 应用销毁
 * 关闭数据库
 *
 * */
- (void)appWillTerminate;

@end
