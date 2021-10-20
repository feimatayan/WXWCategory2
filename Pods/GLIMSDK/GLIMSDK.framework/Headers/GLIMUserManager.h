//
//  GLIMUserManager.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/24.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMSingleton.h"
#import "GLIMSDKInterface.h"


#define GLIMNOTIFICATION_USERS_CHANGED              @"GLIMNOTIFICATION_USERS_CHANGED"
#define GLIMNOTIFICATION_REMOVED_IDS                @"removedIDs"

/// 用户屏蔽通知
#define GLIMNOTIFICATION_USER_BLOCKED               @"GLIMNOTIFICATION_USER_BLOCKED"


@class GLIMUser;


/**
 用于管理用户，当前需求中并没有加好友等联系人需求，因此UserManager暂时没有太多功能，
 以后需要跟进实际需求添加
 */
@interface GLIMUserManager : NSObject

GLIMSINGLETON_HEADER(GLIMUserManager)

/// 临时消息对应的临时用户信息
@property (nonatomic, strong, nullable) GLIMUser *temporaryUser;

/**
 通过ID获取指定User, 获取顺序: DB -> Server
 从服务器获取的会自动入库
 
 @param userID    用户ID，由于会话ID与会话对象的联系人值相同，所有也可以使用contactID
 @param respoonse 回调 error or user
 */
- (void)userByID:(nonnull NSString*)userID response:(void(^ _Nonnull)(id _Nullable result))respoonse;

/**
 通过ID获取指定User, 每次都从服务器获取
 从服务器获取的会自动入库

 @param userID    用户ID，由于会话ID与会话对象的联系人值相同，所有也可以使用contactID
 @param respoonse 回调 error or user
 */
- (void)userByIDFromeService:(nonnull NSString*)userID response:(void(^ _Nonnull)(id _Nullable result))respoonse;
/**
 批量删除单聊联系人
 
 @param usersIDs 要删除的联系人ID列表
 */
- (void)removeUsersByIDs:(nonnull NSArray<NSString*>*)usersIDs;

#pragma mark - 屏蔽相关接口
/**
 屏蔽指定联系人

 @param uid 指定联系人uid
 @param complete 回调函数
 */
- (void)blockedUser:(nonnull NSString *)uid
           complete:(void(^ _Nonnull)(id _Nullable result))complete;

/**
 取消屏蔽指定联系人

 @param uid 指定联系人uid
 @param complete 回调函数
 */
- (void)relieveBlockUser:(nonnull NSString *)uid
                complete:(void(^ _Nonnull)(id _Nullable result))complete;


/**
 请求屏蔽联系人列表

 @param completion 回调函数，成功返回[{@"headimg":@"xxx",@"name":@"xxx",@"uid":@"xxx"}]，失败返回error
 */
- (void)requestBlockListWithCompletion:(void (^ _Nonnull)(id _Nullable result))completion;

#pragma mark - 

/**
 根据店铺或买家ID获取IM用户信息

 @param sellerOrBuyerID 卖家或买家ID
 @param completion      回调函数
 */
- (void)userBySellerOrBuyerID:(nonnull NSString *)sellerOrBuyerID
                 identityType:(GLIMIdentityType)identityType
                     response:(void(^ _Nonnull)(id _Nullable result))completion;



//    String role     ID身份： buyer 买家 seller 卖家
//    String realId    shopId或者是orderId（没有可不填）
//    String realIdType    id真实类型（传“shop”或者是“order”）没有可不填
- (void)userBySellerOrBuyerID:(nonnull NSString *)sellerOrBuyerID
                 identityType:(GLIMIdentityType)identityType
                   realIdType:(nonnull NSString *)realIdType
                       realId:(nonnull NSString *)realId
                     response:(void(^ _Nonnull)(id _Nullable result))completion;


/**
 获取用户公告
 
 @param uid 卖家或买家ID
 @param type     类型 1本人响应时间 显示在列表页 2是聊天人的响应时间 显示在聊天页面
 */
- (void)getUserNoticeWithUid:(nonnull NSString *)uid
                        type:(nonnull NSString *)type
                     response:(void(^ _Nonnull)(id _Nullable result))completion;

- (void)notifyConversationWithChatID:(nonnull NSString *)chatID
                      isOwnerContact:(nonnull NSString *)isOwnerContact
                          completion:(void(^ _Nonnull)(id _Nullable result))completion;
/**
 设置样板店评价
 
 @param uid 自己的uid
 @param targetUid     被评价的样板店uid
 @param level 评价等级
 */
- (void)contactSatisfactionWithUid:(nonnull NSString *)uid
                         targetUid:(nonnull NSString *)targetUid
                             level:(nonnull NSString *)level
                    response:(void(^ _Nonnull)(id _Nullable result))completion;

/**
 样板店转人工客服

 @param targetUID 对方的uid
 @param completion 回调函数
 */
- (void)contactStaffServiceWithUID:(nonnull NSString *)targetUID
                        completion:(void(^ _Nonnull)(id _Nullable result))completion;

- (nonnull NSArray *)getAllUsers;

@end
