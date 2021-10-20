//
//  GLIMOffLineMessagePoolChatKeeper.h
//  GLIMSDK
//
//  Created by jiakun on 2020/3/6.
//  Copyright © 2020 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMDataKeeper.h"
#import "GLIMWxOfficialAccountKeeper.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLIMOffLineMessagePoolChatKeeper : GLIMDataKeeper

/// 当前页数
@property (nonatomic) UInt16 pageNo;
/// 标识是否有更多数据
@property (nonatomic) BOOL noMoreData;
/// 标识是否正在加载数据（有刷新或翻页操作）
@property (nonatomic) BOOL isLoading;
/// 每页显示数目，默认为50
@property (nonatomic, readonly) UInt16 pageLimit;

@property (nonatomic, copy) NSString *subUid;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *from_source;

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
