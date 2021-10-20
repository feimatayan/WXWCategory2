//
//  GLIMUIConfig.h
//  GLIMUI
//
//  Created by huangbiao on 2017/12/14.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMUIDefine.h"
#import "GLIMChatTabExtendData.h"

@class GLIMChatUIConfig;
@class GLIMMessageUIConfig;
@class GLIMMessageBottomActionItemData;
@class GLIMMessageBottomExtendSubView;


typedef void (^selectImageFinishedBlock)(NSData *imageData, UIImage *image, BOOL isGif);

typedef NS_ENUM(NSInteger, GLIMUIRecentChatUnreadShowType) {
    GLIMUIRecentChatUnreadShowNone = 0,     // 不显示未读数
    GLIMUIRecentChatUnreadShowNumber = 1,   // 显示数字
    GLIMUIRecentChatUnreadShowRedDot = 2,   // 显示红点
};

typedef NS_ENUM(NSInteger,  WDIMInteractionMessageContentType) {
    WDIMInteractionMessageContentType_Coupon = 1,        // 优惠券
    WDIMInteractionMessageContentType_LimitedTime = 2,        // 限时折扣
    WDIMInteractionMessageContentType_NewCustomerExclusive = 3,        // 新客专享礼包
    WDIMInteractionMessageContentType_GroupBooking = 4, // 拼团
    WDIMInteractionMessageContentType_ShopVip = 5,//vip
    WDIMInteractionMessageContentType_NoData = 100,        // 
};


/// UI 配置协议
@protocol GLIMUIConfigProcotol <NSObject>

/**
 根据聊天对象配置会话页面底部按钮栏

 @param chat 聊天对象
 */
- (void)imConfigSessionBottomActionsWithChat:(GLIMChat *)chat;

/**
 配置打开指定链接的操作
 暂时先放这处理，后续需要梳理下Cell的点击事件，有些需要挪动到GLIMUI中

 @param url 指定链接
 */
- (void)imConfigSessionOpenLinkActionsWithUrl:(NSString *)url;

@end

#pragma mark - 通知相关
@protocol GLIMUIMessageNotifyProtocol <NSObject>

@optional
/**
 判断是否需要显示通知横幅（状态栏或快捷消息）
 
 @return YES: 显示， NO：不显示
 */
- (BOOL)imShouldShowNotifyView;

/**
 判断是否支持指定联系人的通知横幅点击事件
 
 @param contact 联系人数据（user或group）
 @return YES: 支持，NO：不支持
 */
- (BOOL)imSupportCustomNotifyViewClickedWithContact:(GLIMContact *)contact;

/**
 处理指定联系人的通知横幅点击事件
 
 @param contact 联系人数据（user或group）
 */
- (void)imCustomNotifyViewClickedWithContact:(GLIMContact *)contact;

/**
 从快捷聊天页面打开聊天页面
 
 @param chat 聊天对象
 */
- (void)imOpenChatViewFromShortcutReplyWithChat:(GLIMChat *)chat;

/**
 关闭快捷聊天页面
 */
- (void)imCloseChatShortcutReplyView;

/// 从顶部提示栏打开聊天页面
/// @param chat 联系人对象
- (void)imOpenChatViewFromTipViewWithChat:(GLIMChat *)chat;

/// 从顶部提示栏打开聊天历史页面
/// @param chat 联系人对象
- (void)imOpenChatHistoryViewFromTipViewWithChat:(GLIMChat *)chat;

@end

@protocol GLIMUIEventProtocol <GLIMUIMessageNotifyProtocol>

@optional

/**
 打开指定链接

 @param urlString 链接地址
 */
- (void)imOpenLinkWithUrl:(NSString *)urlString;


//打开相册选择器  买家版 选择表情
- (void)imOpenImageUIViewControllerWithFinishedBlock:(selectImageFinishedBlock)block;

- (void)imOpenImageUIViewControllerWithPam:(NSDictionary *)pam finishedBlock:(selectImageFinishedBlock)block;


/**
 跳转客服上班时间设置页面
 */
- (void)imOpenCustomerServiceWorkTimePage;


/**
 跳转复购设置页面
 */
- (void)imOpenRepeatPurchaseGuidePage;


//当前页面是否是 聊天Tab页面
- (BOOL)currentTabPageIsChatListPage;


- (void)imOpenFlutterPage:(NSString *)page
                 params:(id)params
                 result:(void (^)(id))result
                  modal:(BOOL)modal
               animated:(BOOL)animated;

/**
 主账号打开子账号联系人的会话页面
 
 @param chat 子账号联系人
 */
- (void)imOpenSubAccountChatViewWithChat:(GLIMChat *)chat;


