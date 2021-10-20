//
//  GLIMAccountManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/17.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMFoundationDefine.h"
#import "GLIMLoginAccount.h"

/// 登录成功
#define GLIMNOTIFICATION_IMLOGIN_SUCESSFULLY    @"GLIMNOTIFICATION_IMLOGIN_SUCESSFULLY"
/// 正在登录
#define GLIMNOTIFICATION_IMLOGIN_LOGGINGIN      @"GLIMNOTIFICATION_IMLOGIN_LOGGINGIN"
/// 登录失败
#define GLIMNOTIFICATION_IMLOGIN_FAIL           @"GLIMNOTIFICATION_IMLOGIN_FAIL"
#define GLIMNOTIFICATION_DID_DISCONNECT         @"GLIMNOTIFICATION_DID_DISCONNECT"
#define GLIMNOTIFICATION_DID_KICKOUT            @"GLIMNOTIFICATION_DID_KICKOUT"


/// 登录用户信息改变，需要发送请求
#define GLIMNOTIFICATION_LOGIN_USER_NEED_REQUEST        @"GLIMNOTIFICATION_LOGIN_USER_NEED_REQUEST"
/// 登录用户信息请求成功，
#define GLIMNOTIFICATION_LOGIN_USER_REQUEST_SUCCESSED   @"GLIMNOTIFICATION_LOGIN_USER_REQUEST_SUCCESSED"

typedef NS_ENUM(NSInteger, GLIMAccountStatus)
{
    GLIMAccountNone,            // 未登录
    GLIMAccountLoggingIn,       // 登录中
    GLIMAccountLoggedOn,        // 已登录
    GLIMAccountLoggingOut,      // 注销中
    GLIMAccountLoggedOut,       // 已注销
    GLIMAccountKickedOut,       // 被踢
    GLIMAccountDisconnected,    // 连接断开
    GLIMAccountNotConnect,      // 连接不成功
};


typedef NS_ENUM(NSInteger, GLIMShopType)
{
    GLIMShopTypeNone,       // 普通店铺
    GLIMShopTypeZong,       // 总店
    GLIMShopTypeWang,       // 网店
};

typedef GLIMLoginAccount* (^GLIMGetAccountBlock)();


@interface GLIMAccountManager : NSObject
/// 登录账号
@property (nonatomic, strong) GLIMLoginAccount *loginAccount;
// 子账号离线提醒，默认为YES，子账号登录成功后，如果离线则只弹出一次
@property (nonatomic, assign) BOOL isBoyAccountNeedOfflinePrompt;
//是否是连锁店
@property (nonatomic, assign) BOOL isChainStore;

@property (nonatomic, assign) GLIMShopType shoType;

/// 账号被踢回调
@property (nonatomic, strong) dispatch_block_t kickoutBlock;
/// IM 账号状态
@property (nonatomic, assign) GLIMAccountStatus accountStatus;
/// SDK 登录性能回调，完成拉取联系人后触发
@property (nonatomic, strong) dispatch_block_t sdkInitFinishedBlock;
/// 全部IP地址连接失败
@property (nonatomic, strong) dispatch_block_t allServerFailedBlock;
/// socket连接被断开（主动或服务器断开）
@property (nonatomic, strong) dispatch_block_t disconnectBlock;
/// socket因内部原因断开（需要立即重连）
@property (nonatomic, copy) dispatch_block_t immediatelyReconnectBlock;
/// 主动获取账号block，成功返回app的登录账号，失败返回nil
@property (nonatomic, strong) GLIMGetAccountBlock getAccountBlock;

+ (instancetype)sharedAccount;

/// 已经登录
- (BOOL)isLogOn;

/// 能够登录
- (BOOL)canLogIn;

/// 是否连接中
- (BOOL)isDisConnected;

/// 能够执行登录（正在登录或已登录）
- (BOOL)canExcuteLogAction;

/// 子客服功能是否打开
- (BOOL)isCustomerServiceOpened;

/// 检查子账号是否离线或被取消权限
- (BOOL)isSubAccountOfflineOrForbidden;


/**
 登录IM
 
 @param loginAccount    登录账号信息
 @param completion      回调函数
 */
- (void)loginWithAccount:(GLIMLoginAccount *)loginAccount
              completion:(GLIMCompletionBlock)completion;


