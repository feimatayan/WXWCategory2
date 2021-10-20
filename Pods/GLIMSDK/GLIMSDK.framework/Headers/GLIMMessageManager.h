//
//  GLIMMessageManager.h
//  GLIMSDK
//
//  Created by KouDai on 2017/2/20.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMMessage.h"
#import "GLIMChat.h"
#import "GLIMDataCache.h"

#define GLIMNOTIFICATION_MESSAGE_SEND_BEGIN             @"GLIMNOTIFICATION_MESSAGE_SEND_BEGIN"
#define GLIMNOTIFICATION_MESSAGE_SEND_STATUS_CHANGED    @"GLIMNOTIFICATION_MESSAGE_SEND_STATUS_CHANGED"
#define GLIMNOTIFICATION_MESSAGE_RECEIVED               @"GLIMNOTIFICATION_MESSAGE_RECEIVED"
#define GLIMNOTIFICATION_MESSAGE_LOCAL_NOTIFICATION     @"GLIMNOTIFICATION_MESSAGE_LOCAL_NOTIFICATION"

/// 消息数据有变化需要刷新通知UI刷新
#define GLIMNOTIFICATION_UI_MESSAGE_INFO_REFRESH        @"GLIMNOTIFICATION_UI_MESSAGE_INFO_REFRESH"
/// 撤回消息需要通知UI刷新
#define GLIMNOTIFICATION_UI_MESSAGE_WITHDRAW_REFRESH    @"GLIMNOTIFICATION_UI_MESSAGE_WITHDRAW_REFRESH"
//开始发消息
#define GLIMNOTIFICATION_UI_MESSAGE_START_SEND_REFRESH    @"GLIMNOTIFICATION_UI_MESSAGE_START_SEND_REFRESH"

/// 强制加载联系人列表
#define GLIMNOTIFICATION_FORCE_REFRESH_CHAT_LIST                @"GLIMNOTIFICATION_FORCE_REFRESH_CHAT_LIST"
#define GLIMNOTIFICATION_FORCE_REFRESH_SUBACCOUNT_CHAT_LIST     @"GLIMNOTIFICATION_FORCE_REFRESH_SUBACCOUNT_CHAT_LIST"

#define GLIMNOTIFICATION_SETMessageEssence_NOT    @"GLIMNOTIFICATION_SETMessageEssence_NOT"

/// 核对订单消息
#define GLIMNOTIFICATION_MESSAGE_ORDERCHECK_BUYER_CHECK     @"GLIMNOTIFICATION_MESSAGE_ORDERCHECK_BUYER_CHECK"
#define GLIMNOTIFICATION_MESSAGE_ORDERCHECK_SELLER_CHECK    @"GLIMNOTIFICATION_MESSAGE_ORDERCHECK_SELLER_CHECK"

@class GLIMMessage;
@class GLIMRoam;



@protocol GLIMMessageManagerProcotol <NSObject>

- (void)sendMessageFailed:(NSError *)imError withMessage:(GLIMMessage *)message;

@end





@interface GLIMMessageManager : NSObject

/// 记录发送中的消息
@property (nonatomic, strong) NSMutableDictionary *messageSendMap;
/// 消息cache，only cache msg ID
@property (nonatomic, strong) GLIMDataCache *messageCache;

@property (nonatomic, weak) id<GLIMMessageManagerProcotol> delegate;


+ (instancetype)sharedManager;

- (void)reset;

#pragma mark - 消息发送
/**
 *  @author huangbiao, 17-02-25 11:51:00
 *
 *  发送消息（需要补全消息数据）
 *
 *  @param  message         不完整的消息数据（不包括消息收发方）
 *  @param  chatID          指定聊天对象的chatID
 *  @param  chatType        联系人类型（用户或群） 1单聊 2群聊 3系统消息
 *  @param  completion      回调函数，返回消息对象，刷新UI
 *
 */
- (void)sendMessage:(GLIMMessage *)message
         withChatID:(NSString *)chatID
           chatType:(GLIMChatType)chatType
         completion:(void (^)(id))completion;

/**
 *  @author huangbiao, 17-02-25 11:51:00
 *
 *  发送消息（直接发送到服务器）
 *
 *  @param  message         完整的消息数据（包括消息收发方）
 *  @param  chatType        联系人类型（用户或群） 1单聊 2群聊 3系统消息
 *  @param  completion      回调函数，返回消息对象，刷新UI
 *
 */
- (void)sendMessage:(GLIMMessage *)message
           chatType:(GLIMChatType)chatType
         completion:(void (^)(id))completion;

