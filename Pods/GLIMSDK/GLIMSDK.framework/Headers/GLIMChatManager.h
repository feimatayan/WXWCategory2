//
//  GLIMChatManager.h
//  GLIMSDK
//
//  Created by Zephyrhan on 2017/2/20.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMSingleton.h"
#import "GLIMFoundationDefine.h"
#import "GLIMSDKInterface.h"
#import "GLIMChat.h"

typedef NS_ENUM(NSInteger, CombineChatUpdateMessage) {
    CombineChatUpdateMessageNO,
    CombineChatUpdateMessageNeed,
    CombineChatUpdateMessageForce
};


typedef NS_ENUM(NSInteger, GLIMChatManagerClearNoReadMessageType) {
    GLIMChatManagerClearNoReadMessageType_All,
    GLIMChatManagerClearNoReadMessageType_Person,
    GLIMChatManagerClearNoReadMessageType_Group
};

#define GLIMNOTIFICATION_CHATS_READSMSGID_CHANGED   @"GLIMNOTIFICATION_CHATS_READSMSGID_CHANGED"
#define GLIMNOTIFICATION_CHATS_CHANGED              @"GLIMNOTIFICATION_CHATS_CHANGED"
#define GLIMNOTIFICATION_CHATS_SYNCED               @"GLIMNOTIFICATION_CHATS_SYNCED"
#define GLIMNOTIFICATION_TEM_CHATS_SYNCED           @"GLIMNOTIFICATION_TEM_CHATS_SYNCED"
#define GLIMNOTIFICATION_GROUPS_SYNCED              @"GLIMNOTIFICATION_GROUPS_SYNCED"

#define GLIMNOTIFICATION_searchViewClickNot    @"GLIMNOTIFICATION_searchViewClickNot"
#define GLIMNOTIFICATION_searchViewChangeNot    @"GLIMNOTIFICATION_searchViewChangeNot"


/// 联系人未读数清空通知
#define GLIMNOTIFICATION_CHATS_UNREAD_COUNT_ZERO    @"GLIMNOTIFICATION_CHATS_UNREAD_COUNT_ZERO"

#define GLIMNOTIFICATION_CLRAR_ALLMESSAGE_NOREADNUM_NOT_CHATMANAGER             @"GLIMNOTIFICATION_CLRAR_ALLMESSAGE_NOREADNUM_NOT_CHATMANAGER"
#define GLIMNOTIFICATION_CLRAR_ALLMESSAGE_NOREADNUM_NOT_HOMEUI             @"GLIMNOTIFICATION_CLRAR_ALLMESSAGE_NOREADNUM_NOT_HOMEUI"


//所有子客服离线了
#define GLIMNOTIFICATION_GLIMCommonNotifyGeneralSubAccountoffLine_NOT             @"GLIMNOTIFICATION_GLIMCommonNotifyGeneralSubAccountoffLine_NOT"

//微信公众号发消息限制
#define GLIMNOTIFICATION_WEIXINCHAT_SENDMSG_LIMIT_NOT             @"GLIMNOTIFICATION_WEIXINCHAT_SENDMSG_LIMIT_NOT"
#define GLIMNOTIFICATION_WEIXINCHAT_DONT_DISTURB_NOT             @"GLIMNOTIFICATION_WEIXINCHAT_DONT_DISTURB_NOT"

/// 微信小程序屏蔽通知
#define GLIMNOTIFICATION_WEIXIN_PROGRAM_CHAT_DONT_DISTURB_NOT   @"GLIMNOTIFICATION_WEIXIN_PROGRAM_CHAT_DONT_DISTURB_NOT"


#define GLIMNOTIFICATION_AUBACCOUNT_CHATS_CHANGED   @"GLIMNOTIFICATION_AUBACCOUNT_CHATS_CHANGED"

/// 通知子账号联系人列表强制请求服务器数据
#define GLIMNOTIFICATION_SUBACCOUNT_RELOAD_CHATS_FROM_NETWORK    @"GLIMNOTIFICATION_SUBACCOUNT_RELOAD_CHATS_FROM_NETWORK"

