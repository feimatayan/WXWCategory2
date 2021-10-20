//
//  GLIMGroup.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMContact.h"

typedef NS_ENUM(NSInteger, GLIMGroupType) {
    GLIMGroupNone = 0,              //
    GLIMGroupBusiness = 1,          // 商学院
    GLIMGroupAssemble = 2,          // 抱团群
    GLIMGroupAssistance = 4,        // 互助群
    GLIMGroupRegularCustomer = 5,   // 回头客
    GLIMGroupLive = 7,              // 直播群
    GLIMGroupAgent = 8,             // 代理群
    GLIMGroupCard = 6,              // 打卡群
    GLIMGroupItems = 10,            // 商品群
    GLIMGroupCircle = 11,           // 圈子群
};

/// 群信息实体
@interface GLIMGroup : GLIMContact

/// 群ID
@property (nonatomic, copy) NSString *groupID;
/// 群类型
@property (nonatomic, assign) GLIMGroupType groupType;
/// 群昵称
@property (nonatomic, copy) NSString *groupAlias;
/// 群公告
@property (nonatomic, copy) NSString *groupNotice;
/// 群成员数
@property (nonatomic, assign) UInt16 membersCount;
/// 最后一条消息发送方名称
@property (nonatomic, copy) NSString *lastMessageSender;
/// 登录用户在群里的身份，因回头客业务于2018.07.12添加，取值参考GLIMGroupMemberIdentityType
@property (nonatomic, assign) UInt16 myMemberIdentify;
/// 群头像列表json字符串，因回头客业务于2018.07.11添加
@property (nonatomic, copy) NSString *groupAvatarInfos;

#pragma mark - 业务字段
/// 群显示头像列表，因回头客业务于2018.07.11添加
@property (nonatomic, strong) NSArray *groupAvatarUrlArray;
/// 群主的店铺ID，因买家版回头客群需要进群主店铺业务添加于2018.07.26添加
@property (nonatomic, copy) NSString *groupOwnerShopID;

/// 群公告置顶：1置顶 0不置顶
@property (nonatomic, assign) NSInteger noticeTop;
/// 业务扩展信息
@property (nonatomic, copy) NSString *groupExtends;


@end
