//
//  GLIMMessageKeeper.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/25.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMDataKeeper.h"
#import "GLIMSDKInterface.h"

@class GLIMMessage;

@interface GLIMMessageKeeper : GLIMDataKeeper

@property (nonatomic, strong, nonnull) NSString *chatID;

/// 每页加载消息条数
@property (nonatomic, assign) NSInteger pageLimit;

/// 首页实际返回数目(由于需要清空自动回复，所以首页消息数可能比每页加载消息条数少）
@property (nonatomic, assign) NSInteger messageCountInFirstPage;

/**
 消息中间添加时间戳间隔(s)，如果为0，则不添加时间戳
 */
@property (nonatomic, assign) NSInteger messageInterval;

/**
 是否正在加载(刷新或翻页)
 */
@property (nonatomic, assign) BOOL isLoading;

/**
 是否显示屏蔽通知
 */
@property (nonatomic, assign) BOOL showBlockNotify;

/// 记录最后一条消息（仅用于群聊）
@property (nonatomic, strong, nullable) GLIMMessage *lastMessage;

@property (nonatomic, strong, nullable) GLIMMessage *searchMessage;


//进入微信小程序会话 会返回除了微信小程序的id 并且返回微店的id
@property (nonatomic, strong, nullable) NSString *otherChatID;

/// 当前聊天对象的未读消息数
@property (nonatomic, assign) NSInteger unreadCount;

/// 当前聊天对象的未读消息数(不会跟随 网络请求而数据变化)
@property (nonatomic, assign) NSInteger unreadCount_Unchanged;

/// 最大的已读消息ID（用于群聊提示最新消息）
@property (nonatomic, copy, nullable) NSString *maxReadMessageID;

/// 重置参数
- (void)resetParameters;

/**
 根据聊天类型生成对应的keeper对象
 默认返回单聊的keeper对象

 @param chatType 聊天类型
 @return keeper实例对象
 */
+ (nonnull instancetype)messageKeeperWithChatType:(GLIMChatType)chatType;

+ (nonnull instancetype)messageKeeperWithRoam;

+ (nonnull instancetype)messageKeeperLiveLecturer;

+ (nonnull instancetype)browsePersonalMessageKeeper;

+ (nonnull instancetype)browseGroupMessageKeeper;

/**
 添加新消息
 适用于接收或发送一条新消息

 @param message 消息数据
 */
- (void)insertMessage:(nonnull GLIMMessage *)message;


/**
 刷新消息
 @param message 消息数据
 */
- (void)refreshMessage:(nonnull GLIMMessage *)message;

/**
 初次加载消息数据

 @param callback 回调函数
 */
- (void)loadMessagesWithCallback:(void (^ _Nullable)(id _Nullable result))callback;

/**
 加载更多消息数据

 @param callback 回调函数
 */
- (void)loadMoreMessagesWithCallback:(void (^ _Nullable)(id _Nullable result))callback;


- (void)loadDownMoreMessagesWithCallback:(void (^ _Nullable)(id _Nullable result))callback;

/**
 加载所有未读消息数据

 @param unreadCount 未读消息数
 @param callback 回调函数
 */
- (void)loadAllUnreadMessage:(NSInteger)unreadCount
                    callback:(void (^ _Nullable)(id _Nullable result))callback;


/**
 直播群大量加载消息

 @param count 每次数量 暂定300
 @param callback 回调函数
 */
- (void)loadLiveUnreadMessage:(NSInteger)count
              callback:(void (^ _Nullable)(id _Nullable result))callback;
/**
 移除屏蔽联系人消息
 */
- (void)removeBlockNotify;

/// 获取新消息标识在整个显示消息数组中的位置
- (NSInteger)newMessageTagIndex;

/**
 消息重新Reload
 */
- (void)messageKeeperReload;

- (void)printOrderList;

- (GLIMMessage *)messageWithServerMsgID:( NSString *)serverMsgID;

@end
