//
//  GLIMUIInterface.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/29.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMMessageNotifyData.h"

/**
 GLIMUI 公共接口或定义
 */
@interface GLIMUIInterface : NSObject

/// 标识是否需要添加导航栏的高度，默认为NO, 测试用
@property (nonatomic, assign) BOOL needNavigationBarHeight;

/// 记录当前聊天对象
@property (nonatomic, strong) GLIMChat *talkingChat;

/// 记录当前聊天页面类型
@property (nonatomic, assign) GLIMChatType currentChatType;

+ (instancetype)sharedInstance;

/**
 打开自动回复设备页面
 */
- (void)openAutoReplySetting;

/**
打开顾客群入口展示开关
*/
- (void)openCustomerGroupEnterSwitchSetting;

/**
 打开临时消息列表
 */
- (void)openTempRecentChatsViewController;


/**
 打开子账号的联系人列表页面

 @param subUid 子账号userID
 */
- (void)openSubAccountRecentChatsViewControllerWithSubUid:(NSString *)subUid;

//打开营销页面
- (void)openMarketingViewControlleWithChat:(GLIMChat *)chat;
- (void)openMarketingViewControlleWithChat:(GLIMChat *)chat nav:(UINavigationController *)nav;

#pragma mark - 聊天历史
/// 聊天历史对象的uid
#define kGLIMUIChatHistoryUIdKey            @"imUid"
/// 查看聊天历史的操作类型，0 - 默认 1 - 主账号查看子账号
#define kGLIMUIChatHistoryViewTypeKey       @"viewType"
/// 查看聊天历史的消息起始位置，可选字段
#define kGLIMUIChatHistoryMessageIDKey      @"lastServerMsgId"
/// 查看聊天历史页面支持的跳转类型，0 - 默认，1 - 支持跳转到小程序用户聊天历史页面
#define kGLIMUIChatHistoryJumpTypeKey       @"jumpType"

/// 打开聊天历史页面
/// @param params 参数字典，具体构成如下
/// @{kGLIMUIChatHistoryUIdKey":@"xxxxxx", kGLIMUIChatHistoryViewTypeKey:0, kGLIMUIChatHistoryMessageIDKey:@"xxxxxx", kGLIMUIChatHistoryJumpTypeKey:0}
/// 参数说明：
/// kGLIMUIChatHistoryUIdKey: 账号uid，必填字段
/// kGLIMUIChatHistoryViewTypeKey: 可选字段，0 - 默认操作 1 - 主账号查看子账号聊天历史
/// kGLIMUIChatHistoryMessageIDKey: 可选字段，当前查看的消息id，传入后表示聊天历史页面显示该消息附近的消息
/// kGLIMUIChatHistoryJumpTypeKey:  可选字段，0 - 默认不支持，1 - 支持跳转到小程序用户聊天历史页面
- (void)openChatHistoryViewControllerWithParams:(NSDictionary *)params;

#pragma mark - 聊天历史待废弃方法

//打开聊天历史页面 是主账号查看主账号flag=no 是主账号查看子账号flag=yes
- (void)openChatHistoryViewControlleWithUid:(NSString *)subUid isMainAccountLookSubAccount:(BOOL)flag;
//兼容上面的方法
- (void)openChatHistoryViewControlleWithUid:(NSString *)subUid pam:(NSDictionary *)pam;
//传入servermsgid
- (void)openChatHistoryViewControlleWithUid:(NSString *)subUid isMainAccountLookSubAccount:(BOOL)flag withMesID:(NSString *)msgId;

#pragma mark -

/**
 打开直播群会话
 
 @param groupID 群ID
 */
- (void)openGroupLiveChatViewControllerWithGroupId:(NSString *)groupID;

/**
 打开屏蔽联系人列表

 @param contactDidSelectedBlock 屏蔽联系人被选中处理回调
 */
- (void)openBlockedContactListViewControllerWithBlock:(void (^)(NSString *contactUID))contactDidSelectedBlock;

/// 为聊天页面设置角标
- (void)setBadgeForAddButtonInChatView:(BOOL)showBadge;

/// 弹出自定义通知
/// @param notifyData 自定义通知格式
- (void)notifyCustomMessageWithData:(GLIMMessageNotifyData *)notifyData;

#pragma mark - 新场地
#define kGLIMUINewSpaceBodyKey          @"msgBody"
#define kGLIMUINewSpaceUnreadCountKey   @"unreadCount"
#define kGLIMUINewSpaceTimestampKey     @"timestamp"
#define kGLIMUINewSpaceServerMsgIdKey   @"serverMsgId"

/// 新场地数据
/// @param newSpaceInfos @{kGLIMUINewSpaceBodyKey:@"xxxxx", kGLIMUINewSpaceUnreadCountKey:x,  @""}
- (void)refreshNewSpaceWithData:(NSDictionary *)newSpaceInfos;

- (void)deleteNewSpace;

- (BOOL)containsNewSpace;

@end
