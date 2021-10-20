//
//  GLIMDataKeeper.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/25.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMBaseObject.h"


/**
 通过一个有序索引和一个Key-Value索引，对数据进行管理，并在数据发生变化时生成对应的变化通知。
 用于数据逻辑层与UI层的逻辑衔接，UI层只要关注变化通知，即可实现精确的增量页面刷新。
 UI界面的TableView可直接使用有序索引数组作为数据源，可参考NSFetchResultController.
 
 子类可通过集成或组合DataKeeper来实现对特定类型实体列表的业务数据的增量刷新封装。
 
 DataKeeper中，所有对有序索引，Key-Value索引的操作以及事件通知，都在主线程进行，以保证与UI刷新的同步性。
 */
@class GLIMDataKeeper;


typedef NS_ENUM(NSInteger, GLIMDataKeeperChangeType) {
    GLIMDataKeeperChangeNothing = 0,
    GLIMDataKeeperChangeInsert = 1,
    GLIMDataKeeperChangeDelete = 2,
    GLIMDataKeeperChangeMove = 3,
    GLIMDataKeeperChangeUpdate = 4
};


@protocol GLIMDataKeeperDelegate <NSObject>

@optional

/**
 数据发生了变化

 @param keeper      dataKeeper pointer
 @param object      变化的对象
 @param fromIndex   变化前的位置
 @param toIndex     变化后的位置
 @param type        变化类型
 */
- (void)dataKeeper:(nonnull GLIMDataKeeper*)keeper didChangeObject:(nonnull GLIMBaseObject*)object
         fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex forChangeType:(GLIMDataKeeperChangeType)type;
/**
 重置了数据，可用于刷新
 
 @param keeper  dataKeeper pointer
 @param objects 新加载的数据
 */
- (void)dataKeeper:(nonnull GLIMDataKeeper*)keeper didReload:(nonnull NSArray<GLIMBaseObject*>*)objects;

/**
 追加了新的数据，可用于翻页，默认为向上翻页

 @param keeper  dataKeeper pointer
 @param objects 新追加的数据
 */
- (void)dataKeeper:(nonnull GLIMDataKeeper*)keeper didLordMoreObjects:(nonnull NSArray<GLIMBaseObject*>*)objects;

/**
 追加了新的数据，可用于翻页

 @param keeper dataKeeper pointer
 @param objects 新追加的数据
 @param direction 0 向上翻页，1 向下翻页
 */
- (void)dataKeeper:(nonnull GLIMDataKeeper*)keeper
didLoadMoreObjects:(nonnull NSArray<GLIMBaseObject*>*)objects
         direction:(NSInteger)direction;

/**
 keeper中的数据有批量更新，需要通知UI刷新

 @param keeper dataKeeper pointer
 */
- (void)didRefreshAllDataWithKeeper:(nonnull GLIMDataKeeper*)keeper;

//需要切换dataKeeper
- (void)changeDataWithKeeper:(nonnull GLIMDataKeeper*)keeper;

@end


/**
 用来管理针对某一类对象数据的有序索引及变化更新
 */
@interface GLIMDataKeeper : NSObject

/**
 对数据的有序列表索引
 */
@property (nonatomic, readonly, nullable) NSArray<GLIMBaseObject*>* orderedList;

/**
 对数据的Key Valus索引
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString*, GLIMBaseObject*>* objectsIndex;

/*
 第一次加载数据
 */
@property (nonatomic) BOOL firstReload;

/**
 过滤重复数据后返回为空
 */
@property (nonatomic, assign) BOOL emptyAfterFiltered;

/**
 数据数量限制，超过限制时发生警告，用来控制内存占用最大值
 0为不做限制，默认值为0
 */
@property (nonatomic) UInt32 dataLimit;

/**
 数据变化代理
 */
@property (nonatomic, weak, nullable) id<GLIMDataKeeperDelegate> delegate;


/**
 重置有序数据集合
 */
- (void)resetOrderedList;

/**
 通过一个新的有序数据集，重置Keeper状态

 @param orderedList 有序数据集合
 */
- (void)resetDataByOrderedList:(nonnull NSArray<GLIMBaseObject*>*)orderedList;
- (void)resetDataByOrderedList_NoChangeUi:(NSArray<GLIMBaseObject*>*)orderedList;
- (void)copyDataByOrderedList_NoChangeUi:(NSArray<GLIMBaseObject*>*)orderedList;

/**
 批量更新数据，对新数据的操作是插入或更新到开头位置

 @param objects 新数据集合
 */
- (void)updateObjects:(nonnull NSArray<GLIMBaseObject*>*)objects;


/**
 批量更新数据，只更新原本缓存在keeper中的数据

 @param objects 数据集合
 */
- (void)updateObjectsInKeeper:(nonnull NSArray<GLIMBaseObject *> *)objects;

/**
 追加数据到末尾
 
 @param objects 新数据集合
 */
- (void)appendObjects:(nonnull NSArray<GLIMBaseObject*>*)objects;

/**
 追加数据到末尾

 @param objects 新数据集合
 @param needRedupliction 是否需要去重，默认为YES
 */
- (void)appendObjects:(NSArray<GLIMBaseObject *> *)objects
     needRedupliction:(BOOL)needRedupliction;


- (void)appendDownObjects:(nonnull NSArray<GLIMBaseObject*>*)objects;

/**
 批量删除数据

 @param objectsIDs 要删除的数据ID集合
 */
- (void)removeObjectsByIDs:(nonnull NSArray<NSString*>*)objectsIDs;

/**
 更新数据，对新数据的操作是插入或更新

 @param object 新数据
 @param index  新数据位置
 */
- (void)updateObject:(nonnull GLIMBaseObject*)object toIndex:(UInt32)index;


//从列表里查询位置信息
- (void)updateObject:(GLIMBaseObject*)object offset:(UInt32)offset;

/**
 删除数据

 @param objectID 要删除的数据ID
 */
- (void)removeObjectByID:(nonnull NSString*)objectID;

/**
 查找对象位置

 @param object 要查找的对象
 @return 对象位置序号，如果不存在返回-1
 */
- (NSInteger)indexOfObject:(nonnull GLIMBaseObject*)object;

/**
 添加通知 在第一次有数据后 添加数据监听通知
 */

- (void)addNotification;


/**
 打印数据信息（测试用）

 @param objects 数据对象
 */
- (void)printObjects:(NSArray *)objects;

///
- (void)onlyInsertNewObject:(nonnull GLIMBaseObject *)object atIndex:(NSInteger)index;
- (void)onlyDeleteObject:(nonnull GLIMBaseObject *)object;
- (void)onlyDeleteObjectsWithIDS:(nonnull NSArray *)removeIDArray;


- (BOOL)supportChatsMemorySort;

@end
