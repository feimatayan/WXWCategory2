//
//  GLIMSearchManager.h
//  GLIMSDK
//
//  Created by 六度 on 2017/8/29.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLIMChat;
@class GLIMGroupMember;

/**
 搜索——消息详情结果数据
 */
@interface GLIMSearchMessageResultData : NSObject

/// 消息发送方uid（字符串）
@property (nonatomic, copy) NSString *sendUID;
/// 消息发送方uid（整型）
@property (nonatomic, copy) NSString *sendUIDLong;
/// 消息发送方头像
@property (nonatomic, copy) NSString *sendAvatarUrl;
/// 消息发送方昵称
@property (nonatomic, copy) NSString *sendNickName;
/// 消息发送方备注
@property (nonatomic, copy) NSString *sendNote;
/// 消息内容
@property (nonatomic, copy) NSString *msgData;
/// 消息ID（服务器)
@property (nonatomic, copy) NSString *msgID;
/// 消息时间戳
@property (nonatomic, assign) UInt64 msgTime;

+ (instancetype)resultDataWithDictionary:(NSDictionary *)dict;

- (NSString *)senderDisplayName;

@end

/**
 搜索——联系人消息结果数据
 */
@interface GLIMSearchContactResultData : NSObject

// 消息总数
@property (nonatomic, assign) NSInteger messageCount;
@property (nonatomic, copy) NSString *contactID;
@property (nonatomic, copy) NSString *mainContactID;
@property (nonatomic, copy) NSString *contactIDLong;
// 联系人类型 0 群聊 1 单聊
@property (nonatomic, copy) NSString *contactType;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *realUid;

+ (instancetype)resultDataWithDictionary:(NSDictionary *)dict;

- (NSString *)displayName;

- (BOOL)isSupportShow;

@end

@interface GLIMChatSearchData : NSObject

@property (nonatomic, strong) GLIMChat *chat;
@property (nonatomic, strong) GLIMGroupMember *groupMember;

@property (nonatomic, assign) BOOL isSearchDataChatMessageHistory;

#pragma mark - 消息搜索
/// 消息详情
@property (nonatomic, strong) GLIMSearchMessageResultData *messageResultData;
/// 联系人信息
@property (nonatomic, strong) GLIMSearchContactResultData *contactResultData;

/// 消息数目——标题使用
@property (nonatomic, strong, readonly) NSString *resultTitleString;
/// 消息数目——内容使用
@property (nonatomic, strong, readonly) NSString *resultDisplayString;

/**
 构造聊天对象信息

 @param searchKey 搜索关键字
 @return 实际聊天对象
 */
- (GLIMChat *)jumpChatWithSearchKey:(NSString *)searchKey;

/**
 构造聊天对象信息

 @param searchKey 搜索关键字
 @param messageResultData 匹配的结果消息
 @return 实际聊天对象
 */
- (GLIMChat *)jumpChatWithSearchKey:(NSString *)searchKey
                  messageResultData:(GLIMSearchMessageResultData *)messageResultData;

/**
 解析搜索结果——联系人

 @param dict 字典信息
 @return 搜索结果
 */
+ (instancetype)chatSearchDataWithDictionary:(NSDictionary *)dict;

/**
 解析搜索结果——消息

 @param dict 字典信息
 @return 搜索结果
 */
+ (instancetype)messageSearchDataWithDictionary:(NSDictionary *)dict;

@end

/// 单类型联系人搜索回调函数
typedef void (^GLIMChatSearchBlock)(NSArray<GLIMChatSearchData *> *searchDataArray);
/// 全类型联系人搜索回调函数
typedef void (^GLIMChatSearchAllBlock)(NSDictionary *searchDataDict);

@interface GLIMSearchManager : NSObject

//+ (instancetype _Nullable)shareManager;
//
//- (void)queryChatHasString:(NSString * _Nullable)searchStr response:(void(^ _Nonnull)(NSArray<GLIMChat*>* _Nullable chats))respoonse;

+ (instancetype)sharedInstance;

/**
 查询所有类型的联系人

 @param searchKey 查询关键字
 @param completion 回调函数（返回查询结果{@"personal":[],@"group":[]}）
 */
- (void)queryChatsWithString:(NSString *)searchKey completion:(GLIMChatSearchAllBlock)completion;


/**
 查询单聊联系人

 @param searchKey 查询关键字
 @param completion 回调函数（返回查询结果，数组或nil）
 */
- (void)queryPersonalChatsWithString:(NSString *)searchKey
                          completion:(GLIMChatSearchBlock)completion;

/**
 查询群聊联系人

 @param searchKey 查询关键字
 @param completion 回调函数（返回查询结果，数组或nil）
 */
- (void)queryGroupChatsWithString:(NSString *)searchKey
                       completion:(GLIMChatSearchBlock)completion;


- (void)queryHistoryMessageWithString:(NSString *)searchKey
                           isLoadMore:(BOOL)isLoadMore
                           completion:(GLIMChatSearchBlock)completion;

@end