/**
 voip登录IM
 只是简单的login
 
 @param loginAccount    登录账号信息
 @param completion      回调函数
 */
- (void)loginWithAccountForVoip:(GLIMLoginAccount *)loginAccount
                     completion:(GLIMCompletionBlock)completion;

/**
 IM注销
 
 @param completion      回调函数
 */
- (void)logoutWithCompletion:(GLIMCompletionBlock)completion;


- (void)updateLoginAccount:(GLIMLoginAccount *)loginAccount;


/**
 当App被Termainate时注销IM
 */
- (void)logoutWhenAppWillTerminate;

/**
 检查账号状态，如果未登录则执行登录操作

 @param completion      回调函数
 */
- (void)checkAccountStatus:(GLIMCompletionBlock)completion;

/**
 检查IM连接状态，如果未登录则执行登录操作
 内部函数，外部不关心
 
 @param completion 回调整函数
 @param needResendFailedMessage 登录成功后是否需要自动发送失败消息
 */
- (void)checkAccountStatus:(GLIMCompletionBlock)completion
         needResendMessage:(BOOL)needResendFailedMessage;

/// 强制重新登录，此处逻辑稍微有些问题，不建议使用
- (void)forceRelogin;


/**
 登录IM，用户传入账号参数，manager根据参数生成loginAccount

 @param userID          用户买家ID或店铺ID
 @param userUss         用户uss
 @param userToken       用户账号token信息
 @param userType        账号登录类型
 @param completion      回调函数
 */
- (void)loginWithUserID:(NSString *)userID
                userUss:(NSString *)userUss
              userToken:(NSString *)userToken
               userType:(NSInteger)userType
             completion:(GLIMCompletionBlock)completion;

/// 登录IM，用户传入账号参数，manager根据参数生成loginAccount
/// @param userID 用户买家ID
/// @param userUss 用户uss
/// @param userDuid 用户duid，适用于一人多店
/// @param userToken 用户账号token信息
/// @param userType 账号登录类型
/// @param completion 回调函数
- (void)loginWithUserID:(NSString *)userID
                userUss:(NSString *)userUss
               userDuid:(NSString *)userDuid
              userToken:(NSString *)userToken
               userType:(NSInteger)userType
             completion:(GLIMCompletionBlock)completion;

/*
 断开连接
 会停止心跳且变更登录状态
 */
- (void)disconnect;

/**
 登录后需要进行的网络操作相关

 @param needLog 是否需要添加统计日志, 正常登录情况需要添加统计日志，VOIP情况下不添加
 */
- (void)loginSucessDoNetWorkTask:(BOOL)needLog;


#pragma mark - 日志
/// 检测SDK登录性能日志是否完备
- (void)outputStatisticalDatas;
/// 检测拉取联系人显示时长日志
- (void)addRecentShowLog:(NSString *)logInfo step:(NSInteger)step;
/// 断开连接
- (void)disconnectConnection:(GLIMCompletionBlock)completion;

#pragma mark - Test代码
- (NSString *)queryDBInfos;

- (BOOL)messageIsSelfWithFromUID:(NSString *)formUid;


/**
 判断传入的uid是不是登录的账号

 @param accountUID 指定账号的uid
 @return 如果指定的账号等于子账号或主账号
 */
- (BOOL)isMyAccount:(NSString *)accountUID;

- (void)requestLoginUserInfo;

#pragma mark - LogIn&LogOut
/**
 当app执行完登录操作后通过此函数执行登录IM操作
 需要配合getAccountBlock回调使用，只有getAccountBlock返回有效的账号，才能执行完登录操作
 由于app可能关心登录IM操作的后续结果，所以不用通知监听的方式，而直接使用回调
 
 @param completion 回调函数，error 为nil 表示登录成功
 */
- (void)loginIMWhenAppDidLoginWithCompletion:(GLIMCompletionBlock)completion;

/**
 当app执行完登出操作后通过此函数执行登出IM操作
 由于app可能关心登录IM操作的后续结果，所以不用通知监听的方式，而直接使用回调
 
 @param completion 回调函数，error 为nil 表示登录成功
 */
- (void)logoutIMWhenAppDidLogoutWithCompletion:(GLIMCompletionBlock)completion;

@end