/**
 检查二维码地址是否能够跳转

 @param qrCode 二维码
 @return YES：可以打开
 */
- (BOOL)imCanOpenQRLinkWithQRCode:(NSString *)qrCode;

/**
 打开二维码地址

 @param qrCode 二维码
 */
- (void)imOpenQRLinkWithQRCode:(NSString *)qrCode;


/**
 联系人列表的外部广告时候可以显示
 */
- (BOOL)imRecentChatListBannerViewIsCanShow;


- (GLIMChatTabExtendData *)imGetChatViewControllerTabListWithChat:(GLIMChat *)chat;

/**
 打开视频列表

 @param callback 回调函数，返回视频列表
 */
- (void)imOpenVideoListPageWithCallback:(void (^)(NSArray *videoInfos))callback;

/// 打开本地视频列表
/// @param callback 回调函数，返回视频列表，数组内部为字典
/// 示例：@[@{@“videoUrl”:@"视频地址", @"duration":@"视频时长", @"coverImage":封面图片, @"pathDirectory":@(NSCachesDirectory)}]
/// 字段说明：
/// videoUrl：视频地址，如果pathDirectory为0，传入绝对路径，否则传pathDirectory的相对路径
/// duration：视频时长，秒
/// coverImage：视频封面图片，类型为UIImage，如果coverUrl不为空，则为可选字段
/// pathDirectory：沙盒路径，如NSCachesDirectory，可选字段
- (void)imOpenLocalVideoAlbumWithCallback:(void (^)(NSArray *videoInfos))callback;

/**
 打开视频播放页面

 @param videoInfo 视频信息
 videoInfo的字段信息如下：@{@"vid":xxxx,@"scope":xxx",@"coverUrl":xxxx,@"playUrl":xxxx}
 */
- (void)imOpenVideoPlayerPageWithVideoInfo:(NSDictionary *)videoInfo;

/**
 自动回复打开商品列表

 @param callback 回调函数，返回商品信息
 */
- (void)imAutoReplyOpenGoodListPageWithCallback:(void (^)(NSDictionary *itemInfos))callback
                                andDisableItems:(NSArray *)disableItems;

/**
打开具体的微信公众号联系人

@param chat 微信公众号联系人
*/
- (void)imOpenWxOfficialAccountChatViewWithChat:(GLIMChat *)chat;


/// 打开具体的微信小程序联系人
/// @param chat 微信小程序联系人
- (void)imOpenWxProgramChatViewWithChat:(GLIMChat *)chat;

/// 指定群聊页面是否支持显示底部浮动视图
/// @param groupExtends 群扩展信息
/// @param group 群对象
- (BOOL)imShouldRefreshCustomExtendView:(NSString *)groupExtends withGroup:(GLIMGroup *)group;

/// 联系人列表是否包含新场地联系人
- (BOOL)imContainsSpaceContacts;

@end

/// UI 配置类
@interface GLIMUIConfig : NSObject

+ (instancetype)sharedInstance;

/// 配置处理（后期考虑和迁移到GLIMUIEventProtocol）
@property (nonatomic, weak) id<GLIMUIConfigProcotol> delegate;

/// 事件处理
@property (nonatomic, weak) id<GLIMUIEventProtocol> eventDelegate;

#pragma mark - SDK通用配置
/// 通用的返回图标
@property (nonatomic, strong) UIImage *normalLeftBarImage;

#pragma mark - 视频播放配置
/// 回退按钮
@property (nonatomic, strong) UIImage *videoPlayBackImage;
/// 蒙层背景
@property (nonatomic, strong) UIImage *videoPlayMaskImage;

#pragma mark - 自定义导航栏属性设置
/// 是否使用自定义导航栏，默认NO
@property (nonatomic, assign) BOOL usingCustomNavigationBar;
/// 自定义导航栏背景色，默认
@property (nonatomic, strong) UIColor *customNavigationBarBgColor;
/// 自定义导航栏标题颜色，默认白色
@property (nonatomic, strong) UIColor *customNavigationBarTitleColor;
/// 自定义导航栏标题字体，默认是[UIFont boldSystemFontOfSize:20]
@property (nonatomic, strong) UIFont *customNavigationBarTitleFont;
/// 自定义导航栏分隔线颜色，默认0xDADADA
@property (nonatomic, strong) UIColor *customNavigationBarSeparatorColor;
/// 自定义导航栏显示分隔线，默认显示
@property (nonatomic, assign) BOOL customNavigationBarShowSeparator;

/// app使用系统导航栏的风格配置，内部默认为白色背景，黑色标题
@property (nonatomic, strong) UIColor *systemNavigationBarTintColor;
@property (nonatomic, strong) NSDictionary *systemNavigationBarTitleAttributes;

