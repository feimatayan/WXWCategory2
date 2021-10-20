//
//  GLIMUIDefine.h
//  GLIMUI
//
//  Created by huangbiao on 2017/12/6.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#ifndef GLIMUIDefine_h
#define GLIMUIDefine_h

#pragma mark - 本地通知显示类型
typedef NS_ENUM(NSInteger, GLIMMessageNotifyShowType) {
    GLIMMessageNotifyShowNone = 0,          // 不显示
    GLIMMessageNotifyShowStatusBar = 1,     // 以状态栏显示
    GLIMMessageNotifyShowShortcutReply = 2, // 以快捷回复方式显示
};

#pragma mark - 本地通知
#define GLIMNOTIFICATION_LOCAL_NOTIFY               @"GLIMNOTIFICATION_LOCAL_NOTIFY"

//聊天页面定时器通知 用来更新群专享优惠券的倒计时
#define GLIMNOTIFICATION_CHATLOCALCLOCK_CHANGE @"GLIMNOTIFICATION_CHATLOCALCLOCK_CHANGE"

// 聊天页面，关闭快捷消息
#define GLIMNOTIFICATION_CHAT_SHORTCUT_CLOSED   @"GLIMNOTIFICATION_CHAT_SHORTCUT_CLOSED"

//收到voipPpush
#define GLIMNOTIFICATION_DID_RECEIVE_VOIP_PUSH      @"GLIMNOTIFICATION_DID_RECEIVE_VOIP_PUSH"

//切换 tabbar 到主页 page
#define GLIMNOTIFICATION_TABBAR_CHANGE_HOME_PAGE    @"GLIMNOTIFICATION_TABBAR_CHANGE_HOME_PAGE"
/**
 本地要弹出类似系统通知的alert，通知内容：
 {
 "alertTitle":"通知标题",
 "alertBody":"通知内容",
 "alertAction":"通知操作提示",
 "timeStr":"通知时间标识",
 "soundName":"通知声效",
 "userInfo":"扩展信息"
 }
 */
#define GLIMNOTIFICATION_LOCAL_NOTIFY_ALERT         @"GLIMNOTIFICATION_LOCAL_NOTIFY_ALERT"


// 聊天页面弹出悬浮视图
// 通知内容 @{"floatingView": @"具体类名"}
#define GLIMNOTIFICATION_MESSAGE_SHOW_FLOATINGVIEW      @"GLIMNOTIFICATION_MESSAGE_SHOW_FLOATINGVIEW"

/// 聊天页面显示视频选择视图
#define GLIMNOTIFICATION_MESSAGE_SHOW_VIDEO_SHEET   @"GLIMNOTIFICATION_MESSAGE_SHOW_VIDEO_SHEET"


//聊天切换 tab 通知
#define GLIMChatTabNavigationView_TABCNANGE_NOTIFICATION         @"GLIMChatTabNavigationView_TABCNANGE_NOTIFICATION"
//群聊的新成员通知显示完成
#define GLIMGroupChatViewController_GLIMEGroupBulletinShowComplete_NOTIFICATION         @"GLIMGroupChatViewController_GLIMEGroupBulletinShowComplete_NOTIFICATION"

#define GLIMNotificationRecentChatsViewWillAppear   @"GLIMNotificationRecentChatsViewWillAppear"

//营销联系人
#define GLIMMarketAdvertisingChatUid  @"7300000000000000000" // uid，标识具体的某一个联系人
#define GLIMMarketAdvertisingChatId   10040                  // 联系人类型，表示一类联系人

//金融联系人
#define GLIMFinanceChatUid  @"7500000000000000000" // uid，标识具体的某一个联系人
#define GLIMFinanceChatId   10060                  // 联系人类型，表示一类联系人


#pragma mark - 分享

/// 分享场景
typedef NS_ENUM(NSInteger, GLIMUIShareSceneType) {
    GLIMUIShareSceneSession = 0,  // 聊天会话
    GLIMUIShareSceneGroup = 1,    // 群组
    GLIMUIShareSceneOther = 2,    // 其他
};

/// 分享卡片类型
typedef NS_ENUM(NSInteger, GLIMUIShareCardType){
    GLIMUIShareCardOrderPayed = 1,          // 订单，对应着订单收款
    GLIMUIShareCardGood = 14,               // 商品分享
    GLIMUIShareCardScoreRedEnvelope = 100,  // 积分红包分享
    GLIMUIShareCardShopRedEnvelope = 101,   // 店铺红包
    
    GLIMUIShareCardOrganization = 21,       // 组织分享
    GLIMUIShareCardGroupInfo = 22,          // 群信息分享
    GLIMUIShareCardAssembleGroupInfo = 23,  // 抱团群信息分享
    GLIMUIShareCardTopic = 25,              // 话题分享
    GLIMUIShareCardLink = 26,               // 链接分享
    GLIMUIShareCardAssemblePushGroup = 27,  // 抱团互推群分享
    GLIMUIShareCardRegularCustomerGroupCoupon = 28, // 回头客群专享优惠
    GLIMUIShareCardRegularCustomerGroupInvite = 29, // 回头客群邀请
};

/// 主标题（类型为NSString）
#define GLIMUIKEY_SHARE_MAIN_TITLE  @"GLIMUIKEY_SHARE_MAIN_TITLE"
/// 分享标题（类型为NSString）
#define GLIMUIKEY_SHARE_TITLE       @"GLIMUIKEY_SHARE_TITLE"
/// 分享二级标题（类型为NSString）
#define GLIMUIKEY_SHARE_SUB_TITLE   @"GLIMUIKEY_SHARE_SUB_TITLE"
/// 分享图标链接（类型为NSString）
#define GLIMUIKEY_SHARE_IMAGE_URL   @"GLIMUIKEY_SHARE_IMAGE_URL"
/// 分享详情链接（类型为NSString）
#define GLIMUIKEY_SHARE_DETAIL_URL  @"GLIMUIKEY_SHARE_DETAIL_URL"
/// 分享扩展信息（类型为NSString, jsonString）
#define GLIMUIKEY_SHARE_EXT_INFOS   @"GLIMUIKEY_SHARE_EXT_INFOS"
/// 分享场景（类型为NSNumber）
#define GLIMUIKEY_SHARE_SCENE_TYPE  @"GLIMUIKEY_SHARE_SCENE_TYPE"
/// 分享类型（类型为NSNumber）
#define GLIMUIKEY_SHARE_TYPE        @"GLIMUIKEY_SHARE_TYPE"
/// 分享详情ID（类型为NSString）
#define GLIMUIKEY_SHARE_DETAIL_ID   @"GLIMUIKEY_SHARE_DETAIL_ID"

/// 分享参数格式如下：
/*
 @{
 GLIMUIKEY_SHARE_MAIN_TITLE:@"主标题",
 GLIMUIKEY_SHARE_TITLE:@"一级标题",
 GLIMUIKEY_SHARE_SUB_TITLE:@"二级标题",
 GLIMUIKEY_SHARE_IMAGE_URL:@"图片链接",
 GLIMUIKEY_SHARE_DETAIL_URL:@"跳转链接",
 GLIMUIKEY_SHARE_EXT_INFOS:@"jsonString",
 GLIMUIKEY_SHARE_SCENE_TYPE:@(GLIMUIShareSceneSession),
 GLIMUIKEY_SHARE_TYPE:@(GLIMUIShareCardScoreRedEnvelope)
 }
 */

#endif /* GLIMUIDefine_h */
