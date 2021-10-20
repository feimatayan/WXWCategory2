//
//  GLIMMessage.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMBaseObject.h"
#import "GLIMMessageContent.h"

/// 按聊天类型区分消息
typedef NS_ENUM(NSInteger, GLIMMessageChatType) {
    GLIMMessageChatPersonal = 0,    // 单聊消息
    GLIMMessageChatGroup    = 1,    // 群聊消息
    GLIMMessageChatCount            // 占位
};

/// 按消息发送方来区分消息
typedef NS_ENUM(NSInteger, GLIMMessageType) {
    GLIMMessageTypeNormal = 1,      // 普通消息（用户主动发送）
    GLIMMessageTypeAuto = 2,        // 自动回复消息（服务器发送）
    GLIMMessageTypeSystem = 3       // 系统消息（服务器主动通知）
};

typedef NS_ENUM(NSInteger, GLIMMessageStatus)
{
    GLIMMessageStatusSending    = 10,       // 消息发送中
    GLIMMessageStatusFailed     = 11,       // 消息发送失败
    GLIMMessageStatusSucess     = 12,       // 消息发送成功
};


/**
 消息实体
 */
@interface GLIMMessage : GLIMBaseObject

#pragma mark - 持久化字段
/// 服务器生成的消息ID
@property (nonatomic, strong) NSString* serverMsgID;
/// 本地根据时间生成的消息ID，
/// 服务器端会将此ID返回，供客户端使用以查找确定发送消息。
@property (nonatomic, strong) NSString* msgID;
/// 消息发送方的im账号ID
@property (nonatomic, strong) NSString* fromUID;
/// 消息发送方的子账号（子客服）的im账号ID，如果发送方不是子账号，则值为空或"0"
@property (nonatomic, strong) NSString* fromInnerUID;

@property (nonatomic, strong) NSString* shopUid;

//会话的 sessionID

@property (nonatomic, strong) NSString* sessionID;

//子账号的昵称
@property (nonatomic, strong) NSString* serviceUserName;
//消息是从哪个子账号发过来的 用来更新联系人
@property (nonatomic, strong) NSString* toInnerUid;

/// 消息接收方的im账号ID
@property (nonatomic, strong) NSString* toUID;
/// 消息发送的时间戳
@property (nonatomic) UInt64 timestamp;
//上一条消息的发送时间
@property (nonatomic) UInt64 lastMsgTime;

/// 消息的类型（普通消息、系统消息等）
@property (nonatomic) GLIMMessageType type;
/// 消息所属的聊天类型（单聊消息、群聊消息）
@property (nonatomic) GLIMMessageChatType chatType;
/// 消息的具体内容
@property (nonatomic, strong) GLIMMessageContent* content;
/// 消息发送状态(初始是失败 可手动赋值 跟服务器无关)
@property (nonatomic) GLIMMessageStatus status;
/// 标识消息的实际发送方，默认为0，1-消息由主账号代发，2-微信小程序
@property (nonatomic, assign) NSInteger msgSource;

@property (nonatomic, assign) NSInteger faultTolerantFlag;

/// 标识消息仅保存在本地，默认为0：表示消息是从服务器同步下来的，1：表示消息仅是本地存储
@property (nonatomic, assign) NSInteger onlyInLocal;

/// 收到的消息是否提醒买家版显示通知，1 显示通知， 0 不显示通知，默认为显示通知
@property (nonatomic, assign) NSInteger needNotifyForBuyer;
/// 收到的消息是否提醒卖家版显示通知，1 显示通知， 0 不显示通知，默认为显示通知
@property (nonatomic, assign) NSInteger needNotifyForSeller;

#pragma mark - 缓存字段
/// 不入库 目前只是用于接收到消息后发送给服务端的ack
@property (nonatomic,assign) int fromSourceType;
/// 是否重试
@property (nonatomic, assign) BOOL isRetry;
@property (nonatomic, assign) BOOL isNeedReSendMessage;
// 重发次数 默认 0
@property (nonatomic, assign) NSInteger reSendNum;
// 标识是不是从数据库中加载的发送失败消息
@property (nonatomic, assign) BOOL isFailedInDB;
/// 是否显示撤回菜单
@property (nonatomic, assign, readonly) BOOL isShowWithdraw;
/// 标识是否强弱通知, 0-强通知 1-弱通知 2-超强通知
@property (nonatomic, assign) NSInteger strongWeakNotify;
/// 是否是讲师的消息
@property (nonatomic, assign) BOOL isFromTeacherMessage;