#pragma mark - 消息加载
/**
 *  @author huangbiao, 17-02-25 11:40:00
 *
 *  加载聊天用户指定消息之前的消息数据
 *  优先从数据库查找数据，当返回的数据数目达不到要求的数目时则从服务器请求剩余数据
 *
 *  @param  chatID          指定聊天对象
 *  @param  lastMessage     成功发送/接收的消息，全新加载时传空，如果要加载指定消息之前的消息则不能为空
 *  @param  pageLimit       每页请求数目
 *  @param  autoRequest     YES : 自动请求服务器数据，初次加载数据；NO : 只加载本地数据
 *  @param  loadMore        YES : 加载更多消息，NO: 初次加载消息
 *  @param  completion      回调函数，返回需要加载的消息数组
 *
 */
- (void)loadMessagesForChatID:(NSString *)chatID
                  lastMessage:(GLIMMessage *)lastMessage
                    pageLimit:(NSInteger)pageLimit
                  autoRequest:(BOOL)autoRequest
                     loadMore:(BOOL)loadMore
                   completion:(void (^)(id, BOOL))completion;

//- (void)updatemeSsageSendMapWithMessageArray:(NSArray *)messageArray
//                                  completion:(void (^)(void))completion;

- (void)updateMessageSendMapWithMessageArray:(NSArray *)messageArray
isFromServer:(BOOL) fromServer
                                  completion:(void (^)(void))completion;


- (void)loadWeiXinMessagesForChatID:(NSString *)chatID
                        lastMessage:(GLIMMessage *)lastMessage
                          pageLimit:(NSInteger)pageLimit
                         completion:(void (^)(id, BOOL))completion;

#pragma mark - 收到消息

/**
 接收到特殊消息

 @param jsonString 消息json字段
 */
- (void)receivedSpecialMessageWithString:(NSString *)jsonString;

/**
 接收到特殊联系人的完整消息

 @param jsonString 完整的消息内容json
 */
- (void)receivedSpecialFullMessageWithString:(NSString *)jsonString;

#pragma mark - 数据库操作
/**
 *  @author huangbiao, 17-02-22 16:38:00
 *
 *  将数组中的消息数据批量插入消息表中
 *
 *  @param  messageArray   消息数组
 *
 *  @return YES：数据入库成功， NO： 数据入库失败
 */
- (BOOL)insertMessagesWithArray:(NSArray *)messageArray;

/**
 *  @author huangbiao, 17-02-22 11:57:00
 *
 *  查询指定联系人、指定消息之前的消息数组
 *
 *  @param  contactID   指定联系人ID
 *  @param  messageID   指定消息ID
 *  @param  limit       每次查询返回结果数目
 *
 *  @return 消息数组
 */
- (NSArray<GLIMMessage *> *)queryMessagesWithContactID:(NSString *)contactID
                                       beforeMessageID:(NSString *)messageID
                                                 limit:(NSInteger)limit;

- (NSArray<GLIMMessage *> *)queryMessagesWithContactID:(NSString *)contactID
                                       beforeTimestamp:(UInt64)timestamp
                                                 limit:(NSInteger)limit;

/**
 查询指定类型的最后一条消息

 @param contactID 联系人
 @param messageType 消息类型
 @return 消息数据
 */
- (NSArray<GLIMMessage *> *)queryLastestMessageWithContactID:(NSString *)contactID
                                              andMessageType:(NSInteger)messageType
                                                       limit:(NSInteger)limit;

//批量查询 联系人最后一条消息
- (NSArray<GLIMMessage *> *)queryAllLastMessagesWithChatIDArray:(NSArray *)chatIDArray;

/// 查询仅保存在本地的消息列表（用于单聊）
- (NSArray <GLIMMessage *> *)queryOnlyInLocalMessageWithContactId:(NSString *)contactID limit:(NSInteger)limit;


/// 查询指定消息
/// @param serverMsgId 消息的serverMsgId
- (GLIMMessage *)queryMessageWithServerMsgId:(NSString *)serverMsgId;


//清空聊天记录
- (BOOL)deleteMessageWithChatID:(NSString *)chatID;
#pragma mark - 漫游锚点
/// 查找指定chatID的漫游锚点
- (NSArray<GLIMRoam *> *)queryRoamsWithChatID:(NSString *)chatID;
/// 删除数组中的漫游锚点
- (BOOL)deleteRoamsWithArray:(NSArray *)roamArray;
/// 删除指定chatID的漫游锚点
- (BOOL)deleteRoamsWithChatID:(NSString *)chatID;


#pragma mark - 离线消息

/**
 同步离线消息

 @param response 回调
 */
- (void)syncOfflineMessagesWithResponse:(void (^)(id result))response;

#pragma mark - welcome
/*
 发送欢迎语
 */