#pragma mark - 自定义通知属性设置
/// 是否显示IM连接状态提示
@property (nonatomic, assign) BOOL imStatusHidden;
/// 自定义铃声名称，如果需要自定义铃声，则需要进行赋值
@property (nonatomic, strong) NSString *bellName;
/// 自定义群聊消息铃声，如果需要自定义铃声，则需要进行赋值
@property (nonatomic, strong) NSString *groupBellName;

/// 自定义刷新类名
@property (nonatomic, strong) Class refreshHeaderClass;


- (void)setBellNameAndPlay:(NSString *)bellName;
- (void)setGroupBellNameAndplay:(NSString *)groupBellName;
- (void)setSystemSoundID_Vibrate:(BOOL)isGroup isOn:(BOOL)isOn isPlay:(BOOL)isplay;


/// 通知显示类型，默认是GLIMMessageNotifyShowStatusBar（状态栏）
@property (nonatomic, assign) GLIMMessageNotifyShowType notifyShowType;
/// 声音显示开关
@property (nonatomic, assign) BOOL isSoundOn;
/// 单聊震动显示开关
@property (nonatomic, assign) BOOL isVibrateOn;
/// 群震动显示开关 (单聊和群聊有不同业务，故拆分成单独开关)
@property (nonatomic, assign) BOOL isVibrateGroupOn;
/// 是否弹出本地通知
@property (nonatomic, assign) BOOL isLocalNotifyOn;

#pragma mark - 聊天页面的详细属性配置
/// 标题字体 默认 [UIFont boldSystemFontOfSize:18]
@property (nonatomic, strong) UIFont *titleFont;
/// 标题颜色 默认 [UIColor whiteColor]
@property (nonatomic, strong) UIColor *titleColor;
/// 快捷消息标题字体 默认 [UIFont system:]
@property (nonatomic, strong) UIFont *shortcutTitleFont;
/// 快捷消息标题颜色 默认 [UIColor blackColor]
@property (nonatomic, strong) UIColor *shortcutTitleColor;
/// 副标题字体 默认 [UIFont boldSystemFontOfSize:12]
@property (nonatomic, strong) UIFont *subFont;
/// 副标题颜色 [UIColor whiteColor]
@property (nonatomic, strong) UIColor *subColor;
/// 正在输入字体 [UIFont boldSystemFontOfSize:19]
@property (nonatomic, strong) UIFont *onImportFont;
/// 正在输入颜色 [UIColor whiteColor]
@property (nonatomic, strong) UIColor *onImportColor;
/// 屏蔽图标 用于单聊，[GLIMUIUtil imageFromBundleByName:@"GLIM_CHAT_BAN"]
@property (nonatomic, strong) UIImage *blockImage;
/// 屏蔽图标，用于群，[GLIMUIUtil imageFromBundleByName:@"GLIM_CHAT_BAN"]
@property (nonatomic, strong) UIImage *groupBlockImage;
/// 屏蔽图标，用于列表的单聊联系人 [GLIMUIUtil imageFromBundleByName:@"imGroupBlock"]
@property (nonatomic, strong) UIImage *listBlockImage;
/// 屏蔽图标，用于列表的群聊联系人 [GLIMUIUtil imageFromBundleByName:@"imGroupBlock"]
@property (nonatomic, strong) UIImage *groupListBlockImage;
/// 单聊用户官方图标key值, 买家:"official_label5", 卖家:"official_label6", 默认为"official_label6",
@property (nonatomic, copy) NSString *officialImageKey;
/// 快捷消息中单聊用户官方图标key，默认为"official_label5",
@property (nonatomic, copy) NSString *shortcutOfficialImageKey;

/// 业务属性，聊天页面是否显示消息来源视图，默认为NO，买家版设置为YES
@property (nonatomic, assign) BOOL isChatSourceViewHidden;

/// 群主图标
@property (nonatomic, strong) NSString *configGroupOwnerIconUrl;

/// 群管理员图标
@property (nonatomic, strong) NSString *configGroupManagerIconUrl;

///是否显示撤回引导
@property (nonatomic, assign, readonly) BOOL isShowWithdrawGuide;
///是否显示重新编辑引导
@property (nonatomic, assign, readonly) BOOL isShowReeditGuide;
///是否显示连续引导
@property (nonatomic, assign, readonly) BOOL isShowSoundContinuityPlayGuide;

@property (nonatomic, copy) NSString *tempChatListVcNavTitle;

//导航栏 右边按钮颜色
@property (nonatomic, strong) UIColor *navRightButtonTitleColor;


//买家版 UI 定制
//发送方超链接的颜色默认//白色
@property (nonatomic, strong) UIColor *selfSenderLinkColor;

