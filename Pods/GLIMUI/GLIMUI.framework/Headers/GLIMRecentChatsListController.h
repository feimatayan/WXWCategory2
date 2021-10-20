//
//  GLIMRecentChatsListController.h
//  GLIMUI
//
//  Created by ZephyrHan on 17/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//



#define USE_NEW_GLIMRecentChatsCollectionListController

#ifndef USE_NEW_GLIMRecentChatsCollectionListController

#import "GLIMBaseViewController.h"
@class GLIMChatsKeeper;


@interface GLIMRecentChatsListController : GLIMBaseViewController

/**
 消息列表
 */
@property (nonatomic, readonly, nonnull) UITableView* messagesList;

/**
 最近会话数据，ChatsKeeper负责数据变化的自动同步
 */
@property (nonatomic, readonly, nonnull) GLIMChatsKeeper* chatsKeeper;

@property (nonatomic,assign) BOOL isTemChat;

@property (nonatomic) BOOL isSubInstantAccountChat;

// 监控点击事件 若此block赋值 则本类不做cell点击跳转操作
@property (nonatomic, copy, nonnull) void(^cellClick)(_Nullable id obj);
/// 测试代码
@property (nonatomic, copy, nonnull) dispatch_block_t settingBlock;

//刷新数据
- (void)refreshData;

//滚动到有未读消息的cell
- (void)scrollToUnReadCell;

#pragma mark - 支持外部调用方法
- (void)jump2SearchView;

@end

#else

#import "GLIMRecentChatsCollectionListController.h"
@interface GLIMRecentChatsListController : GLIMRecentChatsCollectionListController
@end

#endif