// 通知联系人列表重新加载数据
#define GLIMNOTIFICATION_RELOAD_CHAT_DATA               @"GLIMNOTIFICATION_RELOAD_CHAT_DATA"

#define GLIMNOTIFICATION_RELOAD_CHAT_DATA_FROM_NETWORK  @"GLIMNOTIFICATION_RELOAD_CHAT_DATA_FROM_NETWORK"

//联系人已经显示完成
#define GLIMNOTIFICATION_CHATS_SHOWUI_DONE @"GLIMNOTIFICATION_CHATS_SHOWUI_DONE"

/// 通知发送单聊消息
#define GLIMNOTIFICATION_SEND_MESSAGE_FROM_NOTIFICATION         @"GLIMNOTIFICATION_SEND_MESSAGE_FROM_NOTIFICATION"
/// 通知发送群聊消息
#define GLIMNOTIFICATION_SEND_GROUP_MESSAGE_FROM_NOTIFICATION   @"GLIMNOTIFICATION_SEND_GROUP_MESSAGE_FROM_NOTIFICATION"

#define GLIMNOTIFICATION_MESSAGE_CLEAR              @"GLIMNotification_message_clear"

#define GLIMNOTIFICATION_MESSAGE_INPUT_SYN          @"GLIMNotification_message_intput_syn"

#define GLIMNOTIFICATION_BEGINING_INDEX             @"beginingIndex"
#define GLIMNOTIFICATION_UPDATED_CHATS              @"updatedChats"
#define GLIMNOTIFICATION_REMOVED_IDS                @"removedIDs"

/// 联系人同步完成通知，用于通知app执行操作，如刷新未读数等
/// 通知格式如下：{"isTemp":1,"":}
#define GLIMNOTIFICATION_RECENT_CHATLIST_CHANGE     @"GLMRecentChatChangeNotification"

#define GLIM_CHAT_COMBINE_SPECIAL_ID                @"5000000000000000000"
#define GLIM_CHAT_SUBACCOUNTCOMBINE_SPECIAL_ID      @"8000000000000000000"

/// 微信公众号
#define GLIM_CHAT_WX_OFFICIAL_ACCOUNT_ID                    @"7800000000000000000"
#define GLIMNOTIFICATION_WX_OFFICIAL_ACCOUNT_CHATS_CHANGED  @"GLIMNOTIFICATION_WX_OFFICIAL_ACCOUNT_CHATS_CHANGED"
// 只更新联系人信息
#define GLIMNOTIFICATION_WX_OFFICIAL_UPDATED_CHATS_INFO     @"GLIMNOTIFICATION_WX_OFFICIAL_UPDATED_CHATS_INFO"

/// 微信小程序
#define GLIM_CHAT_WX_PROGRAM_ACCOUNT_ID                     @"7810000000000000000"
/// 微信小程序联系人变更
#define GLIMNOTIFICATION_WX_PROGRAM_CHATS_CHANGED           @"GLIMNOTIFICATION_WX_PROGRAM_CHATS_CHANGED"
/// 微信小程序联系人置顶状态变更
#define GLIMNOTIFICATION_WX_PROGRAM_UPDATED_CHATS_TOP       @"GLIMNOTIFICATION_WX_PROGRAM_UPDATED_CHATS_TOP"
/// 微信小程序联系人信息变更，仅更新信息，不触发位置变更
#define GLIMNOTIFICATION_WX_PROGRAM_UPDATED_CHATS_INFO      @"GLIMNOTIFICATION_WX_PROGRAM_UPDATED_CHATS_INFO"

/// 离线消息池
#define GLIM_CHAT_OFFLINE_MESSAGE_POOL_ACCOUNT_ID           @"7900000000000000000"
/// 只更新离线消息池联系人个数
#define GLIMNOTIFICATION_OFFLINE_MESSAGE_POOL_CONTACT_COUNT @"GLIMNOTIFICATION_OFFLINE_MESSAGE_POOL_CONTACT_COUNT"

#define GLIM_CHAT_SYNC_PAGE_SIZE 100

