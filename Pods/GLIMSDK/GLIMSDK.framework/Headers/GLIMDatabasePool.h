//
//  GLIMDatabasePool.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/7/3.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface GLIMDatabasePool : NSObject

/** Database path */

@property (atomic, retain) NSString *path;

/** Delegate object */

@property (atomic, assign) id delegate;

/** Maximum number of databases to create */

@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;

/** Open flags */

@property (atomic, readonly) int openFlags;


///---------------------
/// @name Initialization
///---------------------

/** Create pool using path.
 
 @param aPath The file path of the database.
 
 @return The `GLIMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString*)aPath;

/** Create pool using path and specified flags
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 
 @return The `GLIMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString*)aPath flags:(int)openFlags;

/** Create pool using path and specified flags
 
 @param aPath The file path of the database.
 @param encryptKey the key for encrypt database.
 
 @return The `GLIMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString*)aPath encryptKey:(NSString *)encryptKey;

/** Create pool using path.
 
 @param aPath The file path of the database.
 
 @return The `GLIMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath;

/** Create pool using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 
 @return The `GLIMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;

///------------------------------------------------
/// @name Keeping track of checked in/out databases
///------------------------------------------------

/** Number of checked-in databases in pool
 
 @returns Number of databases
 */

- (NSUInteger)countOfCheckedInDatabases;

/** Number of checked-out databases in pool
 
 @returns Number of databases
 */

- (NSUInteger)countOfCheckedOutDatabases;

/** Total number of databases in pool
 
 @returns Number of databases
 */

- (NSUInteger)countOfOpenDatabases;

/** Release all databases in pool */

- (void)releaseAllDatabases;

///------------------------------------------
/// @name Perform database operations in pool
///------------------------------------------

/** Synchronously perform database operations in pool.
 
 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inDatabase:(void (^)(FMDatabase *db))block;

/** Synchronously perform database operations in pool using transaction.
 
 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using deferred transaction.
 
 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using save point.
 
 @param block The code to be run on the `FMDatabasePool` pool.
 
 @return `NSError` object if error; `nil` if successful.
 
 @warning You can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock. If you need to nest, use `<[FMDatabase startSavePointWithName:error:]>` instead.
 */

- (NSError*)inSavePoint:(void (^)(FMDatabase *db, BOOL *rollback))block;

@end

/** GLIMDatabasePool delegate category
 
 This is a category that defines the protocol for the GLIMDatabasePool delegate
 */

@interface NSObject (GLIMDatabasePoolDelegate)

/** Asks the delegate whether database should be added to the pool.
 
 @param pool     The `GLIMDatabasePool` object.
 @param database The `FMDatabase` object.
 
 @return `YES` if it should add database to pool; `NO` if not.
 
 */

- (BOOL)glimDatabasePool:(GLIMDatabasePool*)pool shouldAddDatabaseToPool:(FMDatabase*)database;

/** Tells the delegate that database was added to the pool.
 
 @param pool     The `GLIMDatabasePool` object.
 @param database The `FMDatabase` object.
 
 */

- (void)glimDatabasePool:(GLIMDatabasePool*)pool didAddDatabase:(FMDatabase*)database;

@end
