//
//  GLIMWeiXinManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2019/12/30.
//  Copyright © 2019 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMChatManager.h"
#import "GLIMUserManager.h"

NS_ASSUME_NONNULL_BEGIN

/// 负责维护微信公众号消息相关逻辑
@interface GLIMWeiXinManager : NSObject

#pragma mark - 微信公众号
/// 聚合微信公众号联系人
@property (nonatomic, strong) GLIMChat *combineOfficialChat;

@property (nonatomic, assign) BOOL isOfficialAccountBlock;

@property (nonatomic, copy) NSString *lastSenderName;

#pragma mark - 微信小程序
/// 聚合微信小程序联系人
@property (nonatomic, strong) GLIMChat *combineProgramChat;
/// 聚合微信小程序屏蔽状态
@property (nonatomic, assign) BOOL isProgramBlock;
/// 聚合微信小程序联系人消息发送方名称
@property (nonatomic, copy) NSString *lastProgramSenderName;

+ (instancetype)sharedInstance;

- (BOOL)isWxCombineChat:(NSString *)chatID;

/// 屏蔽聚合联系人接口
/// @param chatID 聚合联系人uid
/// @param status 屏蔽状态，1-屏蔽，0-未屏蔽
/// @param completion 回调函数
- (void)blockCombineChat:(NSString *)chatID
                  status:(NSString *)status
              completion:(GLIMCompletionBlock)completion;

/// 加载聚合联系人
- (void)loadCombineChats;

/// 更新聚合联系人
- (void)updateCombineChat:(GLIMChat *)chat;

#pragma mark - 公众号联系人缓存
- (void)resetCacheChatsWithChatArray:(NSArray *)chatArray;
- (void)appendCacheChatsWithChatArray:(NSArray *)chatArray;
- (void)addCacheChat:(GLIMChat *)chat;

#pragma mark - 聚合公众号联系人
/// 加载聚合联系人
- (void)loadCombineOfficialChat;
/// 更新聚合联系人
- (void)updateCombineOfficialChat:(GLIMChat *)chat;

/// 清空聚合联系人未读数
- (void)clearUnreadForCombineOfficialChat;

/// 同步聚合联系人相关属性
/// @param clearUnreadTime 清未读时间戳
/// @param senderName 消息发送方
- (void)syncCombineOfficialClearUnreadTime:(UInt64)clearUnreadTime andSenderName:(NSString *)senderName;

/// 同步聚合联系人清未读时间
/// @param clearUnreadTime 清未读时间戳
- (void)syncCombineOfficialClearUnreadTime:(UInt64)clearUnreadTime;

/// 同步服务器返回的未读数
/// @param syncCount 待同步的未读数
- (void)syncOfficialAccountCount:(NSInteger)syncCount;

/// 是否显示未读数
- (BOOL)unreadCountHiddenWithChat:(GLIMChat *)chat;

/// 清空指定联系人的未读数
/// @param chatID 联系人id
/// @param unreadCount 联系人的未读数目
- (void)cleanUnreadForChat:(NSString *)chatID withCount:(NSInteger)unreadCount;

#pragma mark - 通知处理
- (void)receivedOfficialAccountSyncNotify:(NSDictionary *)notifyInfos;


- (BOOL)startUpdateWeiXinAccountChatWithPairContact:(GLIMContact*)contact
                                  andLastMessage:(nonnull GLIMMessage*)lastMessage
                                  withChatSource:(GLIMChatSource *)chatSource;

@end

/// 微信公众号
@interface GLIMWeiXinManager (WxOfficalAccount)

// TODO: 暂时不移动

@end

/// 微信小程序
@interface GLIMWeiXinManager (WxProgram)

#pragma mark - 微信小程序联系人列表缓存管理

/// 重置联系人缓存
/// @param chatArray 联系人数组
- (void)resetProgramCacheChatsWithChatArray:(NSArray *)chatArray;

/// 追加多个联系人缓存数据
/// @param chatArray 联系人数组
- (void)appendProgramCacheChatsWithChatArray:(NSArray *)chatArray;

/// 追加单个联系人缓存数据
/// @param chat 联系人
- (void)addProgramCacheChat:(GLIMChat *)chat;

#pragma mark - 微信小程序聚合联系人管理

- (void)loadCombineProgramChat;

- (void)updateCombineProgramChat:(GLIMChat *)chat;

- (void)clearUnreadForCombineProgramChat;

/// 同步清空未读操作时间和消息发送昵称
/// @param clearUnreadTime 清空未读操作时间
/// @param senderName 发送昵称
- (void)syncCombineProgramClearUnreadTime:(UInt64)clearUnreadTime
                            andSenderName:(NSString *)senderName;

/// 同步清空未读操作时间
/// @param clearUnreadTime 清空未读操作时间
- (void)syncCombineProgramClearUnreadTime:(UInt64)clearUnreadTime;

/// 是否显示未读数
- (BOOL)programUnreadCountHiddenWithChat:(GLIMChat *)chat;

/// 清空单个联系人未读数
- (void)programCleanUnreadForChat:(NSString *)chatID withCount:(NSInteger)unreadCount;

#pragma mark - 请求接口
/**
 根据时间戳分页请求微信小程序联系人

 @param timestamp 时间戳
 @param limit 每页请求条数
 @param isFirstPage 1 - 第一页，其他代表不是第一页。
 @param response 返回结果
*/
- (void)queryWxProgramChatsWithTimestamp:(NSString *_Nullable)timestamp
                                   limit:(NSString *_Nullable)limit
                             isFirstPage:(NSString *)isFirstPage
                                response:(void(^ _Nonnull)(NSDictionary* _Nullable resultDict, NSError* _Nullable error))response;

#pragma mark - 通知处理
/// 处理未读数同步通知
/// @param notifyInfos 通知内容
- (void)receivedProgramSyncNotify:(NSDictionary *)notifyInfos;

/// 处理置顶同步通知
- (void)receivedProgramTopSyncNotify:(NSDictionary *)notifyInfos;

/// 处理删除操作同步通知
/// @param notifyInfos 通知内容
- (void)receivedProgramDeleteSyncNotify:(NSDictionary *)notifyInfos;

/// 处理删除操作同步聚合联系人通知
/// @param notifyInfos 通知内容
- (void)receivedProgramDeleteSyncCombineNotify:(NSDictionary *)notifyInfos;

/// 更新微信小程序联系人消息
- (BOOL)startUpdateWxProgramChatWithContact:(GLIMContact *)contact
                                lastMessage:(GLIMMessage *)lastMessage
                                 chatSource:(GLIMChatSource *)chatSource;

- (void)programChangeTopStatusWithChat:(GLIMChat *)chat
                            completion:(GLIMCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
