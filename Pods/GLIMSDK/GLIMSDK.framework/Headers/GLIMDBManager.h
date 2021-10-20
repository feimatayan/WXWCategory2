//
//  GLIMDBManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/14.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <fmdb/FMDB.h>
#import "GLIMDatabasePool.h"
#import "GLIMDatabaseQueue.h"

#import "GLIMSingleton.h"


/**
 数据库读操作使用连接池并行执行，每个任务使用一个连接，
 写操作的使用任务队列串行执行，每个任务共用一个队列，
 读写任务之间的互斥由sqliete锁实现
 */
@interface GLIMDBManager : NSObject


GLIMSINGLETON_HEADER(GLIMDBManager);


/**
 数据库的读取任务连接池，每个读操作使用一个连接
 */
@property (nonatomic, readonly, nullable) GLIMDatabasePool *readingPool;

/**
 数据库的写任务队列，所有写任务公用一个串行队列
 */
@property (nonatomic, readonly, nullable) GLIMDatabaseQueue *writingQueue;
/**
 数据库建立完成的block回调
 因数据库建立的方法可能 存在异步执行 如数据库升级操作
 故通过block回调
 */
@property (nonatomic, copy, nullable) void (^dbSetupFinish)(id _Nullable isFinish);
#pragma mark - database management

/**
 根据ID获得数据库文件路径，ID一般是用户的userID

 @param uid userID

 @return 数据库文件路径
 */
- (nonnull NSString*)dbPathForUID:(nonnull NSString*)uid;

/**
 通过uid初始化一个数据库，如果数据库不存在，则创建数据库及其表结构，
 如果已存在，则直接打开数据库。
 
 @param uid userID
 */
- (void)setupDBForUID:(nonnull NSString*)uid;

/**
 通过uid初始化一个数据库，如果数据库不存在，则创建数据库及其表结构，
 如果已存在，则直接打开数据库。
 对于已存在的数据库，需要检查是否损坏，如果损坏则重新创建新数据库

 @param uid userID
 @param needCheckDB 是否需要检查数据库
 */
- (void)setupDBForUID:(nonnull NSString*)uid needCheckDB:(BOOL)needCheckDB;

/**
 通过uid销毁一个数据库，删除数据库文件。
 如果该uid的数据库正在连接，则先关闭连接。
 
 @param uid userID
 */
- (void)destroyDBForUID:(nonnull NSString*)uid response:(void (^ _Nullable)(id _Nullable result))response;

/**
 关闭当前数据库连接
 */
- (void)closeDB;


/**
 为数据库加密
 */
- (void)encryptDB;

/**
 对数据库进行修复
 目前方案是删掉重新建
 */
- (void)repairDB;

/*
 本地联系人为空时  好有非好友都会触发检查db
 检查方式是通过服务器接口 得到当前用户实际联系人数量 若实际有联系人 则执行修复操作
 重新创建db 并拉取联系人 和 config
 */
- (void)checkDBisUsableAndRepair;

/**
 检查本地数据库中表结构是否损坏

 @return YES: 表结构正常，NO: 表结构损坏
 */
- (BOOL)checkTableIsValidInDB;

@end
