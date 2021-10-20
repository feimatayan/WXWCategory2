//
//  GLIMContact.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMBaseObject.h"


/**
  联系人实体，客户端定义用来封装一个会话的联系人，联系人可以是单个用户也可以是一个群
 */
@interface GLIMContact : GLIMBaseObject

/**
 联系人ID，可以是用户ID，也可以使群ID，由联系人子类设置
 */
@property (nonatomic, strong) NSString* contactID;

//真实 uid
@property (nonatomic, strong) NSString* realuserID;

@property (nonatomic, strong) NSString* firstUid;

/**
 联系人名称
 */
@property (nonatomic, strong) NSString* name;

/**
 联系人头像
 */
@property (nonatomic, strong) NSString* avatarURL;

/**
 消息来源
 */
@property (nonatomic, strong) NSDictionary* meessageSource;

/**
 是否被屏蔽了
 */
@property (nonatomic) BOOL blocked;

/// 名称拼音
@property (nonatomic, strong, readonly) NSString *pinyin;


/**
 不识别的新增联系人

 @return 默认为NO
 */
- (BOOL)isUnrecognized;

@end