#pragma mark - 买家版特殊联系人uid定义
#define GLIM_CHAT_SPECIAL_COMMENT           @"7000000000000000000"  // 获赞和评论 类型 10010
#define GLIM_CHAT_SPECIAL_ATTENTION         @"7100000000000000000"  // 新增粉丝 类型 10020
#define GLIM_CHAT_SPECIAL_POPULARITY        @"7200000000000000000"  // 通知消息 类型 10030
#define GLIM_CHAT_SPECIAL_TODAYWORTHBUY     @"7300000000000000000"  // 今日值得买 类型 10040
#define GLIM_CHAT_SPECIAL_BUYER_TIPS        @"7010000000000000000"  // 买家心得 类型 10093
#define GLIM_CHAT_SPECIAL_RECEIVE_PRAISE    @"7020000000000000000"  // 收到的赞 类型 10094
#define GLIM_CHAT_SPECIAL_COMMENTS_AT       @"7030000000000000000"  // 评论和@ 类型 10095
#define GLIM_CHAT_SPECIAL_CREATOR_CENTER    @"7040000000000000000"  // 创作者中心 类型 10096
#define GLIM_CHAT_SPECIAL_CIRCLE_MANAGER    @"7050000000000000000"  // 圈子管理员 类型 10097
#define GLIM_CHAT_SPECIAL_CIRCLE            @"7060000000000000000"  // 圈子 类型 10098
#define GLIM_CHAT_SPECIAL_NEW_SPACE         @"7070000000000000000"  // 新场地 类型 10099

typedef void (^GLIMUpdateChatBlock)(BOOL isSuccess);

@class GLIMChat;
@class GLIMMessage;
@class GLIMContact;
@class GLIMChatSource;
@class GLIMChatsKeeper;
@class GLIMTemChatsKeeper;
@class GLIMUser;
@class GLIMGroup;

@interface GLIMChatManager : NSObject

GLIMSINGLETON_HEADER(GLIMChatManager);

/**
 总未读消息数, 通过数据库查询获得，不使用服务端返回的数据
 未读数在收发消息，消息同步，和会话已读时发生改变
 */
@property (nonatomic, readonly) UInt64 totalUnreadCount;

/**
 上次会话同步时间
 */
@property (nonatomic) UInt64 chatSyncTimestamp;

/**
 临时会话上次会话同步时间
 */
@property (nonatomic) UInt64 temChatSyncTimestamp;

@property (nonatomic, weak, nullable) id<GLIMStatisticalDelegate> logDelegate;

/// 当前会话ID
@property (nonatomic,strong, nullable) NSString * currentChatID;

/// 临时消息联系人（用于记录好友列表中的临时消息数据，暂时不用）
@property (nonatomic, strong, nullable) GLIMChat *temporaryChat;

//特殊联系人数组
@property (nonatomic, strong) NSMutableArray *specialContactsArr;
//特殊联系人字典(快速查询)
@property (nonatomic, strong) NSDictionary *specialContactsDic;

//判断是否t特殊联系人
- (BOOL)isSpecialContactsWithChatId:(NSString *)chatid;

/// 支持临时关系——显示聚合临时文件夹
- (BOOL)supportTemporaryReleation;


@property (nonatomic, strong) GLIMChat * subAccountCombineChat;

#pragma mark - CRUD of chat

/**
 根据聊天对象、消息和消息来源数据更新联系人数据，后续准备弃用

 @param contact 聊天对象数据
 @param lastMessage 最新消息数据
 @param chatSource 消息来源数据
 @return YES：更新成功，NO：更新失败
 */
- (BOOL)updateChatWithPairContact:(nonnull GLIMContact *)contact
                   andLastMessage:(nonnull GLIMMessage *)lastMessage
                   withChatSource:(nullable GLIMChatSource *)chatSource;

/**
 根据聊天对象、消息和消息来源数据更新联系人数据

 @param contact 聊天对象数据
 @param lastMessage 最新消息数据
 @param chatSource 消息来源数据
 @param completion 回调函数，YES：更新成功，NO：更新失败
 */
- (void)updateChatWithContact:(nonnull GLIMContact *)contact
                  lastMessage:(nonnull GLIMMessage *)lastMessage
                   chatSource:(nullable GLIMChatSource *)chatSource
                   completion:(nullable GLIMUpdateChatBlock)completion;


