//
//  GLIMTableExtensibleSectionData.h
//  GLIMUI
//
//  Created by huangbiao on 2018/12/25.
//  Copyright © 2018 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GLIMTableExtensibleRefreshType)
{
    GLIMTableExtensibleRefreshAll = 0,              // 默认所有情况都刷新
    GLIMTableExtensibleRefreshViewWillAppear = 1,   // 页面显示
    GLIMTableExtensibleRefreshPullDown = 2,         // 下拉刷新
};

typedef void (^GLIMExtensibleRequestDidFinished)(id result);

NS_ASSUME_NONNULL_BEGIN

@class GLIMTableExtensibleCellData;

/**
 列表的扩展Section数据——Section中的cell个数是不可变的
 */
@interface GLIMTableExtensibleSectionData : NSObject

/// 头部视图（创建于20181225，但由于UI显示问题暂未使用）
@property (nonatomic, strong) UIView *sectionHeaderView;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
/// 底部视图（创建于20181225，但由于UI显示问题暂未使用）
@property (nonatomic, strong) UIView *sectionFooterView;
@property (nonatomic, assign) CGFloat sectionFooterHeight;

#pragma mark -

@property (nonatomic, strong) GLIMTableExtensibleCellData *cellData;

+ (instancetype)sectionData;

/// 支持的刷新类型
- (BOOL)supportRefreshType:(GLIMTableExtensibleRefreshType)refreshType;

#pragma mark -

/**
 标识当前section是不是可变的（内部cellData支持分页请求）
 默认为YES(可变的)
 */
@property (nonatomic, assign) BOOL isMutableSection;

/**
 默认为NO
 如果当前section支持翻页加载数据，hasMoreData需要标识为YES
 当所有section的数据加载完成时，hasMoreData则调整成NO
 */
@property (nonatomic, assign) BOOL hasMoreData;

/**
 默认为NO，请求开始时间置为YES，请求结束时置为NO
 */
@property (nonatomic, assign) BOOL isLoading;

/**
 记录当前section中包含的cellData列表
 */
@property (nonatomic, strong) NSMutableArray<GLIMTableExtensibleCellData *> *cellDataArray;

/**
 清空缓存数据
 */
- (void)clearCache;
- (void)clearFlagCache;

/**
 请求首页数据
 */
- (void)requestExtensibleSectionData:(GLIMExtensibleRequestDidFinished)callback;

/**
 加载更多数据
 */
- (void)loadMoreExtensibleSectionData:(GLIMExtensibleRequestDidFinished)callback;

/**
 通知所有sectionData开始曝光
 
 @param tableView 消息列表
 */
- (void)notifySectionDataStartExposure:(UITableView *)tableView;

/**
 通知所有sectionData结束曝光
 
 @param tableView 消息列表
 */
- (void)notifySectionDataEndExposure:(UITableView *)tableView;

#pragma mark - CellData封装
/**
 获取指定位置的cellData

 @param index index
 @return cellData cell数据
 */
- (GLIMTableExtensibleCellData *)cellDataAtIndex:(NSUInteger)index;

/**
 移除所有cellData
 */
- (void)removeAllCellDatas;

/**
 移除指定cellData

 @param cellData cell数据
 */
- (void)removeCellData:(GLIMTableExtensibleCellData *)cellData;

/**
 添加单个cellData

 @param cellData cell数据
 */
- (void)addCellData:(GLIMTableExtensibleCellData *)cellData;

/**
 添加批量cellData

 @param cellDataArray 批量Cell数据
 */
- (void)addCellDataArray:(NSArray *)cellDataArray;

/// 重置数据
/// @param cellDataArray 新数据
- (void)resetCellDataWithArray:(NSArray *)cellDataArray;

/**
 返回cellData的总数

 @return cellData的总数
 */
- (NSUInteger)numberOfCellDatas;

@end

NS_ASSUME_NONNULL_END
