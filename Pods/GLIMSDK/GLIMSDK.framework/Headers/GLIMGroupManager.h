//
//  GLIMGroupManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2018/3/7.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 群相关Key
#define GLIMKEY_GROUP_GROUP_ID                  @"groupID"
#define GLIMKEY_GROUP_GROUP_USERID                  @"groupUserID"
#define GLIMKEY_GROUP_MEMBER_IDENTIFY_INFO      @"groupMemberIdentifyInfo"
#define GLIMKEY_GROUP_GROUP_BANNED_STATUS       @"groupBannedStatus"
#define GLIMKEY_GROUP_MEMBER_BANNED_STATUS      @"memberBannedStatus"
#define GLIMKEY_GROUP_MEMBER_BANNED_TIME        @"memberBannedTime"

#pragma mark - 群相关通知
/* 群成员禁言通知
 * 通知内容：
 {
    GLIMKEY_GROUP_GROUP_ID:"xxx",           // 群ID
    GLIMKEY_GROUP_MEMBER_BANNED_STATUS:1,   // 禁言状态：1 - 禁言， 0 - 正常
    GLIMKEY_GROUP_MEMBER_BANNED_TIME:1000   // 毫秒，可选字段
 }
 */
#define GLIMNOTIFICATION_GROUP_MEMBER_BANNED    @"GLIMNOTIFICATION_GROUP_MEMBER_BANNED"
// 群屏蔽，返回群对象
#define GLIMNOTIFICATION_GROUP_BLOCKED          @"GLIMNOTIFICATION_GROUP_BLOCKED"
/* 群成员全员被禁
 * 通知内容：
 {
    GLIMKEY_GROUP_GROUP_ID:"xxx",           // 群ID
    GLIMKEY_GROUP_GROUP_BANNED_STATUS:1     // 禁言状态：1 - 禁言， 0 - 正常
 }
 */
#define GLIMNOTIFICATION_GROUP_ALL_BANNED       @"GLIMNOTIFICATION_GROUP_ALL_BANNED"
/// 群成员退群或被踢通知
#define GLIMNOTIFICATION_GROUP_QUIT             @"GLIMNOTIFICATION_GROUP_QUIT"
/// 群信息发生变化
#define GLIMNOTIFICATION_GROUP_INFO_CHANGED     @"GLIMNOTIFICATION_GROUP_INFO_CHANGED"
/// 群头像发生变化
#define GLIMNOTIFICATION_GROUP_AVATAR_CHANGED   @"GLIMNOTIFICATION_GROUP_AVATAR_CHANGED"
/// 群成员加入
#define GLIMNOTIFICATION_GROUP_JOIN             @"GLIMNOTIFICATION_GROUP_JOIN"
/// 群成员身份变更(只有检测到本地群成员身份确实变更了才会发送通知)
#define GLIMNOTIFICATION_GROUP_MEMBER_IDENTITY_CHANGED  @"GLIMNOTIFICATION_GROUP_MEMBER_IDENTITY_CHANGED"

@interface GLIMGroupManager : NSObject

+ (nonnull instancetype)sharedInstance;

#pragma mark - 同步功能

/**
 同步群聊列表

 @param completion 回调函数
 */
- (void)syncGroupList:(void(^ _Nonnull)(id _Nullable result))completion;

/// 重置时间戳
- (void)resetSyncTimestamp;

#pragma mark - 屏蔽功能
/**
 添加群屏蔽

 @param groupID 群ID
 @param completion 回调函数
 */
- (void)addGroupBlock:(nonnull NSString *)groupID
           completion:(void(^ _Nonnull)(id _Nullable result))completion;

/**
 解除群屏蔽

 @param groupID 群ID
 @param completion 回调函数
 */
- (void)deleteGroupBlock:(nonnull NSString *)groupID
              completion:(void(^ _Nonnull)(id _Nullable result))completion;

/**
 通知服务器指定群的某个成员已经进入聊天状态

 @param groupID 指定群
 @param groupType 指定群的类型
 @param completion 回调函数，返回字典（具体数据参考http://docs.vdian.net/pages/viewpage.action?pageId=59393424的conversion接口）
 */
- (void)notifyConversationWithGroupID:(nonnull NSString *)groupID
                            groupType:(NSInteger)groupType
                           completion:(void(^ _Nonnull)(id _Nullable result))completion;

- (void)groupByIDFromConversationWithGroupID:(nonnull NSString *)groupID
                                  completion:(void(^ _Nonnull)(id _Nullable result))completion;

#pragma mark - 获取群信息

/**
 获取指定群信息
 优先从本地数据库中查询，如果找到直接返回
 如果未找到，则从请求服务器

 @param groupID 群ID
 @param completion 回调函数
 */
- (void)groupByID:(nonnull NSString *)groupID
       completion:(void(^ _Nonnull)(id _Nullable result))completion;

/**
 从服务器获取指定群信息

 @param groupID 群ID
 @param completion 回调函数
 */
- (void)groupByIDFromService:(nonnull NSString *)groupID
                  completion:(void(^ _Nonnull)(id _Nullable result))completion;

/**
 批量从服务器获取群信息

 @param groupIDArray    群ID数组
 @param completion      回调函数
 */
- (void)groupArrayByIDsFromService:(nonnull NSArray *)groupIDArray
                        completion:(void(^ _Nonnull)(id _Nullable result))completion;



- (void)loadGroupTopWelfareDataPage:(NSInteger)page
                              count:(NSInteger)count
                            groupId:(nonnull NSString *)groupId
                         completion:(void (^ _Nonnull)(NSDictionary* _Nullable dic))completion;

- (void)loadGroupTopDynamicDataGroupId:(nonnull NSString *)groupId
                            completion:(void (^ _Nonnull)(NSDictionary* _Nullable dic))completion;
@end