- (BOOL)startUpdateChatWithPairContact:(GLIMContact*)contact
                        andLastMessage:(nonnull GLIMMessage*)lastMessage
                        withChatSource:(GLIMChatSource *)chatSource;

/**
 好友关系发生变化时 或者temChat被删除时 更新combineChat 专用
 因为 此时未读消息数计算 规则变化太大 不能复用manager本身uodateChat函数
 好友关系发生变化 查询比对成本略高 一律全量更新一次
 */
- (void)updateCombineChatWhenChatReleationChange:(BOOL)needUpdateMessage;

//子账号新的消息来了 或者 主账号的联系人转走了
- (void)updateSubAccountCombineChatWitheMessage:(nonnull GLIMMessage*)message;

/**
 查询联系人数量
 @param respoonse 完成回调
 */
- (void)queryFollowCountFromServerWithresponse:(void(^ _Nonnull)(id _Nullable result))respoonse;

/**
 删除会话
 如果是单聊会话，会发送删除最近联系人的请求
 如果是群聊会话或系统通知等，则只从数据库删除
 
 @param chat 要删除的会话
 @param respoonse 完成回调
 */
- (void)removeChat:(nonnull GLIMChat*)chat response:(void(^ _Nonnull)(id _Nullable result))respoonse;


/**
 清空会话
 会删除聊天 数据 缓存
 @param chatId 要删除的会话
 @param respoonse 完成回调
 */
- (void)cleanChat:(nonnull NSString*)chatId response:(void(^ _Nonnull)(id _Nullable result))respoonse;

/**
 清空聊天记录

 @param chatId 聊天对象
 @param isForSubAccount YES: 主账号为子账号的联系人清空聊天记录, NO: 主账号为自己的联系人清空聊天记录
 @param respoonse 处理结果
 */
- (void)cleanChat:(nonnull NSString*)chatId
  isForSubAccount:(BOOL)isForSubAccount
         response:(void(^ _Nonnull)(id _Nullable result))respoonse;

//兼容上面的方法
- (void)cleanChat:(nonnull NSString*)chatId
              pam:(NSDictionary *)pam
         response:(void(^ _Nonnull)(id _Nullable result))respoonse;


//清空本地所有的未读数
- (void)clearLocalAllUnReadCountWithCompletion:(GLIMCompletionBlock)completion;
-(BOOL )startClearLocalAllUnReadCountexecuteUpdateSqlDb:(FMDatabase *)db clearNoReadMessageType:(GLIMChatManagerClearNoReadMessageType)clearNoReadMessageType;

#pragma mark - CRUD of chats

/**
 从DB批量删除会话，不发送网络请求
 
 @param chatsIDs 要删除的会话ID
 @param hasTemChat 是否要删除临时会话
 @return YES：操作成功，NO：操作失败
 */
- (BOOL)removeChatsFromDBByIDs:(nonnull NSArray<NSString*>*)chatsIDs
                    hasTemChat:( BOOL)hasTemChat;

- (BOOL)removeChatsFromDBByIDs:(nonnull NSArray<NSString*>*)chatsIDs
hasTemChat:( BOOL)hasTemChat
                isPersonalChat:(BOOL)isPersonalChat;

/**
 批量转换好友为非好友， 来源为拉取好友联系人接口
 
 @param chatsIDs 要转换的好友列表
 @return YES：转换成功，NO：转换失败
 */
- (BOOL)changeChatsToTemChat:(nonnull NSArray<NSString*>*)chatsIDs;

/**
 批量转换非好友为好友，来源为拉取好友联系人接口
 
 @param chatsIDs 要转换的非好友列表
 @return YES：转换成功，NO：转换失败
 */
- (BOOL)changeChatsToFriend:(nonnull NSArray<NSString*>*)chatsIDs;

#pragma mark - top status of chats

/// 发送置顶请求
/// @param chat 联系人对象
/// @param completion 回调函数
- (void)onlyRequestChangeTopStatusWithChat:(nonnull GLIMChat *)chat completion:(nonnull GLIMCompletionBlock)completion;

/**
 切换会话置顶状态，
 
 @param chat 被修改的会话
 @param respoonse 回调
 */
