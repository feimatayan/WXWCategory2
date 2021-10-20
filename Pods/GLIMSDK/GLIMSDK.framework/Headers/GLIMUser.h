//
//  GLIMUser.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMContact.h"

typedef NS_ENUM(NSInteger, GLIMSpecialContactType)
{
    GLIMSpecialContactNone = 0,             // 普通联系人
    GLIMSpecialContactComment = 10010,      // 评论联系人
    GLIMSpecialContactXinDe = 10020,        // 心得联系人
    GLIMSpecialContactWxOfficial = 10090,   // 微信公众号
    GLIMSpecialContactOfflineMessagePool = 10091,   // 离线消息池
    GLIMSpecialContactWxProgram = 10092,    // 微信小程序
    GLIMSpecialContactBuyerTips = 10093,    // 买家心得
    GLIMSpecialContactRecivePraise = 10094, // 收到的赞
    GLIMSpecialContactCommentsAt = 10095,   // 评论和@
    GLIMSpecialContactCreatorCenter = 10096,// 创作者中心
    GLIMSpecialContactCircleManager = 10097,// 圈子管理员
    GLIMSpecialContactCircle = 10098,       // 圈子
    GLIMSpecialContactNewSpace = 10099,     // 新场地
};


/**
 用户信息实体
 */
@interface GLIMUser : GLIMContact

/**
 用户在IM系统的ID
 */
@property (nonatomic, strong) NSString* userID;

/**
 用户的微店店铺ID
 */
@property (nonatomic, strong) NSString* shopID;

/**
 用户的口袋购物ID，新老账号系统无法打通的遗留问题
 */
@property (nonatomic, strong) NSString* buyerID;


/**
 用户签名
 */
@property (nonatomic, strong) NSString* signature;

/**
 用户备注名
 */
@property (nonatomic, strong) NSString* alias;

/**
 用户昵称
 */
@property (nonatomic, strong) NSString* udcName;
/**
 额外信息 标记等
 */
@property (nonatomic, strong) NSDictionary* serviceMarks;

/**
 购买次数信息
 */
@property (nonatomic, assign) UInt16 dealCount;

/**
 好友关系 0-全部联系人 1-好友 2-非好友
 */
@property (nonatomic, assign) UInt16 friendType;

@property (nonatomic, strong) NSString* subAccountName;

@property (nonatomic, strong) NSString* firstReceShopName;

//子账号使用 正在接待联系人的子账号昵称。（最多7个字，超出展示...）
@property (nonatomic, strong) NSString* serviceUserName;
@property (nonatomic, strong) NSString* serviceUserUid;


@property (nonatomic, strong) NSString* shopName;

//进入微信小程序会话 会返回除了微信小程序的id 并且返回微店的id
@property (nonatomic, strong) NSString* imUid;
/// 进入普通联系人会话，如果有对应小程序uid，会返回小程序uid
@property (nonatomic, strong) NSString *miniUid;

/**
 联系人类型
 0 - 普通用户
 10010 - 评论
 ……
 */
@property (nonatomic, assign) UInt16 contactType;


#pragma mark - 额外信息
/// 个人资料页面官方角标
@property (nonatomic, strong, readonly) NSString *officialImageInDetail;
/// 联系人列表页面官方角标
@property (nonatomic, strong, readonly) NSString *officialImageInRecentList;
/// 聊天页面官方角标
@property (nonatomic, strong, readonly) NSString *officialImageInChat;

/**
 根据key来获取官方角标

 @param key 官方角标key值
 @return 官方角标链接
 */
- (NSString *)officialImageWithKey:(NSString *)key;

@end
