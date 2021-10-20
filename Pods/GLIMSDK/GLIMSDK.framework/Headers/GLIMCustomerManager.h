//
//  GLIMCustomerManager.h
//  GLIMSDK
//
//  Created by 六度 on 2017/11/15.
//  Copyright © 2017年 Koudai. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GLIMFoundationDefine.h"



@protocol GLIMCustomerManagerProcotol <NSObject>

- (void)changeCustomerStatusCompletion;

- (void)changeCustomerStatusCompletionAndShowErrorWith:(NSString *)text;

@end




typedef enum : NSUInteger {
    GLIMCustomerLimitTypeDelChat,       // 删除联系人
    GLIMCustomerLimitTypeLoadChat,      // 拉取联系人
    GLIMCustomerLimitTypeTopChat,       // 置顶联系人
    GLIMCustomerLimitTypeBlockChat,     // 屏蔽联系人
    GLIMCustomerLimitTypeThroughChat,   // 被动接受转接
    GLIMCustomerLimitTypeSendMsg,       // 发送消息
    GLIMCustomerLimitTypeEvaluateShop,  // 评价店铺
    GLIMCustomerLimitTypeAutoMsg,       // 自动回复编辑
    GLIMCustomerLimitTypeBeInputing,    // 显示自动输入
    GLIMCustomerLimitTypeSetting,       // 显示自动输入
} GLIMCustomerLimitType;

/// 子客服在线状态
#define GLIM_CUSTOMER_CHANGE_ONLINE_STATUS  @"GLIM_CUSTOMER_CHANGE_ONLINE_STATUS"

//子客服离线了 刷新买家版 UI
#define GLIM_CUSTOMER_CHANGE_OFF_LINE_STATUS  @"GLIM_CUSTOMER_CHANGE_OFF_LINE_STATUS"
/// 当前聊天对象已经被转走
#define GLIMNOTIFICATION_CUSTOMERSERVICE_CHAT_DID_TRANSFERED   @"GLIMNOTIFICATION_CUSTOMERSERVICE_CHAT_DID_TRANSFERED"

/*
 用于管理子客服各种权限
 */
@interface GLIMCustomerManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak) id<GLIMCustomerManagerProcotol> delegate;

/*
 返回bool YES为有权限
 */

+ (BOOL )LimitWithType:(GLIMCustomerLimitType)limitType;

/*
 返回对应的toast信息 返回nil则表示有权限操作
 */
+ (NSString *)getLimitStringWithType:(GLIMCustomerLimitType)limitType;

/*
 status 1在线 2离线 3忙碌
 返回值 无error 则为成功
 */
- (void)changeCustomerStatus:(NSString *)status
                    response:(void (^)(NSError*  error))respoonse;

/**
 请求当前用户的子客服列表

 @param uid 当前用户uid
 @param completion 回调函数，成功返回子客服列表，失败返回error
 */
- (void)requestCustomerServiceList:(NSString *)uid completion:(GLIMCompletionBlock)completion;


- (void)requestCustomerServiceNewList:(NSString *)pageNo
                             pageSize:(NSString*)pageSize
                              shopUid:(NSString *)shopUid
                                 type:(NSString *)type
                           completion:(GLIMCompletionBlock)completion;

/**
 将客户从客服A转到客服B
 
 @param customerID 被转接的客户UID
 @param isFriend 被转接的客户关系，YES：好友，NO：临时联系人
 @param fromUID 转接的子客服UID
 @param toUID 接收的子客服UID
 @param block 回调函数
 */
- (void)changeCustomer:(NSString *)customerID
              isFriend:(BOOL)isFriend
                  from:(NSString *)fromUID
                    to:(NSString *)toUID
             withBlock:(void (^)(id result))block;

/**
 检查用户权限

 @param completion 回调函数
 */
- (void)checkAuthorityCompletion:(GLIMCompletionBlock)completion;


//根据id判断是否应该发送请求
- (BOOL)shouldRequestWithID:(NSString *)ID;
//根据id请求网络获取用户信息
- (void)sendUserByIDRequestWithID:(NSString *)ID response:(void(^ _Nonnull)(id _Nullable result))respoonse;
//根据id请求网络获取用户信息 先内存 再DB 后网络
- (void)subAccountUserByID:(NSString *)ID response:(void(^ _Nonnull)(id _Nullable result))respoonse;

/// 同步服务器下发的服务状态
/// @param actionStatus 0-不需要请求后端只需要把本地设置成忙碌； 1-需要请求后端 本地设置成在线并且请求接口设置在线； 2-需要请求后端 本地设置成离线并且请求接口设置离线
- (void)syncAccountServiceStatus:(NSInteger)actionStatus;

- (void)setAllAccountOfflineResponse:(void (^)(NSError*  error))respoonse;

@end