- (void)changeTopStatusForChat:(nonnull GLIMChat*)chat
                      response:(void (^ _Nullable)(id _Nullable responeObject, NSError* _Nullable error))respoonse;


/**
 标记未读
 */
- (void)chatNoReadFlagWithChat:(nonnull GLIMChat*)chat
                      response:(void(^ _Nonnull)(id _Nullable result))respoonse;

/**
 置顶会话数量
 
 @return 置顶数量
 */
- (UInt16)topChatsCount;

#pragma mark -
/// 获取临时好友数量
- (NSInteger)getTemChatCount;
//回获取h好友数量
- (NSInteger)getFriendChatCount;

#pragma mark -
//获取 聚合Chat的lastMessage
- (void)getCombineChatLastMessage:(void(^ _Nullable)(GLIMMessage * _Nullable message))respoonse;
//获取 聚合chat的user
- (void)getCombineUser:(void(^ _Nullable)(GLIMUser* _Nullable user))respoonse;
//获取 子账号聚合chat的user
- (void)getSubAccountCombineUser:(void(^ _Nullable)(GLIMUser* _Nullable user))respoonse;
// 重置 联系人聊表拉取 起始时间
- (void)resetChatSyncTimestamp;

/// 获取临时消息的serverMsgID最大值
- (nullable NSString *)maxCombineChatServerMsgID;

/// 根据消息获取@的类型
- (GLIMAtSomeoneType)atSomeoneTypeWithMessage:(nonnull GLIMMessage *)message;
@end

#pragma mark - 联系人同步请求
@interface GLIMChatManager (ChatSync)

/**
 发起好友最近联系人同步
 默认需要上报加载联系人日志
 
 @param response 完成回调，如果发生错误则是Error，如果成功则返回更新的数量
 */
- (void)syncRecentChatsWithResponse:(void (^ _Nullable)(id _Nullable result))response;

/**
 发起好友最近联系人同步
 
 @param response 完成回调，如果发生错误则是Error，如果成功则返回更新的数量
 @param needLog 是否需要上报加载联系人日志
 */
- (void)syncRecentChatsWithResponse:(void (^ _Nullable )(id _Nullable result))response needLog:(BOOL)needLog;

/**
 发起最近临时联系人同步
 
 @param response 完成回调，如果发生错误则是Error，如果成功则返回更新的数量
 */
- (void)syncTemRecentChatsWithResponse:(void (^ _Nullable)(id _Nullable result))response;

@end

#pragma mark - 查询联系人列表
@interface GLIMChatManager (DBOperation)

/**
 根据ID查询数据库中对应的联系人信息

 @param chatID 联系人ID
 @param respoonse 回调函数，成功返回联系人信息，失败返回nil
 */
- (void)chatByID:(nonnull NSString*)chatID
        response:(void(^ _Nonnull)(GLIMChat* _Nullable chat))respoonse;

- (void)chatByIDChatIds:(nonnull NSArray*)chatIDs
               response:(void(^ _Nonnull)(NSMutableArray* _Nullable chats))respoonse;


/// 根据chatID获取联系人
- (GLIMChat *)dbPersonalChatWithChatID:(NSString *)chatID;

#pragma mark - 查询联系人列表，区分联系人类型及好友非好友关系
/**
 从本地数据库分页查询联系人列表，支持区分联系人类型、联系人好友关系
 
 @param pageNo 页号 0开始
 @param pageLimit 页面大小
 @param offset 页面偏移 无特殊需求 传0即可
 @param chatType 联系人类型
 @param isTemporary 好友状态，0-好友关系，1-临时好友
 @param respoonse 回调，返回联系人列表
 */
- (void)queryRecentChatsFromPage:(UInt16)pageNo
                           limit:(UInt16)pageLimit
                          offset:(UInt16)offset
                        chatType:(GLIMChatType)chatType
                 temporaryStatus:(BOOL)isTemporary
                        response:(void(^ _Nonnull)(NSArray<GLIMChat*>* _Nullable chats))respoonse;

/**
 从本地数据库分页查询好友列表
 
 @param pageNo    页号 0开始
 @param pageLimit 页面大小
 @param offset    页面偏移 无特殊需求 传0即可
 @param respoonse 回调
 */
