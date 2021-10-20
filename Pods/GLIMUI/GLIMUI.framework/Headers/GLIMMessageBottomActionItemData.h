//
//  GLIMMessageBottomActionItemData.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/3.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GLIMMessageBottomActionItemType) {
    GLIMMessageBottomActionImage = 100,                 // 相册
    GLIMMessageBottomActionQuickReply = 101,            // 快捷消息
    GLIMMessageBottomActionRecommandItem = 102,         // 推荐商品
    GLIMMessageBottomActionCarema = 103,                // 相机
    GLIMMessageBottomActionCustomerService = 105,       // 子客服转接
    GLIMMessageBottomActionScoreRedEnvelope = 106,      // 积分红包
    GLIMMessageBottomActionCoupon = 107,                // 优惠券
    GLIMMessageBottomActionScanFace = 108,              // 刷脸卡
    GLIMMessageBottomActionShortVideo = 111,            // 短视频
    GLIMMessageBottomActionCircleVideo = 206,           // 圈子群视频
    GLIMMessageBottomActionGroupActivities = 315,       // 团活动
    
    GLIMMessageBottomActionWDPaying = 1000,             // 微店收款
    
#pragma mark - 群聊
    GLIMMessageBottomActionGroupAssemble = 201,         // 抱团群互推活动
    GLIMMessageBottomActionGroupRegularCustomer = 202,  // 回头客群专享优惠
    GLIMMessageBottomActionGroupAssembleCoupon = 203,   // 互助群跨店优惠券
    GLIMMessageBottomActionGroupShopRedEnvelope = 204,  // 店铺红包
};

typedef NS_ENUM(NSInteger, GLIMMessageBottomActionExtendType) {
    GLIMMessageBottomActionExtendNone = 0,  // 不可扩展
    GLIMMessageBottomActionExtendH5 = 1,    // H5扩展
};

@class GLIMMessage;
@class GLIMMessageBottomView;
@class GLIMChat;

typedef void (^actionFinishedBlock)(GLIMMessage *message);
typedef void (^actionInputBlock)(GLIMMessageBottomView *inputView, actionFinishedBlock block);

@interface GLIMMessageBottomActionItemData : NSObject

/// action类型
@property (nonatomic, assign) GLIMMessageBottomActionItemType actionType;

/// 按钮标识，用于区分不同item
@property (nonatomic, copy, readonly) NSString *itemID;

/// 是否支持扩展, 0 不支持，1 支持，默认是0
@property (nonatomic, assign) GLIMMessageBottomActionExtendType extendType;

/// 按钮标题
@property (nonatomic, copy) NSString *itemName;
/// 按钮图标名称——正常态（图片存放在SDK内部时使用该属性）
@property (nonatomic, copy) NSString *normalImageName;
/// 按钮图标名称——高亮态（图片存放在内部时使用该属性）
@property (nonatomic, copy) NSString *highlightImageName;
/// 按钮图标——正常态（图片存放在SDK外部时使用该属性）
@property (nonatomic, copy) UIImage *normalImage;
/// 按钮图标——高亮态（图片存放在SDK外部时使用该属性）
@property (nonatomic, copy) UIImage *highlightImage;
/// 按钮图标——正常态（从服务器获取显示图片）
@property (nonatomic, copy) NSString *normalImageUrl;
/// 按钮图标——高亮态（从服务器获取显示图片）
@property (nonatomic, copy) NSString *highlightImageUrl;
/// 原本设计用来控制按钮的显隐藏的，暂不处理
@property (nonatomic, assign) BOOL hidden;
/// 按钮跳转链接
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, strong) NSArray *jumpUrlArray;

/// 角标， 是否有角标
@property (nonatomic, assign) BOOL hasBadge;
/// 记录按钮的角标显示状态的key值，仅hasBadge为YES时有效
@property (nonatomic, strong) NSString *badgeKey;
/// 角标是否显示，仅hasBadge为YES且badgeKey不为空时有效
@property (nonatomic, assign) BOOL shouldShowBadge;

/// 是否显示提示信息，默认不显示，由服务器配置
@property (nonatomic, assign) BOOL showPrompt;
/// 提示信息，默认为空，由服务器配置
@property (nonatomic, copy) NSString *prompt;

/// 回调函数，传递给接收方底部视图和接收函数，接收方构造好基本的消息后通过接收函数回传给聊天页面
@property (nonatomic, strong) actionInputBlock inputBlock;

/// 扩展信息，暂为空，后续用于控制actionItem的显隐藏或其他状态
@property (nonatomic, strong) NSArray *extendInfos;

+ (instancetype)actionItemData;

/// 是否支持当前action，默认为YES
- (BOOL)supportAction;

/// 获取当前聊天对象
- (GLIMChat *)currentTalkingChatFromParentView:(GLIMMessageBottomView *)parentView;

#pragma mark - 自定义actionItemData

#pragma mark - H5 actionItemData
/**
 完整的跳转链接

 @param params 跳转参数，格式如下：
 @return 完整的跳转链接
 */
- (NSString *)fullJumpUrlWithParams:(NSDictionary *)params;

/**
 根据服务器下发的字典信息解析属性

 @param propertyInfos 属性字典
 */
- (void)parsePropertiesWithRemoteDictionary:(NSDictionary *)propertyInfos;

/// 生成属性字典
- (NSDictionary *)propertyDictionary;
/// 从字典中获取属性
- (void)copyPropertiesFromDictionary:(NSDictionary *)propertyDict;

@end
