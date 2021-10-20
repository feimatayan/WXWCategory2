//
//  GLIMSDKInterface.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/3/29.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLIMMessage;

/// IM支持数据类型
typedef NS_OPTIONS(NSUInteger, GLIMChatType)
{
    GLIMChatTypePersonal   = 1 << 0,    // 个人聊天
    GLIMChatTypeGroup      = 1 << 1,    // 群聊天
    GLIMChatTypeOfficial   = 1 << 2,    // 公众号
    GLIMChatTypeAll        = (GLIMChatTypePersonal | GLIMChatTypeGroup | GLIMChatTypeOfficial),    // 个人+群+公众号
    GLIMChatTypeSystem     = 10000,     // 系统消息
};


#pragma mark - 枚举值
/// App类型
typedef NS_ENUM(NSUInteger, GLIMAppSourceType)
{
    GLIMAppSourceTypeUnknown                    = 0,
    GLIMAppSourceTypePcHtml                     = 1001,     // PC
    GLIMAppSourceTypeNativeIosWeidian           = 5001,     // 微店
    GLIMAppSourceTypeNativeIosKoudai            = 5002,     // 口袋
    GLIMAppSourceTypeNativeIosBanjia            = 5003,     // 半价
    GLIMAppSourceTypeNativeIosDaigou            = 5004,     // 微店全球购
    GLIMAppSourceTypeNativeIosWeidianBuyer      = 5005,     // 微店买家版
    GLIMAppSourceTypeNativeIosUShop             = 5006,     // 微店UShop
    GLIMAppSourceTypeNativeIosShangXin          = 5007,     // 微店上心
    GLIMAppSourceTypeNativeIosWeidianBuyer2     = 5008,     // 微店买家版2.0
};

typedef NS_ENUM(NSUInteger, GLIMIdentityType)
{
    GLIMIdentityNone,   // 无
    GLIMIdentityBuyer,  // 买家
    GLIMIdentitySeller, // 卖家
};


/**
 SDK 统一对外接口
 */
@interface GLIMSDKInterface : NSObject

/// 支持的聊天类型(默认单聊）
@property (nonatomic, assign) GLIMChatType supportChatType;

/// 当前app的类型
@property (nonatomic, assign, readonly) GLIMAppSourceType appSourceType;

/// 配置文件上传组件的scope
@property (nonatomic, copy) NSString *fileUploaderScope;

/// 配置视频上传组件的scope
@property (nonatomic, copy) NSString *videoUploaderScope;

+ (instancetype)sharedInstance;

/**
 SDK 初始化工作，支持所有聊天类型
 @param appSourceType App来源，不能为空
 @param clientID 客户端ID，不能为空
 */
+ (void)initSDKWithSourceType:(GLIMAppSourceType)appSourceType
                  andClientID:(NSString *)clientID;

/**
 SDK 初始化工作

 @param appSourceType App来源，不能为空
 @param chatType 支持的聊天类型，不能为空
 @param clientID 客户端ID，不能为空
 */
+ (void)initSDKWithSourceType:(GLIMAppSourceType)appSourceType
                     chatType:(GLIMChatType)chatType
                  andClientID:(NSString *)clientID;

/// 判断是否卖家版
+ (BOOL)isWeiDianSeller;

/// 判断是否买家版
+ (BOOL)isWeiDianBuyer;

#pragma mark - 配置
/**
 注册特殊联系人，用于控制特殊联系人在联系人列表的显示
 所有未注册的特殊联系人都不会显示在联系人列表中

 @param contactType 特殊联系人的联系人类型，如10010， 10020等
 */
+ (void)registerSpecialContactWithType:(NSInteger)contactType;

#pragma mark - 消息发送
/**
 向指定App用户发送单聊消息
 
 @param message 消息数据
 @param userID 指定App用户ID
 @param completion 回调函数
 */
+ (void)sendMessage:(GLIMMessage *)message
         withUserID:(NSString *)userID
         completion:(void (^)(id))completion;


/**
 向指定IM用户发送单聊消息
 
 @param message 消息数据
 @param chatID 指定的IM用户ID
 @param completion 回调函数
 */
+ (void)sendMessage:(GLIMMessage *)message
         withChatID:(NSString *)chatID
         completion:(void (^)(id))completion;

#pragma mark - Only For Demo

/**
 初始化文件上传组件
 */
+ (void)initFileUploaderComponent;


+ (BOOL)isDiscardMessageWithBuyerVersionShow:(NSInteger)buyerVersionShow shopVersionShow:(NSInteger)shopVersionShow;

@end
