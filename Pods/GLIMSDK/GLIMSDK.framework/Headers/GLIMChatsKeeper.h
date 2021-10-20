//
//  GLIMChatsKeeper.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/25.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMDataKeeper.h"

/**
 好友联系人列表
 */
@interface GLIMChatsKeeper : GLIMDataKeeper{
    UInt16 _pageNo;
    BOOL _noMoreData;
    BOOL _isLoading;
    UInt16 _pageLimit;
}
/**
 当前页数
 */
@property (nonatomic) UInt16 pageNo;

/**
 没有更多数据了
 */
@property (nonatomic) BOOL noMoreData;

/**
 是否正在加载(刷新或翻页)
 */
@property (nonatomic) BOOL isLoading;

/**
 当前页面大小, 在初始化时设置
 默认为100
 */
@property (nonatomic, readonly) UInt16 pageLimit;

//第一次加载的总数 定制的特殊的首页使用
@property (nonatomic) UInt16 firstPageLimit;

- (nonnull instancetype)initWithPageLimit:(UInt16)pageLimit;

/**
 加载最近联系人，加载数量为pageLimit
 
 @param callback 完成时的回调，参数可能是NSError或Chats列表
 */

- (void)syncRecentChatListWithResponse:(void (^ _Nullable)(id _Nullable result))callback;
/**
 重新加载最近联系人，加载数量为pageLimit

 @param callback 完成时的回调，参数可能是NSError或Chats列表
 */
- (void)reloadRencentChatsWithCallback:(void (^ _Nullable)(id _Nullable result))callback;

/**
 拉取下一页pageLimi，拉取数量为pageLimit
 
 @param callback 完成时的回调，参数可能是NSError或Chats列表
 */
- (void)loadNextPageChatsWithCallback:(void (^ _Nullable)(id _Nullable result))callback;


- (void)reloadRencentChatsWithFromServiceCallback:(void (^ _Nullable)(id _Nullable result))callback ;

/**
 拉取下一页数据，拉取数量为传入的pageLimit
 
 目前用于定位未读chat功能中拉取数据库中联系人
 
 @param callback 完成时的回调，参数可能是NSError或Chats列表
 */

- (void)loadNextPageChatsWithPageLimit:(NSInteger)pageLimit Callback:(void (^ _Nullable)(id _Nullable result))callback;


- (void)noMoreDataResSet;

- (NSInteger)chatsKeeperGetCurrentShowChatUnreadAllNumber;

- (NSArray* _Nonnull)removeGroupLiveWith:(NSArray *)chats;

/// 对联系人重排序（部分联系人特殊处理）
- (NSArray *)resortChatArray:(NSArray *)chatArray;

@end
