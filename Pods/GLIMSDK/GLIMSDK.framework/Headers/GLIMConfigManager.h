//
//  GLIMConfigManager.h
//  GLIMSDK
//
//  Created by 六度 on 2017/2/25.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GLIMNOTIFICATION_LOAD_CONFIG_SUCCESS    @"GLIMNOTIFICATION_LOAD_CONFIG_SUCCESS"

@interface GLIMConfigManager : NSObject

#pragma mark - 通知属性，来源数组
@property (nonatomic, strong) NSDictionary *configDict;

#pragma mark - Emoji属性
/// emoji表情版本：0-旧版本，1-新版本 （默认使用新版本）
@property (nonatomic, assign) NSInteger emojiVersion;
@property (nonatomic, strong) NSMutableArray *emojiPackageArray;
// 0-关闭消息状态展示 1-开启消息状态展示
@property (nonatomic, assign) NSInteger msgStatusFlag;

@property (nonatomic, assign) NSInteger mark_unread_switch;

// 发送图片消息前二维码检查开关，0 - 关闭， 1 - 开启
@property (nonatomic, assign) NSInteger send_image_scan_qrcode_switch;

//@property (nonatomic, strong) NSArray *add_group_welcome_msg;

//flutter  开启0 关闭1 (默认0 开启)
@property (nonatomic, assign) NSInteger flutter_ios_close;

//客服在线时间入口 是否展示
@property (nonatomic, assign) NSInteger customerServiceWorkTimeFlag;

//联系人默认显示的个数
@property (nonatomic, assign) NSInteger defaultNeedShowChatNum;
// 毫秒
@property (nonatomic, assign) NSInteger ios_resend_timeout;

@property (nonatomic, assign) NSInteger open_search_msg;

//默认 Demo 支持
@property (nonatomic, assign) BOOL isSupportDemoTestFunction;

@property (nonatomic, assign) NSInteger promotion_auto_msg_switch;

#pragma mark - CardMessageTemplate

#pragma mark - 身份标识
/// 群主图标
@property (nonatomic, strong, readonly) NSString *groupOwnerIconUrl;
/// 群管理员图标
@property (nonatomic, strong, readonly) NSString *groupManagerIconUrl;
/// 员工图标
@property (nonatomic, strong, readonly) NSString *weidianStaffIconUrl;
/// 讲师图标
@property (nonatomic, strong, readonly) NSString *lecturerIconUrl;

#pragma mark - 开关配置
/// 0 自动上传，1 直接上传，2 分片上传，默认为1
@property (nonatomic, assign) NSInteger fileUploadPolicy;

+ (instancetype)shareConfig;

/// 加载配置信息（从服务器请求）
- (void)loadConfig;

#pragma mark - 消息已读未读状态
- (BOOL)supportMessageReadStatus;

#pragma mark - 群相关配置
/**
 获取指定群详情H5链接

 @param groupID     群ID
 @param groupType   群类型
 @return 群详情H5链接
 */
- (NSString *)groupDetailUrlWithGroupID:(NSString *)groupID
                           andGroupType:(NSInteger)groupType;

/**
 获取指定群成员详情H5链接

 @param memberID    成员ID
 @param groupID     群ID
 @param groupType   群类型
 @return 群成员详情H5链接
 */
- (NSString *)groupMemberDetailUrlWithMemberID:(NSString *)memberID
                                    andGroupID:(NSString *)groupID
                                     groupType:(NSInteger)groupType;


/**
 获取指定群配置
 @param groupType   群类型
 */
- (NSDictionary *)groupConfigWithGroupType:(NSInteger)groupType;

#pragma mark - 回访消息相关配置
- (NSDictionary *)returnVisitConfigWithReturnVisitType:(NSInteger)returnVisitType;

#pragma mark - 卡片模板
/**
 根据卡片类型获取对应的模板类型

 @param cardType 卡片类型
 @return 模板类型
 */
- (NSInteger)cardMessageTemplateWithCardType:(NSInteger)cardType;


- (NSArray *)groupWelcomeListWithGroupType:(NSInteger)groupType;

#pragma mark - 核对订单

/// 返回订单地址修改链接
/// @param type 类型：1 -  地址修改链接，2 -  地址选择链接
- (NSString *)orderAddressUrlFormatWithType:(NSInteger)type;

@end
