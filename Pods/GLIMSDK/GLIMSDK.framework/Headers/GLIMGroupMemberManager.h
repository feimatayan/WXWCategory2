//
//  GLIMGroupMemberManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2018/3/12.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLIMGroup;

@class GLIMMessage;
@class GLIMGroupMember;

/// 群成员信息发生变化
#define GLIMNOTIFICATION_GROUP_MEMBER_CHANGED       @"GLIMNOTIFICATION_GROUP_MEMBER_CHANGED"
/// 群成员信息发生变化 批量的操作
#define GLIMNOTIFICATION_GROUP_MEMBER_LIST_CHANGED       @"GLIMNOTIFICATION_GROUP_MEMBER_LIST_CHANGED"

#define kGroupMemberChangedNotificationGroupKey     @"group"
#define kGroupMemberChangedNotificationMemberKey    @"groupMember"

/**
 群成员接口管理
 */
@interface GLIMGroupMemberManager : NSObject

+ (nonnull instancetype)sharedInstance;

/// 获取消息内部的成员信息
/// @param message 群成员信息
- (GLIMGroupMember *)groupMemberWithMessage:(GLIMMessage *)message;

/**
 获取指定群中群成员的信息
 
 @param memberID 成员ID
 @param groupID 群ID
 @param completion 回调函数，成功返回成员列表，失败返回error或者nil
 */
- (void)memberInfoByID:(nonnull NSString *)memberID
               inGroup:(nonnull NSString *)groupID
            completion:(void(^ _Nonnull)(id _Nullable result))completion;

/// 获取指定群中群成员的信息
/// @param memberID 成员ID
/// @param groupID 群ID
/// @param message 消息内容
/// @param completion 回调函数，成功返回成员列表，失败返回error或者nil
- (void)memberInfoByID:(nonnull NSString *)memberID
               inGroup:(nonnull NSString *)groupID
           withMessage:(GLIMMessage *)message
            completion:(void(^ _Nonnull)(id _Nullable result))completion;

/**
 获取指定群中多个群成员的信息
 
 @param memberIDArray 成员ID数组
 @param groupID 群ID
 @param completion 回调函数，成功返回成员列表，失败返回error或者nil
 */
- (void)membersInfoByIDs:(nonnull NSArray *)memberIDArray
                 inGroup:(nonnull NSString *)groupID
              completion:(void(^ _Nonnull)(id _Nullable result))completion;

/**
 请求指定群中群成员列表的信息
 请求会返回基本的群信息和群成员信息

 @param memberIDArray 群成员列表（必传字段）
 @param groupID 群ID（必传字段）
 @param completion 回调函数，成功返回成员列表，失败返回error或者nil
 */
- (void)membersInfoByIDsFromService:(nonnull NSArray *)memberIDArray
                        withGroupID:(nonnull NSString *)groupID
                         completion:(void (^_Nonnull)(id _Nullable))completion;

/**
 根据群主ID和管理员ID列表更新本地群成员身份

 @param groupID 群ID
 @param ownerIDArray 群主ID列表
 @param managerIDArray 群管理员ID列表
 @param staffIDArray 微店员工ID列表
 @param completion 回调函数，返回入库操作结果
 */
- (void)updateMembersIdentityInGroup:(nonnull NSString *)groupID
                            ownerIDs:(nonnull NSArray *)ownerIDArray
                          managerIDs:(nonnull NSArray *)managerIDArray
                            staffIDs:(nonnull NSArray *)staffIDArray
                          completion:(void (^ _Nonnull)(BOOL isSuccess))completion;

/**
 批量更新指定成员的身份信息

 @param groupID 群ID
 @param memberInfos 群成员ID及对应身份，格式为[{@"memberUid":@"111111",@"identity":1}]
 @param completion 回调函数，返回入库操作结果
 */
- (void)updateMembersIdentityInGroup:(nonnull NSString *)groupID
                     withMembersInfo:(nonnull NSArray *)memberInfos
                          completion:(void (^ _Nonnull)(BOOL isSuccess))completion;

/**
 从服务器获取指定群的群成员信息
 @成员，包括所有人

 @param groupID 群ID
 @param completion 回调函数，成功返回成员数组，失败返回error或nil
 */
- (void)atMembersInGroup:(nonnull NSString *)groupID
              completion:(void(^ _Nonnull)(id _Nullable result))completion;

/// 获取本地群成员
- (nonnull NSArray *)allMembersInGroup:(nonnull NSString *)groupID;

@end