- (void)queryRecentChatsFromPage:(UInt16)pageNo
                           limit:(UInt16)pageLimit
                          offset:(UInt16)offset
                        response:(void(^ _Nonnull)(NSArray<GLIMChat*>* _Nullable chats))respoonse;


- (void)queryRecentChatsFromPage:(UInt16)pageNo
                           limit:(UInt16)pageLimit
                          offset:(UInt16)offset
                      fromSouceS:(NSArray *)fromSouces
                        response:(void(^ _Nonnull)(NSArray<GLIMChat*>* _Nullable chats))respoonse;

/**
 从本地数据库分页查询好友会话
 用于从服务端请求完数据后 第一次加载数据库联系人
 主要是为了数据库修复逻辑和UI解耦
 @param pageNo    页号 0开始
 @param pageLimit 页面大小
 @param offset    页面偏移 无特殊需求 传0即可
 @param respoonse 回调
 */
- (void)queryRecentChatsFromPageAfterService:(UInt16)pageNo
                                       limit:(UInt16)pageLimit
                                      offset:(UInt16)offset
                                    response:(void(^ _Nonnull)(NSArray<GLIMChat*>* _Nullable chats))respoonse;


- (void)queryRecentChatsFromPageAfterService:(UInt16)pageNo
                                       limit:(UInt16)pageLimit
                                      offset:(UInt16)offset
                                  fromSouceS:(NSArray *)fromSouces
                                    response:(void(^ _Nonnull)(NSArray<GLIMChat*>* _Nullable chats))respoonse;

/**
 从本地数据库分页查询临时会话
 
 @param pageNo    页号
 @param pageLimit 页面大小
 @param offset    页面偏移 无特殊需求 传0即可
 @param respoonse 回调
 */
- (void)queryTemRecentChatsFromPage:(UInt16)pageNo
                              limit:(UInt16)pageLimit
                             offset:(UInt16)offset
                           response:(void(^ _Nonnull)(NSArray<GLIMChat*>* _Nullable chats))respoonse;

#pragma mark - 查询联系人列表，仅区分联系人类型
/**
 从本地数据库分页查询联系人列表，支持区分联系人类型
 
 @param pageNo 页号 0开始
 @param pageLimit 页面大小
 @param offset 页面偏移 无特殊需求 传0即可
 @param chatType 联系人类型
 @param respoonse 回调，返回联系人列表
 */
- (void)queryRecentChatsFromPage:(UInt16)pageNo
                           limit:(UInt16)pageLimit
                          offset:(UInt16)offset
                        chatType:(GLIMChatType)chatType
                        response:(void(^ _Nonnull)(NSArray<GLIMChat*>* _Nullable chats))respoonse;

#pragma mark - 查询指定群类型的联系人列表
/**
 从本地数据库分页查询指定类型的群联系人列表

 @param pageNo 页号 0开始
 @param pageLimit 页面大小
 @param offset 页面偏移 无特殊需求 传0即可
 @param groupTypeArray 群类型数组，如果为空则表示全部
 @param groupIdentifyArray 当前用户在群中的成员身份
 @param respoonse 回调，返回联系人列表
 */
- (void)queryGroupChatsFromPage:(UInt16)pageNo
                          limit:(UInt16)pageLimit
                         offset:(UInt16)offset
                 groupTypeArray:(NSArray *)groupTypeArray
             groupIdentifyArray:(NSArray *)groupIdentifyArray
                       response:(void(^ _Nonnull)(NSArray<GLIMChat*>* _Nullable chats))respoonse;

#pragma mark - 

/**
 移除数据库中的联系人数据
 暂时只支持群（单聊需要调整临时消息后一起处理）

 @param chat 指定联系人
 @param completion 回调函数
 */
- (void)removeChatInDB:(nonnull GLIMChat *)chat
            completion:(void(^ _Nonnull)(id _Nullable result))completion;


/**
 批量删除数据库中的群联系人数据

 @param chatIDArray 群联系人ID数组
 @return YES : 成功
 */
- (BOOL)batchRemoveGroupChatsInDB:(nonnull NSArray *)chatIDArray;



