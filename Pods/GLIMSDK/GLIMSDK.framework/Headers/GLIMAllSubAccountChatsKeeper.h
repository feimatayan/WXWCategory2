//
//  GLIMAllSubAccountChatsKeeper.h
//  GLIMSDK
//
//  Created by huangbiao on 2019/1/21.
//  Copyright © 2019 Koudai. All rights reserved.
//

#import "GLIMDataKeeper.h"

NS_ASSUME_NONNULL_BEGIN

/**
 全部子账号联系人列表（不区分好友与非好友）
 */
@interface GLIMAllSubAccountChatsKeeper : GLIMDataKeeper

/// 当前页数
@property (nonatomic) UInt16 pageNo;
/// 标识是否有更多数据
@property (nonatomic) BOOL noMoreData;
/// 标识是否正在加载数据（有刷新或翻页操作）
@property (nonatomic) BOOL isLoading;
/// 每页显示数目，默认为50
@property (nonatomic, readonly) UInt16 pageLimit;

/**
 重新加载最近联系人，加载数量为pageLimit
 
 @param callback 完成时的回调，参数可能是NSError或Chats列表
 */
- (void)reloadRecentChatsWithCallback:(void (^ _Nullable)(id _Nullable result))callback;

/**
 拉取下一页pageLimit，拉取数量为pageLimit
 
 @param callback 完成时的回调，参数可能是NSError或Chats列表
 */
- (void)loadNextPageChatsWithCallback:(void (^ _Nullable)(id _Nullable result))callback;

@end

NS_ASSUME_NONNULL_END
