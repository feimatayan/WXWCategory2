//
//  GLIMChat.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMBaseObject.h"
#import "GLIMContact.h"
#import "GLIMMessage.h"
#import "GLIMChatSource.h"
#import "GLIMSDKInterface.h"

typedef NS_ENUM(NSInteger, GLIMAtSomeoneType) {
    GLIMAtSomeoneNone = 0,                                      // 无at标志
    GLIMAtSomeoneMe = 1 << 0,                                   // 有人@我
    GLIMAtSomeoneAll = 1 << 1,                                  // @所有人
    GLIMAtSomeoneAllAndMe = GLIMAtSomeoneMe | GLIMAtSomeoneAll, // @所有人 + 有人@我
};


typedef NS_ENUM(NSInteger, GLIMCuttrntChatType) {
    GLIMCuttrntChatTypeNone = 0,                                      // 默认会话
    GLIMCuttrntChatTypeLookSubAccount = 1 << 0,                       // 主账号查看子账号会话
    GLIMCuttrntChatTypeWeiXin = 1 << 1,                               // 微信公账号会话

};

/// 单聊联系人咨询来源
typedef NS_ENUM(NSInteger, GLIMChatFromSourceType) {
    GLIMChatFromSourceNone = 0,         // 默认来源
    GLIMChatFromSourceAppBuyer = 1,     // 微店App
    GLIMChatFromSourceH5 = 2,           // 微店页面
    GLIMChatFromSourceWxProgram = 3,    // 专享小程序
    GLIMChatFromSourceWxOfficial = 4,   // 微信公众号
    GLIMChatFromSourceTxLive = 5,       // 腾讯直播
    GLIMChatFromSourceAppSeller = 6,    // 店长端
    GLIMChatFromSourceWeidianPlus = 7,  // 微店+
    GLIMChatFromSourcePrivateDistribution = 8,  // 私域分销
    GLIMChatFromSourceWeidianMaiMai = 9,    // 微店卖卖
    GLIMChatFromSourceShangCheTuan = 10,    // 上车团
};

/// 单聊联系人类型
typedef NS_ENUM(NSInteger, GLIMContactSourceType) {
    GLIMContactSourceNone = 0,      // 默认值
    GLIMContactSourceNormal = 1,    // 普通联系人
    GLIMContactSourceWxOffical = 2, // 微信公众号
    GLIMContactSourceWxProgram = 3, // 微信小程序
};


/**
 会话实体，客户端定义用来表示最近联系人会话信息，
 由于服务器端并不存在会话概念，因此信息需要在客户端生成，
 使用聊天对象联系人ID作为会话ID
 */
@interface GLIMChat : GLIMBaseObject


/**
 聊天会话ID，有客户端生成，值等于聊天对象的用户ID
 */
@property (nonatomic, strong) NSString* chatID;

/**
 未读数
 */
@property (nonatomic) UInt16 unreadCount;
//请求未读数是不是失败的
@property (nonatomic) BOOL getUnreadCountError;

/**
 是否置顶
 */
@property (nonatomic) BOOL isTopChat;

/**
 聊天对象
 */
@property (nonatomic, strong) GLIMContact* pairContact;

/**
 聊天的最近一条信息
 */
@property (nonatomic, strong) GLIMMessage* lastMessage;

//当前会话搜索到的消息
@property (nonatomic, assign) BOOL isChatSearchModel;
@property (nonatomic, strong) GLIMMessage* searchMessage;


/// 消息来源
@property (nonatomic, strong) GLIMChatSource* chatSource;

/// 是否临时会话
@property (nonatomic) BOOL isTemChat;

/// 联系人是否不可见，NO - 可见，YES - 不可见，默认是可见的
@property (nonatomic, assign) BOOL isInvisible;

//联系人标记未读
//NO 已读 默认
//YES 未读
@property (nonatomic, assign) BOOL noReadFlag;

/**
 * 咨询来源 目前有 0-默认、1-微店APP、2-微店页面、3-专享小程序、4-公众号、5-腾讯直播、6-店长端、7-微店+、8-私域分销、9-微店卖卖
 */
@property (nonatomic, assign) GLIMChatFromSourceType fromSource;
/**
 * 咨询用户类型 1-普通 2-公众号 3-小程序
 */
@property (nonatomic, assign) GLIMContactSourceType userSourceType;

//如果筛选列表里有 说明是筛选过程中 改变了来源 这个时候只改变最后意一条消息 不改变来源
@property (nonatomic, assign) BOOL use_fromSource_old;
@property (nonatomic, assign) NSInteger fromSource_old;

@property (nonatomic) NSInteger deleteFlag;

/// 是否是子账号会话实例(暂时不统一使用 各用个的)
//子账号聊天记录使用
@property (nonatomic) BOOL isSubAccountChat;
//子账号会话实时更新消息
@property (nonatomic) BOOL isSubInstantAccountChat;

//是否是微信回复会话
@property (nonatomic) BOOL isWeiXinChat;
/// 是否微信小程序回复会话，仅缓存用——区别微信公众号
@property (nonatomic, assign) BOOL isWeiXinProgram;

//是否是离线消息池的会话
@property (nonatomic) BOOL isOffLineMessagePoolChat;
@property (nonatomic) BOOL isSelectChat;
@property (nonatomic, assign) NSTimeInterval waitTime;
//离线消息池接待的子账号 id;
@property (nonatomic,strong) NSString * subUid;

/// @标志
@property (nonatomic, assign) GLIMAtSomeoneType atSomeoneType;

//已读消息的锚点
//read_smsgid＝0，前端将本会话所有消息置为已读
//前端对本会话消息中<min_msgid置为已读，>=min_msgid保持未读状态
@property (nonatomic,strong) NSString * readSmsgid;

//透传的参数
@property (nonatomic,strong) NSDictionary * chatDicPam;


/**
 contact转换成ChatType
 */
- (GLIMChatType)pairContactType;

/**
 不更新ChatSource的更新语句
 */
- (NSString *)updateSQLWithoutChatSource;

/**
 本地不识别的最近联系人

 @return 默认为NO，但遇到新增的联系人类型时为YES
 */
- (BOOL)isUnrecognizedChat;

- (NSDictionary*)propertiesDictWithlastMessageId:(NSString *)lastMessageId;

@end