/// 是否超时发送的消息
@property (nonatomic, assign) BOOL isSendTimeOutMessage;

@property (nonatomic, assign) NSInteger messageStatusFailedCode;

/// 是否主账号同步给子账号或者子账号同步给子账号的消息
@property (nonatomic, assign) BOOL isFromSubInstantAccountMessage;

//来自微信公众号的消息
@property (nonatomic, assign) BOOL isFromWeiXinMessage;
/// 来自微信小程序的消息
@property (nonatomic, assign) BOOL isFromWxProgram;

//发送者昵称
@property (nonatomic, copy) NSString *sendMessageName;
//是否不重发 默认0重发  微信不重发
@property (nonatomic, assign) NSInteger isNotReSend;

/// 是否已经曝光，默认为NO，创建于20190104，用于控制曝光日志上报的频度
@property (nonatomic, assign) BOOL isExposured;

/// 是否使用包含通知标题(消息的发送方标题)，默认为NO
@property (nonatomic, assign) BOOL hasNotifyTitle;
/// 消息的发送方标题，默认为空
@property (nonatomic, copy) NSString *notifyTitle;

//当前搜索到的消息的关键字
@property (nonatomic, copy) NSString *messageSearchKeyText;
@property (nonatomic, assign) BOOL isMessageShowsearchKeyText;

@property (nonatomic, assign) NSInteger buyerVersionShow;
@property (nonatomic, assign) NSInteger shopVersionShow;

/// 消息发送前是否需要检查IM登录成功，默认为NO
@property (nonatomic, assign) BOOL needCheckConnectionBeforeSend;
/// 标识消息发送前正在等待IM登录成功，默认为NO
@property (nonatomic, assign) BOOL isWaitingForConnected;

/// 记录接收到消息时的时间戳，仅用于统计
@property (nonatomic, assign) UInt64 receviedInterval;

/// 新场地业务：标识是不是自己发送的场地消息
@property (nonatomic, assign) BOOL isMySpaceMessage;

/// 消息发送方是不是自己
- (BOOL)sentByMe;
/// 消息是不是包含屏蔽信息（用于控制屏蔽消息的显示）
- (BOOL)containBlockNotify;
/// 检查当前消息是不是来自好友
- (BOOL)isFromFriend;
/// 返回信息发送时间的字符串描述
- (NSString*)messageDateDesc;
/// 判断两条消息是否相同
- (BOOL)isSameMessage:(GLIMMessage *)other;

//设置userdata属性
- (void)addContentUserDataWithValue:(NSString *)value withKey:(NSString *)key;
- (void)addContentUserDataWithValueDic:(NSDictionary *)dic;
#pragma mark - 文件上传相关方法
/// 是否需要上传文件
- (BOOL)needUploadFile;
/// 获取上传数据
- (id)getUploadFileData;
/// 本地是否存在数据
- (BOOL)isExistFileDataInLocal;
/// 保存文件数据 并更新文件缓存路径 用于上传成功后
- (void)updateFileInfoAfterFileUploadSucess:(NSString *)fileUrl;

/// 文件上传成功后更新消息数据
/// @param fileInfos 待更新信息
- (void)updateFileInfoAfterUploadSucceed:(NSDictionary *)fileInfos;


- (BOOL)isMessageEssence;

#pragma mark - 业务方法
/**
 生成本地消息的msgid，用于消息去重

 @return 本地消息的msgid
 */
+ (NSString *)generateMsgID;

/**
 查找指定联系人的最后一条消息

 @param chatId 指定联系人ID
 @return 最后一条消息
 */
+ (GLIMMessage *)getNewestMessageFormSqlWithChatID:(NSString *)chatId;


/// 消息概述，用于打印或上传日志
- (NSDictionary *)messageInfo;

- (NSString *)messageDebugInfo;

@end
