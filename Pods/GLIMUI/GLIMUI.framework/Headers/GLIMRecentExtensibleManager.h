//
//  GLIMRecentExtensibleManager.h
//  GLIMUI
//
//  Created by huangbiao on 2018/7/25.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLIMRecentExtensibleData.h"
#import "GLIMTableExtensibleSectionData.h"

@class GLIMChat;
@protocol GLIMRecentExtensibleManagerDelegate <NSObject>

/// 刷新最近联系人扩展数据
- (void)refreshRecentExtensibleDatas;

/**
 联系人是否加载完成（好友列表）

 @return YES: 全部加载
 */
- (BOOL)isLoadAllChats;


/// 点击了加载更多联系人
- (void)recentExtensibleManager_LoadMoreChatClick;
/// 获取当前显示所有的联系人的未读总数
- (NSInteger)recentExtensibleManager_GetCurrentShowChatUnreadAllNumber;

- (void)openCharVcWithChat:(GLIMChat *)chat;

@end

/**
 管理联系人列表扩展Cell
 */
@interface GLIMRecentExtensibleManager : NSObject

@property (nonatomic, weak) id<GLIMRecentExtensibleManagerDelegate> delegate;

+ (instancetype)sharedInstance;

/**
 注册扩展的Cell数据到联系人列表搜索框上方

 @param extensibleData 扩展Cell数据
 */
- (void)registerTopExtensibleData:(GLIMRecentExtensibleData *)extensibleData;


/**
 注册扩展的Cell数据到联系人列表搜索框下方

 @param extensibleData 扩展Cell数据
 */
- (void)registerBottomExtensibleData:(GLIMRecentExtensibleData *)extensibleData;

/**
 清空扩展数据
 */
- (void)reset;

/**
 通知扩展的数据进行刷新（如果需要请求数据，则请求数据）
 */
- (void)requestExtensibleDatas:(GLIMTableExtensibleRefreshType)refreshType;

/**
 刷新联系人扩展视图数据
 */
- (void)refreshExtensibleDatas;

/// 返回扩展Cell的数目
- (NSInteger)numberOfTopExtensibleCell;
- (NSInteger)numberOfBottomExtensibleCell;
- (NSInteger)numberOfExtensibleCell;

/**
 返回指定位置的扩展数据

 @param index 指定位置
 @param isTop 顶部or底部
 @return 扩展数据
 */
- (GLIMRecentExtensibleData *)extensibleDataAtIndex:(NSInteger)index isTop:(BOOL)isTop;

#pragma mark - 联系人列表顶部扩展
/**
 添加扩展的section到联系人列表顶部
 
 @param extensibleData 扩展section数据
 */
- (void)registerTopExtensibleSection:(GLIMTableExtensibleSectionData *)extensibleData;

/**
 返回联系人顶部扩展视图的section数目
 
 @return section数目
 */
- (NSUInteger)numberOfExtensibleTopSection;

/**
 返回指定位置的扩展section数据
 
 @param index 指定位置（由于有联系人列表和搜索，索引值和UI上显示的section位置有一定偏差）
 @param offset 实际偏差，offset = 0 从顶部扩展项查找，offset > 0 从底部扩展项查找
 @return 扩展section数据
 */
- (GLIMTableExtensibleSectionData *)sectionExtensibleDataAtIndex:(NSUInteger)index
                                                      withOffset:(NSUInteger)offset;

#pragma mark - 联系人列表底部扩展

/**
 添加扩展的section到联系人列表尾部

 @param extensibleData 扩展section数据
 */
- (void)registerExtensibleSection:(GLIMTableExtensibleSectionData *)extensibleData;

/**
 返回指定位置的扩展section数据

 @param index 指定位置（由于有联系人列表和搜索，索引值和UI上显示的section位置有一定偏差）
 @return 扩展section数据
 */
- (GLIMTableExtensibleSectionData *)sectionExtensibleDataAtIndex:(NSUInteger)index;


/**
 返回扩展视图的section数目

 @return section数目
 */
- (NSInteger)numberOfExtensibleSection;

#pragma mark - 请求相关接口

/**
 下拉加载请求sectionData
 */
- (void)requestExtensibleSectionDatas:(GLIMExtensibleRequestDidFinished)callback;

/**
 上拉加载更多sectionData
 */
- (void)loadMoreExtensibleSectionDatas:(GLIMExtensibleRequestDidFinished)callback;

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

/**
 是否加载更多sectionData

 @return YES：需要加载更多，NO：不加载
 */
- (BOOL)needLoadMoreExtensibleSectionDatas;

/**
 当前正在加载更多sectionData

 @return YES or NO
 */
- (BOOL)isLoadingMoreExtensibleSectionDatas;

/**
 清空sectionData的缓存
 */
- (void)clearExtensibleSectionDatasCache;
- (void)clearExtensibleSectionFlagDatasCache;

/**
 好友列表是否已经全量加载

 @return YES：已经全量加载
 */
- (BOOL)isLoadAllChats;

@end
