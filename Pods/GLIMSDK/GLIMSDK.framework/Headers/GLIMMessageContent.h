//
//  GLIMMessageContent.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMBaseObject.h"


typedef NS_ENUM(NSInteger, GLIMMessageContentType) {
    GLIMMessageContentText = 1,
    GLIMMessageContentImage = 2,
    GLIMMessageContentSound = 3,
    GLIMMessageContentBigEmoji  = 7,        // 大表情
    GLIMMessageContentCard = 8,             // 卡片
    GLIMMessageContentVideo = 12,           // 视频
    GLIMMessageContentFile = 13,            // 文件
    GLIMMessageContentCustomized = 100000,
    GLIMMessageContentInteractionCombination = 100 //自定义卡片组合
};


/**
 消息内容实体，用来封装各种媒体类型消息的差异逻辑
 */
@interface GLIMMessageContent : GLIMBaseObject {
}

/**
 消息类型
 */
@property (nonatomic) GLIMMessageContentType type;

/**
 消息的简单文本内容
 */
@property (nonatomic, strong) NSString* text;

/**
 消息的简单显示内容，一般情况下与text相同
 */
@property (nonatomic, strong, readonly) NSString *displayText;

/**
 消息的详细内容
 */
@property (nonatomic, strong) NSString* detail;

/**
 服务端用来存放一些特殊的数据 json string 格式
 */
@property (nonatomic, strong) NSString* userData;

/**
 待发送消息的文本内容，默认与Text相同
 */
@property (nonatomic, strong, readonly) NSString *sendText;

/**
 消息的行为，例如音频信息的行为是播放，图片信息的行为是查看图片内容等。
 自定义消息则可以设置任何响应回调。
 */
@property (nonatomic, copy) void (^action)(GLIMMessageContent*);

#pragma mark - 消息撤回
//是否撤回的系统消息
@property (nonatomic, assign, readonly) BOOL isWithdrawSystemMessage;
//此条消息是否可以撤回
@property (nonatomic, assign, readonly) BOOL isCanWithdraw;
/// 标识下是否单聊的撤回消息
@property (nonatomic, assign, readonly) BOOL isPersonalWithdrawMessage;
/// 标识下是否 是删除消息
@property (nonatomic, assign, readonly) BOOL isDeleteSystemMessage;
/// 是否是特特处理消息
@property (nonatomic, assign, readonly) BOOL isSpecialMessage;
/// 标识下是否同步过来的撤回消息，1-同步消息 0-默认
@property (nonatomic, assign) NSInteger isSyncWithdrawMessage;
/// 撤回消息中带的未读数，仅用于对方发送的撤回消息
@property (nonatomic, assign) NSInteger unreadCountInWithdraw;

- (BOOL)isValidMessage;

/**
 从另一个GLIMMessageContent赋值

 @param content 赋值来源
 */
- (void)setInfoFromContent:(GLIMMessageContent*)content;

/**
 子类实现去解析消息内容的detail字段
 */
- (void)parseDetailFromDict:(NSDictionary*)dict;

#pragma mark - 文件上传
//子类自己实现
/// 是否需要上传文件
- (BOOL)needUploadFile:(NSString *)chatID;

/// 获取上传数据
- (id)getUploadFileData:(NSString *)chatID;

/// 本地是否存在数据
- (BOOL)isExistFileDataInLocal:(NSString *)chatID;

/// 文件上传后更新相关信息
- (void)updateFileInfoAfterUploadSucceed:(NSDictionary *)fileInfos
                              withChatID:(NSString *)chatID;

#pragma mark - 扩展业务
/// 消息内容是不是包含屏蔽消息
- (BOOL)containBlockNotify;
/// 消息内容是不是来自好友
- (BOOL)isFromFriend;
//屏蔽消息消息显示送达
- (BOOL)isHaveblockFlag;
/// 风控消息是否显示送达/已读
- (BOOL)isAntispam;
/// 更新风控信息
- (void)updateAntispamFlag:(NSInteger)antispamFlag;

#pragma mark - detail字段

/// 为detail追加字段
/// @param infoValue 字段内容
/// @param infoKey 字段key
- (void)detailAppendInfo:(id)infoValue withKey:(NSString *)infoKey;

/// 获取detail中的扩展字典信息
/// @param infoKey 扩展字段key
- (NSDictionary *)detailAppendedDictWithKey:(NSString *)infoKey;

#pragma mark - userData字段
/// 为userData追加字段
/// @param infoValue 字段内容
/// @param infoKey 字段key
- (void)userDataAppendInfo:(id)infoValue withKey:(NSString *)infoKey;

/// 获取userData中的扩展字典信息
/// @param infoKey 扩展字段key
- (NSDictionary *)userDataAppendedDictWithKey:(NSString *)infoKey;

@end
