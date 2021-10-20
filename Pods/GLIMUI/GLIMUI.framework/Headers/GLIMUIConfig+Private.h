//
//  GLIMUIConfig+Private.h
//  GLIMUI
//
//  Created by huangbiao on 2018/4/24.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import "GLIMUIConfig.h"
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMChatTabExtendData.h"

@interface GLIMUIConfig (Private)

/**
 为聊天页面配置底部栏按钮
 
 @param chat 聊天对象
 */
- (void)configSessionBottomActionsWithChat:(GLIMChat *)chat;

/**
 获取互动消息
 */
- (void)configimGetInteractionMessageWithChat:(GLIMChat *)chat withType:(WDIMInteractionMessageContentType )type;

@end

/// 临时消息Cell配置
@interface GLIMUIConfig (CombineRecentChat)

/// 记录是不是从临时消息列表页面返回`
@property (nonatomic, assign) BOOL isBackFromTempList;
/// 记录是不是收到了临时消息
@property (nonatomic, assign) BOOL isReceivedTempMessage;
/// 记录账号登录后临时消息最大消息ID值是不是发生过变化
@property (nonatomic, assign) BOOL isMaxTempMsgIDChanged;

- (void)updateCombineSettingAfterLogin;
/// 临时消息未读数红点是否显示
- (BOOL)isCombineRecentChatRedDotHidden;
/// 从临时消息列表返回
- (void)updateCombineSettingWhenBackFromTempList;
/// 监听收到新消息通知
- (void)listenReceivedNewMessage;
/// 监听联系人同步完成通知
- (void)listenFinishChatsSynced;
/**
 更新缓存中的临时消息最大ServerMsgID

 @param maxServerMsgID 最大ServerMsgID或为nil
 */
- (void)updateMaxTempMessageID:(NSString *)maxServerMsgID;

@end

/// 消息通知
@interface GLIMUIConfig (MessageNotify)

/**
 判断是否需要显示通知横幅（状态栏或快捷消息）
 
 @return YES: 显示， NO：不显示
 */
- (BOOL)shouldShowNotifyView;

/**
 判断是否支持指定联系人的通知横幅点击事件
 
 @param contact 联系人数据（user或group）
 @return YES: 支持，NO：不支持
 */
- (BOOL)supportCustomNotifyViewClickedWithContact:(GLIMContact *)contact;

/**
 处理指定联系人的通知横幅点击事件
 
 @param contact 联系人数据（user或group）
 */
- (void)customNotifyViewClickedWithContact:(GLIMContact *)contact;

@end

/// 快捷消息
@interface GLIMUIConfig (ShortcutReply)

/// 记录快捷消息的导航栏
@property (nonatomic, strong) UINavigationController *shortcutNavigationController;

/// 根据联系人ID打开快捷消息页面
- (void)openShortcutReplyViewWithChatID:(NSString *)chatID;

/// 关闭快捷消息页面
- (void)closeChatShortcutView;

/// 跳转到聊天页面
- (void)openChatViewFromShortcutWithChat:(GLIMChat *)chat;

@end

@interface GLIMUIConfig (CommonEvent)

- (void)openLinkWithUrl:(NSString *)url;

//打开相册选择器  买家版 选择表情
- (void)openImageUIViewControllerWithPam:(NSDictionary *)pam finishedBlock:(selectImageFinishedBlock)block;

- (void)openCustomerServiceWorkTimePage;

- (GLIMChatTabExtendData *)getChatViewControllerTabListWithChat:(GLIMChat *)chat;

- (void)openRepeatPurchaseGuidePage;

- (BOOL)recentChatListBannerViewIsCanShow;

- (void)openSubAccountChatViewWithChat:(GLIMChat *)chat;

- (BOOL)canOpenQRLinkWithQRCode:(NSString *)qrCode;
- (void)openQRLinkWithQRCode:(NSString *)qrCode;

/// 视频
- (void)openVideoListPageWithCallback:(void (^)(NSArray *videoInfos))callback;
/// 打开本地视频列表
- (void)openLocalVideoAlbumWithCallback:(void (^)(NSArray *videoInfos))callback;
/// 打开视频播放页面
/// @param videoInfo 视频信息
- (void)openVideoPlayerPageWithVideoInfo:(GLIMVideoContent *)videoInfo;

/// 自动回复
- (void)autoReplyOpenGoodListPageWithCallback:(void (^)(NSDictionary *itemInfos))callback andDisableItems:(NSArray *)disableItems;

/// 微信公众号
- (void)openWxOfficialAccountChatViewWithChat:(GLIMChat *)chat;

/// 微信小程序
- (void)openWxProgramChatViewWithChat:(GLIMChat *)chat;

/// 打开聊天页面，不限聊天对象
- (void)openChatViewFromTipViewWithChat:(GLIMChat *)chat;
/// 打开聊天历史页面
- (void)openChatHistoryViewFromTipViewWithChat:(GLIMChat *)chat;

- (void)openFlutterPage:(NSString *)page
                 params:(id)params
                 result:(void (^)(id))result
                  modal:(BOOL)modal
               animated:(BOOL)animated;

/// 指定群聊页面是否支持刷新底部浮动视图
- (BOOL)shouldRefreshCustomExtendView:(NSString *)groupExtends withGroup:(GLIMGroup *)group;

- (BOOL)containsSpaceContacts;

@end
