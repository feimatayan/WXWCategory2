//
//  GLIMQIYUManager.h
//  GLIMUI
//
//  Created by jiakun on 2019/9/9.
//  Copyright © 2019 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGLIMQiYuUserID     @"userid"
#define kGLIMQiYuUserName   @"name"
#define kGLIMQiYuUserPhone  @"telephone"
#define kGLIMQiYuUserEmail  @"email"

NS_ASSUME_NONNULL_BEGIN

/// 在线接收到七鱼消息
#define kWDQYDidReceivedMessageNotification     @"kWDQYDidReceivedMessageNotification"

typedef NS_ENUM(NSInteger, GLIMQiYuCustomInputItemType) {
    GLIMQiYuCustomInputItemNone = 0,        //
    GLIMQiYuCustomInputItemPhoto = 1,       // 相册
    GLIMQiYuCustomInputItemTakePhoto,       // 拍照
    GLIMQiYuCustomInputItemTakeVideo,       // 拍摄
    GLIMQiYuCustomInputItemVideo,           // 视频
    GLIMQiYuCustomInputItemEvaluate,        // 评价
    GLIMQiYuCustomInputItemClose,           // 退出
    GLIMQiYuCustomInputItemSelectOrder,     // 订单选择
    GLIMQiYuCustomInputItemRecentBrowser,   // 最近浏览
};

@protocol GLIMQiYuEventDelegate <NSObject>

@optional
- (void)didClickCustomInputItem:(GLIMQiYuCustomInputItemType)itemType;

@end

@interface GLIMQIYUManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<GLIMQiYuEventDelegate> eventDelegate;

/// 买家版定制
- (void)configForBuyer;

/// 隐藏语音入口 
- (void)hideAudioEntry;

/// 测试代码
- (void)didClickCell;

/**
 内部打开七鱼聊天页面

 @param params 具体参数
 */
- (void)openQYChatViewWithParams:(NSDictionary *)params;

/**
 @{
 kGLIMQiYuUserID:@"userid",
 kGLIMQiYuUserName:@"昵称",
 kGLIMQiYuUserPhone:@"电话",
 kGLIMQiYuUserEmail:@"邮箱"
 }

 @param userInfos 用户信息，后续接入账号SDK时直接内部处理
 */
- (void)updateQiYuInfos:(NSDictionary *)userInfos;

- (void)logoutQiYu;

- (NSInteger)unreadCount;

#pragma mark - vip
/// 获取指定用户的vip等级
- (NSInteger)vipLevelWithUserID:(NSString *)userID;

/**
 获取用户Vip信息

 @param userID 用户ID
 @param type 用户类型，seller 卖家， buyer 买家
 @param completion 回调函数
 */
- (void)requestVipInfosWithUserID:(NSString *)userID
                             type:(NSString *)type
                       completion:(void (^)(BOOL isSuccess))completion;

#pragma mark - 客服组
/// 客服组id
- (int64_t)groupId;
/// 机器人id
- (int64_t)robotId;
/// 是否客服工作时间
- (BOOL)isWorkingTime;

/// 买家版机器人id
- (int64_t)buyerRobotId;

/// 买家版Vip机器人id
- (int64_t)buyerVipRobotId;

/// 卖家版机器人id
- (int64_t)sellerRobotId;

/// 卖家版vip机器人id
- (int64_t)sellerVipRobotId;



@end

NS_ASSUME_NONNULL_END