/**
 从服务器分页查询子账号联系人数据
 
 @param pageNo    页号
 @param pageLimit 页面大小
 @param subUid    子账号
 @param isTemporary 好友状态，0-好友关系，1-临时好友
 @param respoonse 回调
 */
- (void)querySubAuuountRecentChatsFromServicePage:(UInt16)pageNo
                                            limit:(UInt16)pageLimit
                                           subUid:(NSString *_Nullable)subUid
                                  temporaryStatus:(BOOL)isTemporary
                                         response:(void(^ _Nonnull)(NSDictionary* _Nullable resultDict, NSError* _Nullable error))respoonse;




/**
 根据时间戳分页请求全部子账号的联系人

 @param timestamp 时间戳
 @param limit 每页请求条数
 @param respoonse 返回结果
 */
- (void)queryAllSubAccountChatsWithTimestamp:(NSString *_Nullable)timestamp
                                       limit:(NSString *_Nullable)limit
                                    response:(void(^ _Nonnull)(NSDictionary* _Nullable resultDict, NSError* _Nullable error))respoonse;


/**
 根据时间戳分页请求微信公众号联系人

 @param timestamp 时间戳
 @param limit 每页请求条数
 @param respoonse 返回结果
*/
- (void)queryWxOfficialAccountChatsWithTimestamp:(NSString *_Nullable)timestamp
                                           limit:(NSString *_Nullable)limit
                                        response:(void(^ _Nonnull)(NSDictionary* _Nullable resultDict, NSError* _Nullable error))respoonse;

@end

#pragma mark - 未读消息数管理
@interface GLIMChatManager (UnreadCountManager)

/// 获取当前IM登录用户全部未读消息数量
- (NSInteger)getAllUnReadCount;

/**
 获取群未读消息数

 @param isBlock 免打扰状态
 @return 群未读消息数
 */
- (NSInteger)getAllGroupUnreadCountWithBlockStatus:(BOOL)isBlock;

/**
 获取指定类型的临时消息（或好友消息）的未读消息数
 
 @param chatType 联系人类型, 0 普通联系人， 10010 评论联系人 
 @param isTempChat YES 临时消息，NO 好友消息
 @return 未读消息数
 */
- (NSInteger)getUnreadCountWithChatType:(NSInteger)chatType
                             isTempChat:(BOOL)isTempChat;

/**
 获取所有临时消息（或好友消息）的未读消息数
 注：好友消息里包含聚合体临时消息
 
 @param isTemChat YES 临时消息，NO 好友消息
 @return 未读消息数
 */
- (NSInteger)getChatAllUnReadCount:(BOOL)isTemChat;

/**
 获取指定用户的未读消息数
 
 @param chatID chatID
 @return 未读消息数
 */
- (NSInteger)getUnreadCountWithChatID:(nonnull NSString *)chatID;

/// 微信聚合联系人未读数
- (NSInteger)wxOfficialCombineUnreadCount;

/// 聚合联系人屏蔽未读数
- (NSInteger)combineBlockedUnreadCount;

/// 微信聚合小程序未读数
- (NSInteger)wxProgramCombineUnreadCount;

/// 微信聚合小程序屏蔽未读数
- (NSInteger)wxProgramCombineBlockedUnreadCount;

/**
 获取指定用户的最后一条消息的 ID
 
 @param chatID chatID

 */
- (NSString *)getLastMessageServerMsgIDWithChatID:(nonnull NSString *)chatID;


/**
 将一个chat的未读数置为0
 
 @param chat 要设为已读的会话
 @param respoonse 完成回调
 */
- (void)setReadForChat:(nonnull GLIMChat*)chat
              response:(void(^ _Nonnull)(id _Nullable result))respoonse;

//主账号调用
- (void)mainAcccountsetReadForChat:(nonnull GLIMChat*)chat
                          response:(void(^ _Nonnull)(id _Nullable result))respoonse;

- (void)setMarketingReadForChat:(nonnull GLIMChat*)chat response:(void(^ _Nonnull)(id _Nullable result))respoonse;


/**
 将一个chat的数据库未读数置为0 并通知ui更新
 
 @param chat 要设为已读的会话
 */
- (void)clearLocalUnReadCountForChat:(nonnull GLIMChat *)chat;