- (void)sendWelcomeMessageWithChatID:(NSString *)chatID withResponse:(void (^)(id result))response;
#pragma mark - 完全请求服务端数据
/**
 完全从服务器拉取聊天数据
 不入库不做任何处理
 
 */

- (void)loadServerMessages:(NSString *)chatID
                 lastMsgId:(NSString *)lastMsgID
               lastMsgTime:(NSString *)lastMsgTime
                     limit:(NSInteger)limit
                 direction:(NSInteger)direction
                completion:(void (^)(NSArray *))completion;

- (void)loadMarketingServerMessages:(NSString *)chatID
                          lastMsgId:(NSString *)lastMsgID
                        lastMsgTime:(NSString *)lastMsgTime
                              limit:(NSInteger)limit
                          direction:(NSInteger)direction
                         completion:(void (^)(NSArray *))completion;

/*
 给服务端发送msg的ack
 */
- (void)messageAckToService:(NSString *)msgID
                    withUid:(NSString *)uid
                    andType:(NSString *)type
                 completion:(void (^)(BOOL success))completion;

/*
 在当前会话页 收到消息回复服务端
 */
- (void)messageSetMsgStatus:(NSString *)msgID
                    withUid:(NSString *)uid
                    andType:(NSString *)type
                 completion:(void (^)(BOOL success))completion;


- (void)messageSetEssence:(NSString *)groupId
              serverMsgId:(NSString *)serverMsgId
                   opType:(NSString *)opType
               completion:(void (^)(id success))completion;

#pragma mark - Utilities
/**
 在内存中删除数组中ID相同的消息

 @param originalMessageArray 原始消息数组
 @return 新的消息数组
 */
+ (NSArray *)removeDuplicateMessageWithArray:(NSArray *)originalMessageArray;
+ (NSArray *)removeDuplicateMessageWithArray:(NSArray *)originalMessageArray withMessageMap:(NSMutableDictionary *)messageMap;

@end

@interface GLIMMessageManager (DBOperation)

/**
 获取本地数据库中记录的所有发送失败的消息列表
 
 @return 消息数组
 */
- (NSArray <GLIMMessage *> *)getAllFailedMessageArray;
- (NSArray <GLIMMessage *> *)getOneMinuteFailedMessageArrayWithChatType:(GLIMMessageChatType)messageChatType with:( long long )retime;

/**
 获取本地数据库中指定联系人类型的所有发送失败的消息列表
 
 @param messageChatType 联系人类型：单聊or群聊
 @return 消息数组
 */
- (NSArray <GLIMMessage *> *)getAllFailedMessageArrayWithChatType:(GLIMMessageChatType)messageChatType;


/**
 获取本地数据库中指定联系人类型的最后一条发送失败的消息列表
 
 @param messageChatType 联系人类型：单聊or群聊
 @return 消息数组
 */
- (NSArray <GLIMMessage *> *)getAllFailedLastMessageArrayWithChatType:(GLIMMessageChatType)messageChatType;

@end

@interface GLIMMessageManager (Withdraw)

/**
 撤加指定对象的消息
 
 @param chatID 指定聊天对象
 @param serverMsgID 指定消息ID
 @param completion 回调函数，返回的结果取值如下：NSError或NSNumber;
 如果是NSError表示请求失败，
 如果是NSNumber，若值为@(YES)，表示请求成功并完成撤回；@(NO）表示请求成功，但是不能撤回；
 */
- (void)withdrawMessageWithChatID:(NSString *)chatID
                      serverMsgID:(NSString *)serverMsgID
                       completion:(void (^)(id))completion;


/**
 加载单聊撤回历史消息
 
 @param chatID 指定聊天对象UID
 @param completion 回调函数
 */
- (void)withdrawMessageHistoryWithChatID:(NSString *)chatID
                              completion:(void (^)(id))completion;

@end

@interface GLIMMessageManager (Utilities)

/// 重发本地数据库记录的所有单聊联系人最后一条发送失败的消息
- (void)resendAllFailedLastMessage;

- (void)messageSendFailedSetFlagWithMessage:(GLIMMessage *)message;

- (void)saveMessageToSendMessageQueue:(GLIMMessage *)message obj:(id)obj;

- (BOOL)isHaveCurrrentfailedMessageWithMessage:(GLIMMessage *)message;

- (void)sendMessageQueueWorkerThread;

/// 判断消息是不是正处于发送中
- (BOOL)isMessageInSendSerialQueueWithMessage:(GLIMMessage *)message;

/// 移除发送成功的消息
- (void)removeSuccessMessages:(NSArray *)messageArray;

- (void)addToResendQueueWhenDisconnect:(GLIMMessage *)message;

@end
