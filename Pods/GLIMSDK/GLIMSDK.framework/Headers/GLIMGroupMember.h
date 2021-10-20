//
//  GLIMGroupMember.h
//  GLIMSDK
//
//  Created by huangbiao on 2018/3/7.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import "GLIMBaseObject.h"
#import "GLIMGroup.h"

/// 标识所有人的uid，主要用于@成员列表
#define kGLIMGroupMemberAllOneUID   @"6000000000000000000"

typedef NS_ENUM(NSInteger, GLIMGroupMemberIdentityType)
{
    GLIMGroupMemberIdentityNone,        // 普通成员
    GLIMGroupMemberIdentityOwner = 1,   // 群主
    GLIMGroupMemberIdentityManager = 2, // 群管理员
};

typedef NS_ENUM(NSInteger, GLIMGroupMemberStaffType) {
    GLIMGroupMemberStaffNone = 0,       // 非微店成员
    GLIMGroupMemberStaffWeidian = 1,    // 微店员工
};

typedef NS_ENUM(NSInteger, GLIMGroupMemberExistStatus) {
    GLIMGroupMemberExistNormal, // 正常状态
    GLIMGroupMemberExistQuit,   // 退出状态
};

/// 群成员实体
@interface GLIMGroupMember : GLIMBaseObject

/// 群成员表唯一标识，主键（禁止外部赋值）
@property (nonatomic, copy) NSString *memberUniqueID;
/// 群ID
@property (nonatomic, copy) NSString *groupID;
/// 群成员im账号ID
@property (nonatomic, copy) NSString *groupMemberID;
/// 群成员的userID
@property (nonatomic, copy) NSString *groupMemberSID;
/// 群成员的shopID（因回头客群点击群主头像需要跳转到群主店铺而添加于20180719）
@property (nonatomic, copy) NSString *groupMemberShopID;
/// 群成员名称 (由于群复用GLIMUser信息时会导致后端请求群成员接口查询量大，所以群成员表自己维护用户信息)
@property (nonatomic, copy) NSString *groupMemberName;
/// 群成员头像 (由于群复用GLIMUser信息时会导致后端请求群成员接口查询量大，所以群成员表自己维护用户信息)
@property (nonatomic, copy) NSString *groupMemberAvatar;
/// 群成员昵称
@property (nonatomic, copy) NSString *groupMemberAlias;
/// 群成员身份
@property (nonatomic, assign) NSInteger groupMemberIdentity;
/// 群成员有效性（是否已退群）
@property (nonatomic, assign) NSInteger groupMemberExist;
/// 拼音用于群成员排序
@property (nonatomic, copy, readonly) NSString *pinYin;
/// 员工身份 0-非员工 1-员工
@property (nonatomic, assign) NSInteger groupStaffIdentity;

@property (nonatomic, assign) GLIMGroupType groupType;

/**
 根据成员ID和群ID获取群成员信息

 @param memberID 群成员ID
 @param groupID 群ID
 @return 群成员信息
 */
+ (instancetype)queryByMemberID:(NSString *)memberID andGroupID:(NSString *)groupID;

/// 群成员显示名称
- (NSString *)memberDisplayName;

/// 返回字典信息
- (NSDictionary *)memberInfo;

@end