/**
 为指定联系人清空本地未读消息

 @param chatID 指定联系人ID
 */
- (void)clearLocalUnreadCountWithChatID:(nonnull NSString *)chatID;

// 获取有未读消息的chat的位置
// timeStamp 为int_max 为查找最新的一条
- (NSInteger)getUnreadChatIndex:(UInt64)timeStamp andTemChat:(BOOL)isTemChat andIsTop:(BOOL)isTop;

/// 查询指定未读消息的下一条未读消息
- (NSInteger)getUnreadChatIndex:(UInt64 )timeStamp
                     andTemChat:(BOOL)isTemChat
                       andIsTop:(BOOL)isTop
                      isBlocked:(BOOL)isBlocked;

/**
 为指定联系人更新已读消息ID

 @param readsMsgID 已读消息ID
 @param chatID 联系人ID
 */
- (void)updateReadsMsgID:(nonnull NSString *)readsMsgID forChat:(nonnull NSString *)chatID;

/**
 获取指定联系人缓存的已读消息ID

 @param chatID 指定联系人
 @return 返回指定联系人缓存的已读消息ID
 */
- (nonnull NSString *)readsMsgIDWithChatID:(nonnull NSString *)chatID;

@end

#pragma mark - 联系人的索引
@interface GLIMChatManager (OrderIndex)

// 获取TOPChat的数量
- (NSInteger)getTopChatCount;

#pragma mark - 查询联系人列表，区分联系人类型及好友非好友关系
/**
 比指定会话提前的会话的输了，提前的会话包括置顶会话或更近的会话
 
 @return 更靠前的会话的数量
 */
- (UInt16)orderedIndexForChat:(nonnull GLIMChat*)chat;

- (UInt16)orderedIndexForTemChat:(nonnull GLIMChat*)chat;

/**
 获取联系人在指定联系人列表中的显示位置
 
 @param chat 联系人
 @param chatType 联系人列表类型
 @param isTemporary 好友状态，YES-临时好友，仅单聊时可能为YES
 @return 索引值
 */
- (UInt16)orderedIndexForChat:(nonnull GLIMChat *)chat
                 withChatType:(GLIMChatType)chatType
           andTemporaryStatus:(BOOL)isTemporary;

#pragma mark - 查询联系人列表，仅区分联系人类型
/**
 查询联系人在列表中的位置

 @param chat 联系人对象
 @param chatType 联系人类型，用于区分不同联系人列表
 @return 位置索引
 */
- (UInt16)orderedIndexForChat:(nonnull GLIMChat *)chat
                 withChatType:(GLIMChatType)chatType;

/**
 查询联系人在最近联系人列表中的位置
 最近联系人列表不包含临时消息聚合联系人

 @param chat 联系人对象
 @return 位置索引
 */
- (UInt16)orderedIndexWithoutCombineTempForChat:(nonnull GLIMChat *)chat;

/**
查询联系人在最近联系人列表中的位置
最近联系人列表不包含聚合联系人（临时消息聚合联系人、微信公众号聚合联系人）

@param chat 联系人对象
@return 位置索引
*/
- (UInt16)orderIndexWithoutCombineContactsForChat:(nonnull GLIMChat *)chat;


- (UInt16)orderIndexWithoutCombineContactsForChat:(nonnull GLIMChat *)chat adaptation:(BOOL)adaptation;


/// 查找聊天对象在数据库中的位置
/// @param chat 联系人
/// @param adaptation 是否过滤
/// @param fromSouces 筛选条件
- (UInt16)orderedIndexWithChat:(nonnull GLIMChat *)chat adaptation:(BOOL)adaptation fromSouces:(nonnull NSArray *)fromSouces;

@end

#pragma mark - 临时消息
@interface GLIMChatManager (TemporaryChat)

/// 检查本地是否有临时好友
- (BOOL)hasTemporaryChats;

@end


@interface GLIMChatManager (TransferChatContacts)

- (void)saveTransferChatContacts:(NSString *_Nullable)uid;
- (void)delTransferChatContacts:(NSString *)uid;
- (BOOL)isHaveTransferChatContacts:(NSString *)uid;
- (void)clearTransferChatContacts;

@end