//发送方文本的的颜色
@property (nonatomic, strong) UIColor *selfSenderTextColor;

//发送方背景的的颜色
@property (nonatomic, strong) UIColor *selfSenderBgColor;

//联系人列表分割线颜色
@property (nonatomic, strong) UIColor *recentListShowLineColor;

//字体配置
@property (nonatomic, strong) UIFont *recentListTitleFont;

@property (nonatomic, assign) NSInteger recentListHeadWHF;

@property (nonatomic, assign) NSInteger recentListH;

//语音的默认图
@property (nonatomic, strong) UIImage *audioImagesSelf;
//语音的动画组合 类型是 UIImage
@property (nonatomic, strong) NSArray *audioImagesSelfGiftList;
//买家版 UI 定制

//输入框背景色
@property (nonatomic, strong) UIColor *messageBottomViewViewBgColor;

//聊天背景颜色
@property (nonatomic, strong) UIColor *chatViewBgColor;


@property (nonatomic, strong) UIImage *searchNoDataImage;


#pragma mark - 联系人列表页面Cell配置
/// 临时消息聚合联系人未读消息数显示风格，默认是GLIMUIRecentChatUnreadShowNumber
@property (nonatomic, assign) GLIMUIRecentChatUnreadShowType combineChatShowType;

/**
 判断im临时消息联系人红点显隐藏状态
 结合临时消息未读数一起判断，只有临时消息未读数大于0的时候这个状态才有意义

 @return YES: 不显示红点, NO: 显示红点
 */
- (BOOL)imCombineRecentChatRedDotHidden;

/**
 为联系人列表页面注册新的联系人配置
 
 @param chatUIConfig 联系人配置（包括联系人Cell显示+点击逻辑）
 */
- (void)registChatUIConfig:(GLIMChatUIConfig *)chatUIConfig;

#pragma mark - 聊天页面消息Cell配置
/**
 为聊天页面注册新的消息配置
 
 @param messageUIConfig 消息配置（包括消息Cell显示+点击逻辑）
 */
- (void)registMessageUIConfig:(GLIMMessageUIConfig *)messageUIConfig;

#pragma mark - 聊天页面底部扩展栏配置
/**
 为聊天页面注册新的底部栏配置
 
 @param bottomActionItem 底部栏配置（包括按钮显示+点击逻辑）
 */
- (void)registMessageBottomAction:(GLIMMessageBottomActionItemData *)bottomActionItem;

#pragma mark - 聊天页面底部浮动栏配置

/// 为群聊聊天页面配置输入框顶部配置浮动视图（整个视图都由外部控制）
/// @param extendViewClassName 浮动视图类名
/// @param groupType 群类型
- (void)registerMessageBottomExtendView:(NSString *)extendViewClassName
                          withGroupType:(NSInteger)groupType;

/// 为群聊聊天页面配置输入框顶部浮动视图中的子视图（仅配置子视图）
/// @param extendSubViewClassName 外部浮动子视图类名
/// @param groupType 群类型
- (void)registerMessageBottomExtendSubView:(NSString *)extendSubViewClassName
                             withGroupType:(NSInteger)groupType;

#pragma mark - 聊天页面顶部配置
/**
 聊天页面顶部配置

 @param className 类名
 */
- (void)registChatTopViewWithClassName:(NSString *)className;

- (void)registChatListTopViewWithClassName:(NSString *)className;

/// 为聊天页面移除所有底部栏
- (void)removeAllMessageBottomActions;

#pragma mark - 自动回复



#pragma mark - 未读消息数

/**
 获取特殊联系人的未读消息数，
 所有特殊联系人未读消息总数，如需特殊定制请使用GLIMChatManager的getUnreadCountWithChatType:isTempChat:方法

 @param specialTypeArray 特殊联系人类型数组
 @return 未读消息数
 */
- (NSInteger)totalSpecialUnreadCountWithArray:(NSArray *)specialTypeArray;

/**
 获取所有被屏蔽联系人的未读消息数
 存在临时消息文件夹情况下 未读消息数 = 被屏蔽群消息总数+临时消息文件夹的红点状态（显示红点为1，隐藏红点为0）
 不存在临时消息文件夹情况下 未读消息数 = 被屏蔽群消息总数

 @return 未读消息数
 */
- (NSInteger)totalBlockedUnreadCount;

/**
 获取总的未读消息数（UI显示的数据，可能与数据库中不一致）
 在显示临时消息文件夹的情况下，买家版只显示单聊好友+群聊未屏蔽消息数

 @return 未读消息数
 */
- (NSInteger)totalNormalUnreadCount;

@end
